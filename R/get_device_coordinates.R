# una función para obtener las coordenadas geográficas del dispositivo
get_device_coordinates = function(session, input) {

    # ejecutar el handler definido en getLocation.js
    session$sendCustomMessage("getLocation", "message")

    # otorgar un tiempo para que se ejecute el handler
    Sys.sleep(1.20)

    # validar los valores obtenidos por el handler
    if(is.null(input$identify_lon)) stop("No fue posible determinar su ubicación, reintente.")

    longitude = as.double(input$identify_lon)
    if(is.na(longitude)) stop(input$identify_lon)

    latitude = as.double(input$identify_lat)
    if(is.na(latitude)) stop(input$identify_lat)

    # crear el punto en coordenadas geográficas
    point = st_sfc(st_point(c(longitude, latitude)), crs = 4326)

    # validar que el punto se encuentre dentro del límite
    if(! any(st_within(point, LIMITE, sparse = FALSE))) {
        stop("La coordenada ingresada es válida, pero se encuentra fuera del límite cantonal.")
    }

    # devolver el punto validado
    return(st_sf(geom = point))
}
