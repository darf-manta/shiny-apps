# cambiar el directorio
# necesario en el contenedor shiny-apps-1
setwd("/home/shiny")
message("This is .Rprofile at ", getwd())

# cargar paquetes requeridos
suppressPackageStartupMessages( {
    library(bslib)
    library(shiny)
    library(stars)
} )

# definir la zona UTM
UTM_EPSG = 32717L

# cargar coberturas espaciales
LIMITE = st_read("data/limite.gpkg", "limite", quiet = TRUE)
BARRIO_SECTOR = st_read("data/barrio_sector.gpkg", "barrio_sector", quiet = TRUE)
PUGS_ESTRUCTURANTE = st_read("data/pugs_estructurante.gpkg", "pugs_estructurante", quiet = TRUE)
PUGS_USO_SUELO = st_read("data/pugs_uso_suelo.gpkg", "pugs_uso_suelo", quiet = TRUE)

# cargar funciones globales
for(i in dir("R", pattern = "R$", full.names = TRUE)) source(i)

# si la sesión es interactiva
# i.e. en RStudio
if(interactive()) {
    available_apps = dirname(dir("apps", "server", recursive = TRUE))

    # listar todas las aplicaciones
    message("\nAvailable apps:\n")
    message(paste(seq_along(available_apps), available_apps, collapse = "\n"))

    # ofrecer ejecutar una aplicación
    message("\nRun app number:")
    i = as.integer(readline())

    if(i %in% seq_along(available_apps)) runApp(file.path("apps", available_apps[i]))
}
