#' The application server-side
#' @param input,output,session Internal parameters for {shiny}.
#' @noRd
app_server <- function(input, output, session) {
  # Data ----

  container <- azkit::get_container(Sys.getenv("AZ_CONTAINER_INPUTS"))
  rates <- azkit::read_azure_parquet(container, "rates", "dev")

  # Reactives ----

  selected_provider <- shiny::reactive(input$provider_select)
  selected_strategy <- shiny::reactive(input$strategy_select)

  rates_prepared <- shiny::reactive({
    rates |>
      dplyr::filter(
        .data$provider == selected_provider(),
        .data$strategy == selected_strategy()
      ) |>
      dplyr::arrange(.data$fyear)
  }) |>
    shiny::bindEvent(selected_provider(), selected_strategy())

  # Observers ----

  shiny::observe({
    providers <- jsonlite::read_json(
      app_sys("app", "data", "datasets.json"),
      simplify_vector = TRUE
    )
    provider_choices <- purrr::set_names(names(providers), providers)
    shiny::updateSelectInput(
      session,
      "provider_select",
      choices = provider_choices
    )
  })

  shiny::observe({
    strategies <- jsonlite::read_json(
      app_sys("app", "data", "mitigators.json"),
      simplify_vector = TRUE
    )
    strategy_choices <- purrr::set_names(names(strategies), strategies)
    shiny::updateSelectInput(
      session,
      "strategy_select",
      choices = strategy_choices
    )
  })

  # Outputs ----

  output$rates_plot <- shiny::renderPlot({
    rates_prepared() |> plot_rates()
  })
}
