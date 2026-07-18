library(here)

source(here("r_functions", "00-connect-server.R"))
source(here("r_functions", "01-import-raw.R"))

main <- function(){
  
  year <- 2024
  
  con <- connect_brfss()
  
  on.exit(
    DBI::dbDisconnect(con),
    add = TRUE
  )
  
  import_result <- import_raw_brfss(
    year = year,
    con = con,
    overwrite = FALSE
  )
  
  print(import_result)
}

main()