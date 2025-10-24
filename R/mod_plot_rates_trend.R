#' Plot Rates Trend UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_rates_trend_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::plotOutput(ns("rates_trend_plot"))
}

#' Plot Rates Trend Server
#' @param id Internal parameter for `shiny`.
#' @param rates A data.frame. Annual rate values for combinations of provider
#'     and TPMA.
#' @param selected_provider Character. Provider code, e.g. `"RCX"`.
#' @param selected_strategy Character. TPMA variable name, e.g.
#'     `"discharged_no_treatment_adult_ambulance"`.
#' @noRd
mod_plot_rates_trend_server <- function(
  id,
  rates,
  selected_provider,
  selected_strategy
) {
  shiny::moduleServer(id, function(input, output, session) {
    rates_prepared <- shiny::reactive({
      shiny::req(rates)
      shiny::req(selected_provider())
      shiny::req(selected_strategy())

      rates |>
        dplyr::filter(
          .data$provider == selected_provider(),
          .data$strategy == selected_strategy()
        ) |>
        dplyr::arrange(.data$fyear)
    })

    output$rates_trend_plot <- shiny::renderPlot({
      rates <- rates_prepared()
      shiny::validate(shiny::need(
        nrow(rates) > 0,
        "No data available for these selections."
      ))
      plot_rates_trend(rates)
    })
  })
}
