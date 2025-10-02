page_navbar(
    title = "DARF — MANTA",
    position = "fixed-top",
    fillable = FALSE,
    inverse = FALSE,
    underline = FALSE,

    theme = bs_theme(preset = "sandstone", version = 5),

    includeCSS("../../static/ui.css"),

    nav_panel(
        title = "IDENTIFICAR PUNTO",
        layout_sidebar(
            sidebar = sidebar(
                accordion(
                    multiple = FALSE,
                    accordion_panel(
                        title = "POR COORDENADAS",
                        textInput("text1", ""),
                        textInput("text2", ""),
                    # ),
                    # accordion_panel(
                    #     title = "POR IMAGEN",
                    #     fileInput("file1", ""),
                    )
                ),
                actionButton("identify", "IDENTIFICAR")
            ),
            navset_tab(
                nav_panel("DATOS", br(), tableOutput("simple_data"))
            )
        )
    ),

    nav_item(tags$a("HELLO WORLD", href = "sample-apps/hello"))
)
