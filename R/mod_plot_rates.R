#' Plot Rates UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_rates_ui <- function(id) {
  ns <- shiny::NS(id)
  # these plots share a y axis, so don't use layout_column_wrap()
  bslib::layout_columns(
    col_widths = 4,
    mod_plot_rates_trend_ui(ns("mod_plot_rates_trend")),
    mod_plot_rates_funnel_ui(ns("mod_plot_rates_funnel")),
    mod_plot_rates_box_ui(ns("mod_plot_rates_box"))
  )
}

#' Plot Rates Server
#' @param id Internal parameter for `shiny`.
#' @param rates A data.frame. Annual rate values for combinations of provider
#'     and strategy.
#' @param peers_lookup A data.frame. A row per provider-peer pair.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @noRd
mod_plot_rates_server <- function(
  id,
  rates,
  peers_lookup,
  selected_provider,
  selected_strategy
) {
  shiny::moduleServer(id, function(input, output, session) {
    rates_trend_data <- shiny::reactive({
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

    rates_baseline_data <- shiny::reactive({
      shiny::req(rates)
      shiny::req(peers_lookup)
      shiny::req(selected_provider())
      shiny::req(selected_strategy())

      provider_peers <- isolate_provider_peers(
        selected_provider(),
        peers_lookup
      )
      rates |>
        generate_rates_baseline_data(
          selected_provider(),
          provider_peers,
          selected_strategy(),
          start_year = "202324"
        )
    })

    rates_funnel_data <- shiny::reactive({
      shiny::req(rates_baseline_data())
      rates_baseline_data() |> generate_rates_funnel_data()
    })

    y_axis_limits <- shiny::reactive({
      shiny::req(rates_trend_data())
      shiny::req(rates_funnel_data())
      range(c(
        rates_trend_data()[["rate"]],
        rates_funnel_data()[["rate"]],
        rates_funnel_data()[["lower3"]],
        rates_funnel_data()[["upper3"]]
      )) |>
        pmax(0)
    })

    mod_plot_rates_trend_server(
      "mod_plot_rates_trend",
      rates_trend_data,
      selected_provider,
      selected_strategy,
      y_axis_limits
    )
    mod_plot_rates_funnel_server(
      "mod_plot_rates_funnel",
      rates_funnel_data,
      peers_lookup,
      selected_provider,
      selected_strategy,
      y_axis_limits
    )
    mod_plot_rates_box_server(
      "mod_plot_rates_box",
      rates_baseline_data,
      peers_lookup,
      selected_provider,
      selected_strategy,
      y_axis_limits
    )
  })
}
