page_navbar(
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

                    login_ui("shiny-apps"),

                    is_logged_in("shiny-apps",
                        span("Ha iniciado sesión como:"),
                        textOutput("loggedUser", inline = TRUE)
                    ),

                    logout_button("shiny-apps", icon = NULL)
                ),

                is_logged_in("shiny-apps",
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
)
