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
        # capturar error, en caso de ocurrir
        }, error = function(err) stop(safeError(err$message)))
    )

    # ejecutar al presionar el botón REPORTAR
    observeEvent(input$report,
        tryCatch( {
            if(input$reportRange[1] > input$reportRange[2]) {
                stop("La fecha inicial debe ser menor o igual que la final.")
            }

            pg_resp = "SELECT * FROM users_records WHERE timestamp > '" |>
                paste0(input$reportRange[1], " 00:00' AND timestamp < '") |>
                paste0(input$reportRange[2] + 1, " 00:00'")

            # obtener los registros de la base de datos
            pg_resp = dbGetQuery(pg_conn, pg_resp) |>
                dplyr::mutate(timestamp = format(timestamp, "%d / %m / %Y %H:%M"))

            if(nrow(pg_resp) == 0) stop("No existen registros en las fechas seleccionadas.")

            # renderizar tabla con los registros
            names(pg_resp) = c("Fecha de registro", "Funcionario", "Indicador", "Cantidad")
            output$reportTable = renderTable(pg_resp, border = TRUE)
        # notificar error, en caso de ocurrir
        }, error = function(err) showNotification(err$message, duration = 2, type = "error"))
    )

    # desconectar la base de datos
    onSessionEnded(function() dbDisconnect(pg_conn))
}
