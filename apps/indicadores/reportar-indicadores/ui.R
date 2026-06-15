page_navbar(
    title = "DARF − MANTA",
    theme = bs_theme(preset = "sandstone", version = 5),
    navbar_options = navbar_options(position = "fixed-top", theme = "dark", underline = FALSE),

    includeCSS("../../../static/ui.css"),

    nav_menu(
        title = "INDICADORES",

        nav_item(tags$a("REGISTRAR INDICADOR", href = "/indicadores/registrar-indicador")),

        nav_panel(
            title = "REPORTAR INDICADORES",
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
                    dateRangeInput("reportRange", language = "es", separator = "-",
                                   "Seleccione la fecha inicial y final del reporte:",
                                   format = "dd / mm / yyyy", weekstart = 1),
                    actionButton("report", "REPORTAR"),
                    br(), br(),
                    tableOutput("reportTable")
                )
            )
        )
    ),

    nav_item(tags$a("IDENTIFICAR PUNTO", href = "/identificar-punto"))
)
