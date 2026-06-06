postgres_connect = function(user, pass, pg_base, pg_port = 5432, pg_host = Sys.getenv("PG_HOST"),
                            pg_pass = Sys.getenv("PG_PASS"), pg_user = Sys.getenv("PG_USER")) {

    if(! "DBI" %in% names(sessionInfo()$otherPkgs)) {
        #progress_function("Package DBI missing, loading...", 0.000)

        suppressPackageStartupMessages( { library(DBI) } )
    }

    dbcon = dbConnect(RPostgres::Postgres(), pg_base, pg_host, pg_port, pg_pass, pg_user)

    query = paste0("SELECT nombre, hash FROM indicadores.usuario WHERE id ='", user, "'")

    dbres = dbGetQuery(dbcon, query)

    if(length(dbres$hash) != 1) {
        stop("El usuario ingresado no existe.")
    } else if(dbres$hash != digest::digest(pass, "sha512", FALSE)) {
        stop("La contraseña ingresada es incorrecta.")
    }

    dbDisconnect(dbcon)

    return(dbres$nombre)
}
