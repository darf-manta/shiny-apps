# cambiar el directorio
# necesario en el contenedor shiny-apps-1
setwd("/home/shiny")
message("This is .Rprofile at ", getwd())

# cargar paquetes requeridos
suppressPackageStartupMessages( {
    library(sf)
    library(shiny)
    library(bslib)
    library(dplyr)
    library(exifr)
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
