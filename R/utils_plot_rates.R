#' Get Peers Lookup
#'
#' Reads the appropriate peers lookup file based on the selected geography.
#'
#' @param selected_geography Character. The selected geography, e.g. "nhp" or "la".
#' @param provider Character. The provider code for which to find peers, e.g. "RCF".
#'
#' @return A data.frame with provider codes and their corresponding peers.
#'
#' @export
get_peers_lookup <- function(selected_geography, provider) {
  filename <- switch(
    selected_geography,
    "nhp" = "nhp-peers.csv",
    "la" = "la-peers.csv"
  )

  shiny::req(filename)

  app_sys("app", "reference", filename) |>
    readr::read_csv(col_types = "cc") |>
    dplyr::filter(
      .data$procode == .env$provider,
      .data$peer != .env$provider
    ) |>
    dplyr::pull(.data$peer)
}

get_providers_lookup <- function(selected_geography) {
  filename <- switch(
    selected_geography,
    "nhp" = "nhp-datasets.json",
    "la" = "la-datasets.json"
  )

  provider_label_regex <- if (selected_geography == "la") {
    # e.g. remove ' (E06000014)' from the end
    "^.*(?= \\(\\w{1}\\d{8}\\)$)"
  } else {
    # For now, use the trust code as its label
    "(?<=\\()\\w+(?=\\)$)"
  }

  app_sys("app", "reference", filename) |>
    yyjsonr::read_json_file() |>
    tibble::enframe("provider", "provider_label") |> # label for plotting
    tidyr::unnest("provider_label") |>
    dplyr::mutate(
      dplyr::across(
        "provider_label",
        \(.x) stringr::str_extract(.x, provider_label_regex) |> stringr::str_squish()
      )
    )
}

#' Get Rates Data
#'
#' This function prepares the data for the rates_data() reactive. It moves the
#' national row to a separate column.
#'
#' @param df the rates data from inputs_data
#' @param strategy Character. Strategy variable name to filter rows to
#'
#' @return Dataframe with national rates in a separate column
#'
#' @export
get_rates_data <- function(df, strategy) {
  df <- df |>
    dplyr::filter(.data$strategy == .env$strategy)

  national <- df |>
    dplyr::filter(.data$provider == "national") |>
    dplyr::select(
      "strategy",
      "fyear",
      national_rate = "std_rate"
    )

  df |>
    dplyr::filter(!.data$provider %in% c("national", "unknown")) |>
    dplyr::inner_join(
      national,
      by = c("strategy", "fyear")
    ) |>
    dplyr::rename(rate = "std_rate") |>
    dplyr::select(-"crude_rate")
}

#' Get Rates Trend Data
#'
#' Extracts the trend for a specific provider from the rates data
#' (see [get_rates_data]).
#'
#' @param df A data.frame. Prepared by get_rates_data
#' @param provider Character. Provider code, e.g. `"RCF"`.
#'
#' @return Dataframe filtered to the specific provider
#'
#' @export
get_rates_trend_data <- function(df, provider) {
  df |>
    dplyr::filter(.data$provider == .env$provider) |>
    dplyr::arrange(.data$fyear)
}

#' Get Rates Y Axis Limits
#'
#' Determines the y-axis limits for the rates trend plot based on the trend data and funnel data.
#'
#' @param rates_trend_data A data.frame. Prepared by get_rates_trend_data.
#' @param rates_funnel_data A data.frame. Prepared by generate_rates_funnel_data.
#' @param rates_funnel_calculations A data.frame. Prepared by uprime_calculations.
#'
#' @return A numeric vector of length 2, representing the lower and upper limits of the y-axis.
get_rates_y_axis_limits <- function(rates_trend_data, rates_funnel_data, rates_funnel_calculations) {
  td_rate <- shiny::req(rates_trend_data)$rate

  bd <- shiny::req(rates_funnel_data)
  bd$z <- rates_funnel_calculations$z_i

  fd_rate <- bd |>
    dplyr::filter(
      .data$denominator >= 0.05 * max(.data$denominator),
      abs(.data$z) < 4
    ) |>
    dplyr::pull("rate")

  c(0, max(c(td_rate, fd_rate)))
}
