#' Server-Side Application
#' @param input,output,session Internal parameters for 'shiny'.
#' @noRd
app_server <- function(input, output, session) {
  # Data ----
  container <- azkit::get_container(Sys.getenv("AZ_CONTAINER_INPUTS"))
  rates_data <- azkit::read_azure_parquet(container, "rates", "dev")

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
    peers_lookup,
    selected_provider,
    selected_strategy
  )
}
