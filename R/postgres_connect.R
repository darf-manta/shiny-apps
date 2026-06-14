postgres_connect = function(pg_base, pg_port = 5432, pg_host = Sys.getenv("PG_HOST"),
                            pg_pass = Sys.getenv("PG_PASS"), pg_user = Sys.getenv("PG_USER")) {

    if(! "DBI" %in% names(sessionInfo()$otherPkgs)) {
        #progress_function("Package DBI missing, loading...", 0.000)

        suppressPackageStartupMessages( { library(DBI) } )
    }

    pg_conn = dbConnect(RPostgres::Postgres(), pg_base, pg_host, pg_port, pg_pass, pg_user)

    return(pg_conn)
}
