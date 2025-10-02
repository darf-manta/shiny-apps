function(input, output, session) {
    result = eventReactive(
        # ejecutar al presionar el botón IDENTIFICAR
        input$identify,
        tryCatch( {
            # crear un punto con los valores ingresados
            point = validate_coordinates(input$text1, input$text2) |>
                # unir datos de las coberturas al punto
                st_join(PUGS_ESTRUCTURANTE, st_within)

            # preparar tabla para la pestaña DATOS
            tribble(
                ~key,               ~value,
                "Clasificación",    point$clasificac,
                "Subclasificación", point$subclasifi
            ) },
            # capturar error, en caso de ocurrir
            error = function(error) paste("Error:", error$message)
        )
    )

    # renderizar tabla
    output$simple_data = renderTable(result(), border = TRUE)
}
