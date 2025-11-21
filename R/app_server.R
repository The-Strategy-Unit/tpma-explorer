#' Server-Side Application
#' @param input,output,session Internal parameters for 'shiny'.
#' @noRd
app_server <- function(input, output, session) {
  # Env variables ----
  inputs_container_name <- Sys.getenv("AZ_CONTAINER_INPUTS")
  data_version <- Sys.getenv("DATA_VERSION")
  baseline_year <- Sys.getenv("BASELINE_YEAR") |> as.numeric()

  # Data ----
  inputs_container <- azkit::get_container(inputs_container_name)
  rates_data <- azkit::read_azure_parquet(
    inputs_container,
    "rates",
    data_version
  )
  procedures_data <- azkit::read_azure_parquet(
    inputs_container,
    "procedures",
    data_version
  )
  diagnoses_data <- azkit::read_azure_parquet(
    inputs_container,
    "diagnoses",
    data_version
  )
  age_sex_data <- azkit::read_azure_parquet(
    inputs_container,
    "age_sex",
    data_version
  ) |>
    prepare_age_sex_data()
  nee_data <- readr::read_csv(
    app_sys("app", "data", "nee_table.csv"),
    col_types = "cddd"
  )

  # Lookups ----
  providers_lookup <- jsonlite::read_json(
    app_sys("app", "data", "datasets.json"),
    simplify_vector = TRUE
  )
  strategies_lookup <- jsonlite::read_json(
    app_sys("app", "data", "mitigators.json"),
    simplify_vector = TRUE
  )
  descriptions_lookup <- jsonlite::read_json(
    app_sys("app", "data", "descriptions.json"),
    simplifyVector = TRUE
  )
  peers_lookup <- readr::read_csv(
    app_sys("app", "data", "peers.csv"),
    col_types = "c"
  )
  procedures_lookup <- readr::read_csv(
    app_sys("app", "data", "procedures.csv"),
    col_types = "c"
  )
  diagnoses_lookup <- readr::read_csv(
    app_sys("app", "data", "diagnoses.csv"),
    col_types = "c"
  )

  # Config ----
  strategies_config <- get_golem_config("mitigators_config")

  # User inputs ----
  selected_provider <- mod_select_provider_server(
    "mod_select_provider",
    providers_lookup
  )
  selected_strategy <- mod_select_strategy_server(
    "mod_select_strategy",
    strategies_lookup
  )

  # Modules ----
  mod_show_strategy_text_server(
    "mod_show_strategy_text",
    descriptions_lookup,
    selected_strategy
  )
  mod_plot_rates_server(
    "mod_plot_rates",
    rates_data,
    strategies_config,
    peers_lookup,
    selected_provider,
    selected_strategy,
    baseline_year
  )
  mod_table_procedures_server(
    "mod_table_procedures",
    procedures_data,
    procedures_lookup,
    selected_provider,
    selected_strategy,
    baseline_year
  )
  mod_table_diagnoses_server(
    "mod_table_diagnoses",
    diagnoses_data,
    diagnoses_lookup,
    selected_provider,
    selected_strategy,
    baseline_year
  )
  mod_plot_age_sex_pyramid_server(
    "mod_plot_age_sex_pyramid",
    age_sex_data,
    selected_provider,
    selected_strategy,
    baseline_year
  )
  mod_plot_nee_server(
    "mod_plot_nee",
    nee_data,
    selected_strategy
  )
}
