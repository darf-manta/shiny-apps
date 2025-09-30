# una función para validar un punto ingresado en coordenadas UTM o geográficas
validate_coordinates = function(coordinate1, coordinate2) {
    # validar valores ingresados
    coordinate1 = as.double(coordinate1)
    if(is.na(coordinate1)) stop("Corregir el primer valor ingresado.")

    coordinate2 = as.double(coordinate2)
    if(is.na(coordinate2)) stop("Corregir el segundo valor ingresado.")

    # definir límites UTM válidos
    min_east = 166021.44
    max_east = 833978.56
    min_north = if_else(UTM_EPSG > 32700, 1116915.04, 0.00)
    max_north = if_else(UTM_EPSG > 32700, 10000000.00, 9329005.18)

    # definir limites geográficos válidos
    min_latitude = if_else(UTM_EPSG > 32700, -80.00, 0.00)
    max_latitude = if_else(UTM_EPSG > 32700, 0.00, 84.00)
    min_longitude = 6*(UTM_EPSG %% 100 - 1) - 180.00
    max_longitude = 6*(UTM_EPSG %% 100) - 180.00

    error = "La coordenada ingresada no es válida."

    # validar coordenadas geográficas
    if(between(coordinate1, min_latitude, max_latitude)) {
        if(between(coordinate2, min_longitude, max_longitude)) {
            coordinates = c(coordinate2, coordinate1)
            epsg = 4326
        } else error = "La coordenada geográfica ingresada no es válida."
    }
    if(between(coordinate2, min_latitude, max_latitude)) {
        if(between(coordinate1, min_longitude, max_longitude)) {
            coordinates = c(coordinate1, coordinate2)
            epsg = 4326
        } else error = "La coordenada geográfica ingresada no es válida."
    }

    # validar coordenadas UTM
    if(between(coordinate1, min_east, max_east)) {
        if(between(coordinate2, min_north, max_north)) {
            coordinates = c(coordinate1, coordinate2)
            epsg = UTM_EPSG
        } else error = "La coordenada UTM ingresada no es válida."
    }
    if(between(coordinate2, min_east, max_east)) {
        if(between(coordinate1, min_north, max_north)) {
            coordinates = c(coordinate2, coordinate1)
            epsg = UTM_EPSG
        } else error = "La coordenada UTM ingresada no es válida."
    }

    if(! exists("coordinates")) stop(error)

    # crear el punto en coordenadas geográficas
    point = st_sfc(st_point(coordinates), crs = epsg)
    if(epsg != 4326) point = st_transform(point, crs = 4326)

    # validar que el punto se encuentre dentro del límite
    if(! any(st_within(point, LIMITE, sparse = FALSE))) {
        stop("La coordenada ingresada es válida, pero se encuentra fuera del límite cantonal.")
    }

    # devolver el punto validado
    return(st_sf(geom = point))
}
