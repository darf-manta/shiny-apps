function(input, output, session) {

    if(! "cookies" %in% names(sessionInfo()$otherPkgs)) {
        #progress_function("Package cookies missing, loading...", 0.000)

        suppressPackageStartupMessages( { library(cookies) } )
    }

    # ejecutar al cargar la página
    observeEvent(TRUE,
        tryCatch( {
            logged_user = get_cookie("loggedUserShiny", session = session)
            if(length(logged_user) != 0) {
                showNotification("Se inició la sesión correctamente.", duration = 2)
            }

            output$logoutUser = renderText(logged_user)
        # capturar error, en caso de ocurrir
        }, error = function(err) stop(safeError(err$message))),
        once = TRUE
    )

    # ejecutar al presionar el botón CERRAR SESIÓN
    observeEvent(input$logout,
        tryCatch( {
            output$logoutUser = renderText("")

            remove_cookie("loggedUserShiny", session = session)
            showNotification("Se cerró la sesión correctamente.", duration = 2)
        # capturar error, en caso de ocurrir
        }, error = function(err) stop(safeError(err$message)))
    )

    # ejecutar al presionar el botón INICIAR SESIÓN
    observeEvent(input$login,
        tryCatch( {
            showNotification("Verificando usuario y contraseña...", duration = 2)
            logged_user = postgres_connect(input$loginUser, input$loginPass, "riesgodb")

            set_cookie("loggedUserShiny", logged_user, session = session)
            session$reload()
        # notificar error, en caso de ocurrir
        }, error = function(err) showNotification(err$message, duration = 2, type = "error"))
    )
}
