# cambiar el directorio
# necesario en el contenedor shiny-apps-1
setwd("/home/shiny")
message("This is .Rprofile at ", getwd())

# cargar paquetes requeridos
suppressPackageStartupMessages( {
    library(sf)
    library(shiny)
    library(dplyr)
} )

# definir la zona UTM
UTM_EPSG = 32717L

# cargar coberturas espaciales
LIMITE = st_read("data/limite.gpkg", "limite", quiet = TRUE)
PUGS_ESTRUCTURANTE = st_read("data/pugs_estructurante.gpkg", "pugs_estructurante", quiet = TRUE)

# cargar funciones globales
for(i in dir("R", pattern = "R$", full.names = TRUE)) source(i)
