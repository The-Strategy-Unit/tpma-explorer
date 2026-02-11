#' Plot Rates UI
#' @param id,input,output,session Internal parameters for `shiny`.
#' @noRd
mod_plot_rates_ui <- function(id) {
  ns <- shiny::NS(id)
  # Rates plots share a y-axis, so don't wrap
  bslib::layout_columns(
    col_widths = c(5, 5, 2),
    mod_plot_rates_trend_ui(ns("mod_plot_rates_trend")),
    mod_plot_rates_funnel_ui(ns("mod_plot_rates_funnel")),
    mod_plot_rates_box_ui(ns("mod_plot_rates_box"))
  )
}

#' Plot Rates Server
#' @param id Internal parameter for `shiny`.
#' @param inputs_data A reactive. Contains a list with data.frames, which we can
#'     extract the rates data from.
#' @param selected_geography Character. Selected geography, either `"nhp"` or
#'     `"la"`.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param selected_year Integer. Selected year in the form `202324`.
#' @noRd
mod_plot_rates_server <- function(
  id,
  inputs_data,
  selected_geography,
  selected_provider,
  selected_strategy,
  selected_year
) {
  # load static data items
  strategies_config <- get_golem_config("mitigators_config")
  strategy_group_lookup <- make_strategy_group_lookup(strategies_config)

  # return the shiny module
  shiny::moduleServer(id, function(input, output, session) {
    peers_lookup <- shiny::reactive({
      get_peers_lookup(selected_geography())
    }) |>
      shiny::bindCache(selected_geography())

    #  Prepare data ----
    rates_data <- shiny::reactive({
      strategy <- shiny::req(selected_strategy())

      get_rates_data(
        inputs_data()[["rates"]],
        strategy
      )
    })

    providers_lookup <- shiny::reactive({
      selected_geography <- shiny::req(selected_geography())
      filename <- switch(
        selected_geography,
        "nhp" = "nhp-datasets.json",
        "la" = "la-datasets.json"
      )

      shiny::req(filename)
      providers_lookup <- jsonlite::read_json(
        app_sys("app", "data", filename),
        simplify_vector = TRUE
      ) |>
        tibble::enframe("provider", "provider_label") |> # label for plotting
        tidyr::unnest(.data$provider_label)

      if (selected_geography == "la") {
        providers_lookup <- providers_lookup |>
          dplyr::mutate(
            provider_label = stringr::str_remove(
              .data$provider_label,
              " \\(\\w{1}\\d{8}\\)$" # e.g. remove ' (E06000014)' from the end
            )
          )
      }

      if (selected_geography == "nhp") {
        # For now, use the trust code as its label
        providers_lookup <- providers_lookup |>
          dplyr::mutate(provider_label = .data$provider)
      }

      providers_lookup |>
        dplyr::mutate(provider_label = stringr::str_squish(provider_label))
    }) |>
      shiny::bindEvent(selected_geography())

    rates_trend_data <- shiny::reactive({
      df <- shiny::req(rates_data())
      providers_lookup <- shiny::req(providers_lookup())
      peers_lookup <- shiny::req(peers_lookup())
      provider <- shiny::req(selected_provider())
      strategy <- shiny::req(selected_strategy())

      generate_rates_baseline_data(df, provider, providers_lookup, peers_lookup)
    })

    rates_baseline_data <- shiny::reactive({
      df <- shiny::req(rates_trend_data())
      year <- year <- shiny::req(selected_year())
      df |> dplyr::filter(.data[["fyear"]] == .env[["year"]])
    })

    rates_funnel_calculations <- shiny::reactive({
      df <- shiny::req(rates_baseline_data())

      uprime_calculations(df)
    })

    # Prepare variables ----

    y_axis_limits <- shiny::reactive({
      td_rate <- shiny::req(rates_trend_data())$rate

      bd <- shiny::req(rates_baseline_data())
      bd$z <- rates_funnel_calculations()$z_i

      fd_rate <- bd |>
        dplyr::filter(
          .data$denominator >= 0.05 * max(.data$denominator),
          abs(.data$z) < 4
        ) |>
        dplyr::pull("rate")

      c(0, max(c(td_rate, fd_rate)))
    })

    strategy_config <- shiny::reactive({
      strategy <- shiny::req(selected_strategy())

      strategy_group <- strategy_group_lookup[[strategy]]
      strategies_config[[strategy_group]]
    })

    y_axis_title <- shiny::reactive({
      shiny::req(strategy_config())
      strategy_config()[["y_axis_title"]]
    })
    y_labels <- shiny::reactive({
      shiny::req(strategy_config())
      strategy_config()[["number_type"]]
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
      y_labels,
      selected_year
    )
    mod_plot_rates_funnel_server(
      "mod_plot_rates_funnel",
      rates_baseline_data,
      rates_funnel_calculations,
      y_axis_limits,
      funnel_x_title
    )
    mod_plot_rates_box_server(
      "mod_plot_rates_box",
      rates_baseline_data,
      y_axis_limits
    )
  })
}
