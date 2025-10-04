page_navbar(
    title = "DARF − MANTA",
    position = "fixed-top",
    fillable = FALSE,
    inverse = TRUE,
    underline = FALSE,

    theme = bs_theme(preset = "sandstone", version = 5),

    includeCSS("../../static/ui.css"),

    nav_panel(
        title = "IDENTIFICAR PUNTO",
        layout_sidebar(
            sidebar = sidebar(
                open = list(desktop = "always", mobile = "always-above"),
                accordion(
                    id = "method",
                    multiple = FALSE,

                    accordion_panel(
                        title = "POR COORDENADAS",
                        paste("Ingrese la coordenada geográfica o UTM",
                              "(en cualquier orden) del punto a identificar:"),
                        textInput("text1", NULL, placeholder = "primer valor"),
                        textInput("text2", NULL, placeholder = "segundo valor"),
                    ),

                    accordion_panel(
                        title = "POR FOTOGRAFÍA",
                        "Cargue una foto georreferenciada del punto a identificar:",
                        fileInput("file1", NULL, placeholder = "ningún archivo",
                                  buttonLabel = "SELECCIONAR", accept = "image/*"),
                    )
                ),
                actionButton("identify", "IDENTIFICAR")
            ),
            navset_tab(
                nav_panel("DATOS", br(), tableOutput("simple_data"))
            )
        )
    ),

    nav_item(tags$a("HELLO WORLD", href = "/sample-apps/hello"))
)
