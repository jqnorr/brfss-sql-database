library(haven)
library(here)
library(DBI)
library(RPostgres)


import_raw_brfss <- function(
    year,
    con,
    data_dir = here::here("data"),
    schema = "raw",
    overwrite = FALSE
    ) {
    if(length(year) != 1 || is.na(year)) {
      stop("`year` must be one non-missing value")
    }
    
  #validate inputs
    year <- suppressWarnings(as.integer(year))
    
    if(is.na(year)){
      stop("`year` must be convertible to a whole-number year.")
    }
    
    if(year < 1984 || year > as.integer(format(Sys.Date(), "%Y"))) {
      stop("`year` does not look like a valid BRFSS year: ", year)
    }
  
  
  #construct names
  file_name <- paste0("LLCP", year, ".XPT")
  file_path <- file.path(data_dir, file_name)
  
  table_name <- paste0("raw_llcp", year)
  
  table_id <- DBI::Id(
    schema = schema,
    table = table_name
  )
  
  #check source file
  if(!file.exists(file_path)) {
    stop(
      "file path not found, source file:\n", 
      file_path
    )
  }
  
  #prevent accidental ovewrite
  table_exists <- DBI::dbExistsTable(
    con,
    table_id
  )
  
  if(table_exists && !overwrite) {
    stop(
      schema,
      ".",
      table_name,
      " already exists. ",
      "Set `overwrite = TRUE` to replace it."
    )
  }
  
  #read source data
  message("Reading ", file_name, "...")
  
  raw_data <- haven::read_xpt(file_path)
  
  source_rows <- nrow(raw_data)
  source_columns <- ncol(raw_data)
  
  message(
    "Read ",
    format(source_rows, big.mark = ","),
    " rows and ",
    source_columns,
    " columns."
  )
  
  #upload
  message(
    "Writing to ",
    schema,
    ".",
    table_name,
    "..."
  )
  
  DBI::dbWriteTable(
    conn = con,
    name = table_id,
    value = raw_data,
    overwrite = overwrite,
    row.names = FALSE
  )
  
  #validate
  database_rows <- DBI::dbGetQuery(
    con,
    paste0(
      "SELECT COUNT(*)::bigint AS n ",
      "FROM ",
      DBI::dbQuoteIdentifier(con, table_id),
      ";"
    )
  )$n[[1]]
  
  if (source_rows != database_rows) {
    stop(
      "Import validation failed. ",
      "Source rows: ",
      source_rows,
      "; database rows: ",
      database_rows,
      "."
    )
  }
  
  invisible(
    data.frame(
      year = year,
      source_file = file_name,
      schema = schema,
      table = table_name,
      rows = database_rows,
      columns = source_columns
    )
  )
}