get_ggmaps_coordinates = function(ggmaps_url) {
    ggmaps_host = curl::curl_parse_url(ggmaps_url, default_scheme = TRUE)$host

    if(! ggmaps_host %in% c("maps.app.goo.gl", "maps.google.com", "google.com", "www.google.com")) {
        stop("La URL ingresada no es de Google Maps.")
    }

    ggmaps_html = httr2::request(ggmaps_url) |> httr2::req_perform() |>
        httr2::resp_body_html(check_type = FALSE)

    ggmaps_head = xml2::xml_child(ggmaps_html, "head") |> xml2::as_list()

    ogimage_index = sapply(ggmaps_head, function(element) {
        property = attr(element, "property")
        ifelse(length(property) == 0, FALSE, property == "og:image")
    } )

    if(length(ogimage_index) == 0) {
        stop("There aren't any <head> elements.")
    } else if(sum(ogimage_index) == 0) {
        stop("There isn't any <head> element with \"og:image\" property.")
    } else if(sum(ogimage_index) > 1) {
        stop("There are many <head> elements with \"og:image\" property.")
    } else {
        ogimage = attr(ggmaps_head[[ which(ogimage_index) ]], "content")
    }

    ogimage_coords = sub(".+center=(.+)&zoom=.+", "\\1", ogimage) |> strsplit("%2C")

    validate_coordinates(ogimage_coords[[1]][1], ogimage_coords[[1]][2])
}
