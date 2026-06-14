function(input, output, session) {
    # conectar la base de datos
    pg_conn = postgres_connect("riesgodb")

    # iniciar sesión o restaurar la cookie
    logged = login_server("shiny-apps",
        pg_conn, cookie_name = "shiny-apps-username", cookie_expiration = 90,
        additional_fields = c("person_name", "person_mail", "person_area"),
        username_label = "Usuario:", password_label = "Contraseña:", enclosing_panel = div
    )

    observeEvent(logged$logged_in,
        tryCatch( {
            # mostrar el usuario de la sesión
            output$loggedUser = renderText(logged$person_name)

            # seleccionar el área del usuario
            updateRadioButtons(session, "indicatorType", selected = logged$person_area)
        # capturar error, en caso de ocurrir
        }, error = function(err) stop(safeError(err$message)))
    )

    observeEvent(input$indicatorType,
        tryCatch( {
            pg_resp = "SELECT indicator FROM users_indicators WHERE area = '"
            pg_resp = dbGetQuery(pg_conn, paste0(pg_resp, input$indicatorType, "'"))

            # actualizar los indicadores disponibles
            updateSelectInput(session, "indicator", choices = c("", pg_resp$indicator))
        # capturar error, en caso de ocurrir
        }, error = function(err) stop(safeError(err$message)))
    )

    # desconectar la base de datos
    onSessionEnded(function() dbDisconnect(pg_conn))
}
