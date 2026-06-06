cookies::add_cookie_handlers(page_navbar(
    title = "DARF − MANTA",
    theme = bs_theme(preset = "sandstone", version = 5),
    navbar_options = navbar_options(position = "fixed-top", theme = "dark", underline = FALSE),

    includeCSS("../../../static/ui.css"),

    nav_menu(
        title = "INDICADORES",

        nav_panel(
            title = "REGISTRAR INDICADOR",
            layout_sidebar(
                fillable = FALSE,
                sidebar = sidebar(
                    open = list(desktop = "always", mobile = "always-above"),
                    conditionalPanel("false", textInput("loggedUser", NULL)),

                    conditionalPanel(
                        "!input.loggedUser",

                        "Inicie sesión para poder utilizar esta herramienta:",
                        textInput("loginUser", NULL, placeholder = "usuario"),
                        passwordInput("loginPass", NULL, placeholder = "contraseña"),
                        actionButton("login", "INICIAR SESIÓN")
                    ),

                    conditionalPanel(
                        "input.loggedUser",

                        textOutput("logoutUser", inline = TRUE),
                        actionButton("logout", "CERRAR SESIÓN")
                    )
                ),

                conditionalPanel(
                    "input.loggedUser",

                    radioButtons("indicatorType", "Seleccione el indicador:",
                                 c("Ambiente", "Riesgos", "Fauna"), inline = TRUE),
                    selectInput("indicator", NULL, c("", "Ambiente", "Riesgos", "Fauna")),
                    numericInput("indicatorValue", "Ingrese el valor del indicador:", 1, 1),
                    actionButton("register", "REGISTRAR")
                )
            )
        ),

        nav_item(tags$a("REPORTAR INDICADORES", href = "/indicadores/reportar-indicadores"))
    ),

    nav_item(tags$a("IDENTIFICAR PUNTO", href = "/identificar-punto"))
))
