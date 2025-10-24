#' Find the Peers for a Given Provider
#' @param provider Character. Provider code, e.g. `"RCX"`.
#' @param peers A data.frame. A row per provider-peer pair.
#' @return Character vector of peers for given `provider`.
#' @export
isolate_provider_peers <- function(provider, peers) {
  peers |>
    dplyr::filter(
      .data$procode == .env$provider & .data$peer != .env$provider
    ) |>
    dplyr::pull(.data$peer)
}

#' Generate Rates Baseline Data
#' @param rates A data.frame.
#' @param provider Character. Provider code, e.g. `"RCX"`.
#' @param peers Character. A vector of peers for given `provider`.
#' @param strategy Character.  TPMA variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param start_year Integer. Baseline year in the form `202324`.
#' @return A data.frame.
#' @export
generate_rates_baseline_data <- function(
  rates,
  provider,
  peers,
  strategy,
  start_year
) {
  rates |>
    dplyr::filter(
      .data$strategy == .env$strategy,
      .data$fyear == .env$start_year
    ) |>
    dplyr::mutate(
      is_peer = dplyr::case_when(
        .data$provider == .env$provider ~ FALSE,
        .data$provider %in% .env$peers ~ TRUE,
        .default = NA # if scheme is neither focal nor a peer
      )
    ) |>
    dplyr::filter(!is.na(.data$is_peer)) |> # only focal scheme and peers
    dplyr::arrange(dplyr::desc(.data$is_peer)) # to plot focal scheme last
}

#' Generate Data for the Funnel Plot
#' @param rates_baseline_data A data.frame. Output created by
#'     [generate_rates_baseline_data].
#' @return A data.frame.
#' @export
generate_rates_funnel_data <- function(rates_baseline_data) {
  rates_baseline_data |>
    dplyr::mutate(
      mean = rates_baseline_data$national_rate,
      sdev_pop_i = sqrt(abs(.data$mean) / .data$denominator),
      z = (.data$rate - .data$mean) / .data$sdev_pop_i,
      sigz = stats::sd(.data$z, na.rm = TRUE),
      cl2 = 2 * .data$sdev_pop_i * .data$sigz,
      cl3 = 3 * .data$sdev_pop_i * .data$sigz,
      lower2 = .data$mean - .data$cl2,
      lower3 = .data$mean - .data$cl3,
      upper2 = .data$mean + .data$cl2,
      upper3 = .data$mean + .data$cl3
    )
}
