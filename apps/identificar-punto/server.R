function(input, output, session) {
    # ejecutar al presionar el botón IDENTIFICAR
    simple_point = eventReactive(input$identify,
        tryCatch( {
            # cancelar ejecución si ningún accordion está desplegado
            if(is.null(input$method)) stop("Seleccione un método de identificación.")

            # alternar el método según el accordion desplegado
            switch(input$method,
                # crear un punto con las coordenadas ingresadas
                "POR COORDENADAS" = validate_coordinates(input$text1, input$text2),

                "POR GOOGLE MAPS" = get_ggmaps_coordinates(input$text3),

                # obtener el punto con la ubicación del dispositivo
                "POR UBICACIÓN" = get_device_coordinates(session, input),

                # extraer el punto de una fotografía georreferenciada
                "POR FOTOGRAFÍA" = if(! is.null(input$file1)) {
                    extract_photo_coordinates(input$file1$datapath)
                } else stop("No se ha cargado una fotografía.")
            )
        # capturar error, en caso de ocurrir
        }, error = function(error) stop(safeError(error$message)))
    )

    # renderizar tabla
    output$simple_data = renderTable( {
        # unir datos de las coberturas al punto
        point = simple_point() |>
            st_join(BARRIO_SECTOR, st_within) |>
            st_join(PUGS_ESTRUCTURANTE, st_within) |>
            st_join(PUGS_USO_SUELO, st_within)

        point_geo = paste(
            c("Latitud:", "Longitud:"), collapse = ", ",
            st_coordinates(point) |> round(5) |> rev()
        )

        # calcular coordenadas UTM del punto
        point_utm = paste(
            c("Este:", "Norte:"), collapse = ", ",
            st_coordinates(st_transform(point, crs = UTM_EPSG)) |> round(0)
        )

        point_utm_zone = paste0(UTM_EPSG %% 100, ifelse(UTM_EPSG > 32700, "S", "N"))

        # preparar tabla para la pestaña DATOS
        dplyr::tribble(
            ~key,                                          ~value,
            "Coordenadas geográficas",                     point_geo,
            paste("Coordenadas UTM Zona", point_utm_zone), point_utm,
            "Parroquia",                                   point$parroquia,
            "Sector",                                      point$sector,
            "Barrio",                                      point$barrio,
            "Clasificación (PUGS 2025)",                   point$clasificac,
            "Subclasificación (PUGS 2025)",                point$subclasifi,
            "Uso general del suelo",                       point$uso_genera,
            "Uso específico del suelo",                    point$uso_especi
        )
    }, border = TRUE)

    # renderizar mapa
    output$simple_map = tmap::renderTmap( {
        # requerir el punto
        point = simple_point()

        # crear una barra de progreso
        progress = Progress$new()
        on.exit(progress$close())

        progress$set(0, NA, "Initializing plotter...")

        # preparar mapa para la pestaña MAPA
        map_point_landuse(
            point,

            # leer desde .Renviron
            Sys.getenv("STORAGE"),
            Sys.getenv("GOOGLE_SATELLITE"),

            # definir delta y offset del mapa base
            # se recomienda conocer previamente estos datos
            basemap_delta = c(0.250, -0.250),
            basemap_offset = c(-9007271.390720, -103382.049840),

            point_icon = tmap::tmap_icons("../../static/mapPin.png", just = c(0.5, 0.9)),
            progress_function = function(detail, value) progress$set(value, NA, detail)
        )
    }, mode = "plot")
}
