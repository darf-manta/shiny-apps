# una función para extraer las coordenadas geográficas de una fotografía georreferenciada
extract_photo_coordinates = function(photo_path) {
    # verificar que el archivo es una fotografía
    if(! grepl("\\.(jpg|jpeg|tif|tiff|heic|heif)$", tolower(photo_path))) {
        stop("El archivo cargado no es una fotografía.")
    }

    # extraer datos EXIF del archivo
    photo_exif = as.data.frame(read_exif(photo_path, c("GPSLongitude", "GPSLatitude")))

    # verificar que los datos EXIF incluyan la coordenada
    if(! "GPSLongitude" %in% names(photo_exif)) {
        stop("La fotografía no está georreferenciada.")
    }

    # crear el punto en coordenadas geográficas
    point = st_as_sf(photo_exif, coords = c("GPSLongitude", "GPSLatitude"), crs = 4326)

    # validar que el punto se encuentre dentro del límite
    if(! any(st_within(point, LIMITE, sparse = FALSE))) {
        stop("La fotografía está georreferenciada, pero fue capturada fuera del límite cantonal.")
    }

    # devolver el punto validado
    return(select(point, geom = geometry))
}
