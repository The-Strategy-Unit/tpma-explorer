#' Get Peers Lookup
#'
#' Reads the appropriate peers lookup file based on the selected geography.
#'
#' @param selected_geography Character. The selected geography, e.g. "nhp" or "la".
#'
#' @return A data.frame with provider codes and their corresponding peers.
#'
#' @export
get_peers_lookup <- function(selected_geography) {
  filename <- switch(
    selected_geography,
    "nhp" = "nhp-peers.csv",
    "la" = "la-peers.csv"
  )

  shiny::req(filename)

  readr::read_csv(
    app_sys("app", "data", filename),
    col_types = "c"
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
