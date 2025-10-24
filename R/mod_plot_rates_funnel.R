#' Plot Rates Funnel UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_rates_funnel_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::plotOutput(ns("rates_funnel_plot"))
}

#' Plot Rates Funnel Server
#' @param id Internal parameter for `shiny`.
#' @param rates A data.frame. Annual rate values for combinations of provider
#'     and TPMA.
#' @param peers_lookup A data.frame. A row per provider-peer pair.
#' @param selected_provider Character. Provider code, e.g. `"RCX"`.
#' @param selected_strategy Character. TPMA variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @noRd
mod_plot_rates_funnel_server <- function(
  id,
  rates,
  peers_lookup,
  selected_provider,
  selected_strategy
) {
  shiny::moduleServer(id, function(input, output, session) {
    rates_prepared <- shiny::reactive({
      shiny::req(rates)
      shiny::req(peers_lookup)
      shiny::req(selected_provider())
      shiny::req(selected_strategy())

      provider_peers <- isolate_provider_peers(
        selected_provider(),
        peers_lookup
      )
      rates_baseline_data <- rates |>
        generate_rates_baseline_data(
          selected_provider(),
          provider_peers,
          selected_strategy(),
          start_year = "202324"
        )
      generate_rates_funnel_data(rates_baseline_data)
    })

    output$rates_funnel_plot <- shiny::renderPlot({
      rates <- rates_prepared()
      shiny::validate(shiny::need(
        nrow(rates) > 0,
        "No data available for these selections."
      ))
      plot_rates_funnel(
        rates,
        plot_range = c(0, max(rates$rate)),
        x_axis_title = "Denominator"
      )
    })
  })
}
