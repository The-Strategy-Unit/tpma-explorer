#' Server-Side Application
#' @param input,output,session Internal parameters for 'shiny'.
#' @noRd
app_server <- function(input, output, session) {
  container <- azkit::get_container(Sys.getenv("AZ_CONTAINER_INPUTS"))
  rates_data <- azkit::read_azure_parquet(container, "rates", "dev")

  providers_lookup <- jsonlite::read_json(
    app_sys("app", "data", "datasets.json"),
    simplify_vector = TRUE
  )

  strategies_lookup <- jsonlite::read_json(
    app_sys("app", "data", "mitigators.json"),
    simplify_vector = TRUE
  )

  selected_provider <- mod_select_provider_server(
    "mod_select_provider",
    providers_lookup
  )
  selected_strategy <- mod_select_strategy_server(
    "mod_select_strategy",
    strategies_lookup
  )

  mod_plot_trend_server(
    "mod_plot_trend",
    rates_data,
    selected_provider,
    selected_strategy
  )
}
