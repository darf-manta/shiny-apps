page_navbar(
    title = "DARF − MANTA",
    position = "fixed-top",
    fillable = FALSE,
    inverse = FALSE,
    underline = FALSE,

    theme = bs_theme(preset = "sandstone", version = 5),

    includeScript("../../static/getLocation.js"),
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
                        textInput("text2", NULL, placeholder = "segundo valor")
                    ),

                    accordion_panel(
                        title = "POR FOTOGRAFÍA",
                        "Cargue una foto georreferenciada del punto a identificar:",
                        fileInput("file1", NULL, placeholder = "ningún archivo",
                                  buttonLabel = "SELECCIONAR", accept = "image/*")
                    ),

                    accordion_panel(
                        title = "POR UBICACIÓN",
                        paste("Permita a este sitio web acceder a su ubicación GPS",
                              "(solamente es funcional en dispositivos móviles)")
                    )
                ),
                actionButton("identify", "IDENTIFICAR")
            ),
            navset_tab(
                nav_panel("DATOS", br(), tableOutput("simple_data"))
            )
        )
    )

    #nav_item(tags$a("HELLO WORLD", href = "/sample-apps/hello"))
)
