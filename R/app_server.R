#' Server-Side Application
#' @param input,output,session Internal parameters for 'shiny'.
#' @noRd
app_server <- function(input, output, session) {
  container <- azkit::get_container(Sys.getenv("AZ_CONTAINER_INPUTS"))
  rates <- azkit::read_azure_parquet(container, "rates", "dev")

  selected_provider <- mod_select_provider_server("mod_select_provider")
  selected_strategy <- mod_select_provider_server("mod_select_strategy")

  mod_plot_trend_server(
    "mod_plot_trend",
    rates,
    selected_provider,
    selected_strategy
  )
}
