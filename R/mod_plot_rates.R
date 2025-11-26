#' Plot Rates UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_rates_ui <- function(id) {
  ns <- shiny::NS(id)
  # Rates plots share a y-axis, so don't wrap
  bslib::layout_columns(
    col_widths = c(5, 5, 2),
    fill = FALSE,
    fillable = FALSE,
    mod_plot_rates_trend_ui(ns("mod_plot_rates_trend")),
    mod_plot_rates_funnel_ui(ns("mod_plot_rates_funnel")),
    mod_plot_rates_box_ui(ns("mod_plot_rates_box"))
  )
}

#' Plot Rates Server
#' @param id Internal parameter for `shiny`.
#' @param rates A data.frame. Annual rate values for combinations of provider
#'     and strategy.
#' @param strategies_config List. Configuration for strategies from the
#'     `"mitigators_config"` element of `golem-config.yml`, read in with
#'     [get_golem_config].
#' @param peers_lookup A data.frame. A row per provider-peer pair.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param baseline_year Integer. Baseline year in the form `202324`.
#' @noRd
mod_plot_rates_server <- function(
  id,
  rates,
  strategies_config,
  peers_lookup,
  selected_provider,
  selected_strategy,
  baseline_year
) {
  shiny::moduleServer(id, function(input, output, session) {
    #  Prepare data ----

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
          baseline_year
        )
    })

    rates_funnel_data <- shiny::reactive({
      shiny::req(rates_baseline_data())
      rates_baseline_data() |> generate_rates_funnel_data()
    })

    # Prepare variables ----

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

    strategy_config <- shiny::reactive({
      shiny::req(strategies_config)
      shiny::req(selected_strategy())

      strategy_group_lookup <- strategies_config |> make_strategy_group_lookup()

      strategy_group <- strategy_group_lookup |>
        dplyr::filter(.data$strategy == selected_strategy()) |>
        dplyr::pull("group")

      strategies_config[[strategy_group]]
    })

    y_axis_title <- shiny::reactive({
      shiny::req(strategy_config())
      strategy_config()[["y_axis_title"]]
    })
    funnel_x_title <- shiny::reactive({
      shiny::req(strategy_config())
      strategy_config()[["funnel_x_title"]]
    })

    # Declare modules ----
    mod_plot_rates_trend_server(
      "mod_plot_rates_trend",
      rates_trend_data,
      y_axis_limits,
      y_axis_title,
      baseline_year
    )
    mod_plot_rates_funnel_server(
      "mod_plot_rates_funnel",
      rates_funnel_data,
      peers_lookup,
      y_axis_limits,
      funnel_x_title
    )
    mod_plot_rates_box_server(
      "mod_plot_rates_box",
      rates_baseline_data,
      peers_lookup,
      y_axis_limits
    )
  })
}
