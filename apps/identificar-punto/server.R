function(input, output, session) {
    result = eventReactive(input$identify, {
        validate_coordinates(input$text1, input$text2) |>
            capture.output() |> paste(collapse = "<br>")
    } )

    output$result = renderUI(HTML(result()))
}
