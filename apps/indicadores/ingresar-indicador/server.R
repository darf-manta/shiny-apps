function(input, output, session) {

    if(! "cookies" %in% names(sessionInfo()$otherPkgs)) {
        #progress_function("Package cookies missing, loading...", 0.000)

        suppressPackageStartupMessages( { library(cookies) } )
    }

    # onRestored(function(state) {
    #     loggedUser = get_cookie("loggedUser", session = session)
    #     updateTextInput(session, "loggedUser", value = loggedUser)
    # }, session = session)

    # ejecutar al cargar la página o actualizar la cookie
    observeEvent(get_cookie("loggedUserShiny", session = session),
        tryCatch( {
            logged_user = get_cookie("loggedUserShiny", session = session)

            output$logoutUser = renderText(paste("Ha iniciado sesión como:", logged_user))
            updateTextInput(session, "loggedUser", value = logged_user)
            updateTextInput(session, "loginPass", value = "")
        # capturar error, en caso de ocurrir
        }, error = function(err) stop(safeError(err$message)))
    )

    # ejecutar al presionar el botón CERRAR SESIÓN
    observeEvent(input$logout,
        tryCatch( {
            updateTextInput(session, "loggedUser", value = "")

            remove_cookie("loggedUserShiny", session = session)
            showNotification("Se cerró la sesión correctamente.", duration = 3)
        # capturar error, en caso de ocurrir
        }, error = function(err) stop(safeError(err$message)))
    )

    # ejecutar al presionar el botón INICIAR SESIÓN
    observeEvent(input$login,
        tryCatch( {
            logged_user = postgres_connect(input$loginUser, input$loginPass, "riesgodb")

            set_cookie("loggedUserShiny", logged_user, session = session)
            showNotification("Se inició la sesión correctamente.", duration = 3)
        # notificar error, en caso de ocurrir
        }, error = function(err) {
            showNotification(safeError(err$message), duration = 3, type = "error")

            updateTextInput(session, "loginUser", value = "")
            updateTextInput(session, "loginPass", value = "")
        } )
    )
}
