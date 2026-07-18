library(DBI)
library(RPostgres)

connect_brfss <- function () {
   con <- DBI::dbConnect(
      RPostgres::Postgres(),
      dbname = Sys.getenv("BRFSS_DB_NAME"),
      host = Sys.getenv("BRFSS_DB_HOST"),
      user = Sys.getenv("BRFSS_DB_USER"),
      port = as.integer(Sys.getenv("BRFSS_DB_PORT")),
      password = Sys.getenv("BRFSS_DB_PASSWORD")
    )

  message("BRFSS connection achieved.")
  
  con
}