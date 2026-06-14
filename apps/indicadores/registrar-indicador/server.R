function(input, output, session) {
    # conectar la base de datos
    pg_conn = postgres_connect("riesgodb")

    # iniciar sesión o restaurar la cookie
    logged = login_server("indicadores/registrar-indicador",
        pg_conn, username_label = "Usuario:", password_label = "Contraseña:",
        additional_fields = c("person_name", "person_mail", "person_area"),
        enclosing_panel = div
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

    # desconectar la base de datos
    onSessionEnded(function() dbDisconnect(pg_conn))
}
