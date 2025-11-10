map_point_landuse = function(point, basemap_storage, basemap_file, overview_level = -1,
                             radius = 100, basemap_offset = NULL, basemap_delta = NULL,
                             plot_landclass = TRUE, plot_landuse = TRUE, point_icon = 25,
                             progress_function = function(detail, value) message(detail)) {

    point = st_transform(point, 3857)

    point_bbox = c(
        xmin = st_coordinates(point)[1] - radius,
        ymin = st_coordinates(point)[2] - radius,
        xmax = st_coordinates(point)[1] + radius,
        ymax = st_coordinates(point)[2] + radius
    ) |> st_bbox(crs = 3857)

    if(is.null(basemap_offset) | is.null(basemap_delta)) {
        progress_function("Offset or Delta missing, proxying...", 0.250)

        basemap_proxy = file.path("/vsicurl", basemap_storage, basemap_file) |>
            read_stars(proxy = TRUE) |> st_dimensions()

        basemap_offset = c(basemap_proxy$x$offset, basemap_proxy$y$offset)
        basemap_delta  = c(basemap_proxy$x$delta,  basemap_proxy$y$delta)
    }

    raster_center = st_coordinates(point) - basemap_offset
    raster_center = raster_center / (basemap_delta * 2**(overview_level + 1))
    raster_size = 2 * abs(1.1 * radius / (basemap_delta * 2**(overview_level + 1)))

    raster_params = list(
        nXOff  = round(raster_center[1] - raster_size[1] / 2),
        nYOff  = round(raster_center[2] - raster_size[2] / 2),
        nXSize = round(raster_size[1]),
        nYSize = round(raster_size[2])
    )

    progress_function("Parameters ready, getting basemap...", 0.500)

    basemap = file.path("/vsicurl", basemap_storage, basemap_file) |>
        read_stars(options = paste0("OVERVIEW_LEVEL=", overview_level),
                   proxy = FALSE, RasterIO = raster_params)

    if(! "tmap" %in% names(sessionInfo()$otherPkgs)) {
        progress_function("Package tmap missing, loading...", 0.750)

        suppressPackageStartupMessages( { library(tmap) } )
    }

    progress_function("Everything ready, plotting...", 1.000)

    point_map = tm_shape(point, bbox = point_bbox, is.main = TRUE) +
        tm_symbols(zindex = 490, fill = "#ff0000", shape = point_icon) +
    tm_shape(basemap) +
        tm_raster(zindex = 410,
                  col.legend = tm_legend_hide(),
                  col.scale = tm_scale_continuous(values = "-brewer.greys")) +
    tm_graticules(n.x = 3, n.y = 3, col = "#000", lines = FALSE, labels.cardinal = FALSE) +
    tm_layout(inner.margins = c(0, 0, 0, 0), meta.margins = c(0, 0, 0, 0.2))

    if(plot_landclass) {
        landclass = st_transform(PUGS_ESTRUCTURANTE, 3857) |>
            dplyr::mutate(subclasifi = sub("\\s.$", "", subclasifi))

        point_map = point_map + tm_shape(landclass) +
            tm_fill(zindex = 440, fill_alpha = 0.5, fill = "subclasifi",
                    fill.legend = tm_legend("Subclasificación del suelo", item.space = 0.5),
                    fill.scale = tm_scale_categorical(values = c(
                        "Consolidado"                  = "#666666",
                        "No Consolidado"               = "#88afbd",
                        "Núcleo urbano en suelo rural" = "#d69698",
                        "Expansión Urbana"             = "#ad6fc7",
                        "Aprovechamiento extractivo"   = "#c7a35b",
                        "Producción"                   = "#e3eba0",
                        "Protección"                   = "#7ecc81")))
    }

    if(plot_landuse) {
        landuse = st_transform(PUGS_USO_SUELO, 3857) |>
            dplyr::mutate(uso_especi = sub("\\s.$", "", uso_especi)) |>
            dplyr::filter(uso_genera == "Protección Ecológica")

        point_map = point_map + tm_shape(landuse) +
            tm_borders(zindex = 450, lwd = 2, col = "uso_especi",
                       col.legend = tm_legend("Uso específico del suelo", item.space = 0.5),
                       col.scale = tm_scale_categorical(values = c(
                           "Protección Ríos y Quebradas" = "#023eff",
                           "Protección Natural"          = "#ff7c00",
                           "Conservación"                = "#1ac938",
                           "Zonas de Amortiguamiento"    = "#8b2be2",
                           "Protección de Playa"         = "#ffc400")))
    }

    return(point_map)
}
