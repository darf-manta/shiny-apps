navbarPage(
    "DARF — MANTA",
    tabPanel(
        "IDENTIFICAR PUNTO",
        sidebarPanel(
            textInput("text1", ""),
            textInput("text2", ""),
            br(),
            actionButton("identify", "IDENTIFICAR")
        ),
        mainPanel(
            tabsetPanel(
                tabPanel(
                    "RESULTADOS",
                    br(),
                    uiOutput("result")
                ),
            )
        )
    ),
    theme = shinythemes::shinytheme("sandstone")
)
