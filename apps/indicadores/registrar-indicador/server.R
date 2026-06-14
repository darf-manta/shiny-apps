function(input, output, session) {
    # conectar la base de datos
    pg_conn = postgres_connect("riesgodb")

    # iniciar sesión o restaurar la cookie
    logged = login_server("shiny-apps",
        pg_conn, cookie_name = "shiny-apps-username", cookie_expiration = 90,
        additional_fields = c("person_name", "person_mail", "person_area"),
        username_label = "Usuario:", password_label = "Contraseña:", enclosing_panel = div
    )

    # ejecutar al iniciar sesión
    observeEvent(logged$logged_in,
        tryCatch( {
            # mostrar el usuario de la sesión
            output$loggedUser = renderText(logged$person_name)

            # seleccionar el área del usuario
            updateRadioButtons(session, "indicatorType", selected = logged$person_area)
        # capturar error, en caso de ocurrir
        }, error = function(err) stop(safeError(err$message)))
    )

    # ejecutar al cambiar el tipo de indicador
    observeEvent(input$indicatorType,
        tryCatch( {
            pg_resp = "SELECT indicator FROM users_indicators WHERE area = '"
            pg_resp = dbGetQuery(pg_conn, paste0(pg_resp, input$indicatorType, "'"))

            # actualizar los indicadores disponibles
            updateSelectInput(session, "indicator", choices = c("", pg_resp$indicator))
        # capturar error, en caso de ocurrir
        }, error = function(err) stop(safeError(err$message)))
    )

    # ejecutar al presionar el botón REGISTRAR
    observeEvent(input$register,
        tryCatch( {
            if(input$indicator == "") stop("Debe seleccionar el indicador.")
            if(is.na(input$value) || input$value < 1) {
                stop("Debe ingresar una cantidad válida del indicador.")
            }

            # crear el nuevo registro
            new_row = data.frame(
                timestamp       = Sys.time(),
                person          = logged$person_name,
                indicator       = input$indicator,
                indicator_value = input$value
            )

            # añadir el nuevo registro a la base de datos
            dbAppendTable(pg_conn, "users_records", new_row)
            showNotification("Se registró el indicador correctamente.", duration = 2)

            updateSelectInput(session, "indicator", selected = "")
            updateNumericInput(session, "value", value = NA)
        # notificar error, en caso de ocurrir
        }, error = function(err) showNotification(err$message, duration = 2, type = "error"))
    )

    # desconectar la base de datos
    onSessionEnded(function() dbDisconnect(pg_conn))
}
