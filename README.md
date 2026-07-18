# BRFSS SQL Database

A PostgreSQL database and ETL pipeline for the CDC Behavioral Risk Factor Surveillance System (BRFSS).

This project creates a reproducible PostgreSQL database from annual BRFSS survey files (.XPT), providing a standardized backend for epidemiologic analyses, dashboards, and statistical workflows in R and Python.

---

## Objectives

- Import annual BRFSS datasets into PostgreSQL
- Preserve immutable raw source data
- Build standardized cleaned tables
- Create reusable analytical views
- Support downstream analyses in R, Python, Tableau, and Shiny

---

## Current Status

- PostgreSQL server configured
- Database (`brfss`) created
- Schemas (`raw`, `clean`, `analysis`) created
- 2024 BRFSS imported successfully

---

## Database Architecture

brfss
├── raw
├── clean
└── analysis

- **raw** — source-aligned CDC data
- **clean** — standardized variables and cleaned values
- **analysis** — views and summary tables for analysis

---

## Repository Structure

R/
    Database connection and import scripts

sql/
    Database creation and SQL transformations

data/
    Local BRFSS source files (ignored by Git)

---

## Setup

1. Install PostgreSQL.
2. Create a database named `brfss`.
3. Create a project `.Renviron` containing:

BRFSS_DB_HOST=
BRFSS_DB_PORT=
BRFSS_DB_NAME=
BRFSS_DB_USER=
BRFSS_DB_PASSWORD=

4. Download the BRFSS XPT files into the `data/` directory.
5. Run the import scripts in `R/`.

---

## Future Development

- Import historical BRFSS releases
- Standardize variables across years
- Create metadata tables
- Build analytical views
- Optimize indexing
- Support dashboards and reporting

---

## Data Source

Behavioral Risk Factor Surveillance System (BRFSS)

Centers for Disease Control and Prevention (CDC)

Raw survey data are not included in this repository.