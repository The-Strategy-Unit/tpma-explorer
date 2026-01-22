#' Find the Peers for a Given Provider
#' @param provider Character. Provider code, e.g. `"RCF"`.
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
#' @param rates A data.frame. Rates data read from Azure.
#' @param provider Character. Provider code, e.g. `"RCF"`.
#' @param peers Character. A vector of peers for given `provider`.
#' @param strategy Character. Strategy variable name, e.g.
#'     `"alcohol_partially_attributable_acute"`.
#' @param baseline_year Integer. Baseline year in the form `202324`.
#' @return A data.frame.
#' @export
generate_rates_baseline_data <- function(
  rates,
  provider,
  peers,
  strategy,
  baseline_year
) {
  rates |>
    dplyr::filter(
      .data$strategy == .env$strategy,
      .data$fyear == .env$baseline_year
    ) |>
    dplyr::mutate(
      is_peer = dplyr::case_when(
        .data$provider == .env$provider ~ FALSE,
        .data$provider %in% .env$peers ~ TRUE,
        .default = NA # if scheme is neither focal nor a peer
      )
    ) |>
    dplyr::arrange(dplyr::desc(.data$is_peer)) # to plot focal scheme last
}

#' Generate Function to Calculate U-Prime values
#' @param df A data.frame. Rates data read in from Azure and
#'     processed [generate_rates_baseline_data].
#' @return A list containing items to produce a U-Prime funnel chart.
#' @export
uprime_calculations <- function(df) {
  df <- dplyr::arrange(df, .data$denominator)

  cl <- df$national_rate[[1]]
  stdev <- sqrt(cl / df$denominator)
  z_i <- (df$rate - cl) / stdev

  mr <- abs(diff(z_i))
  ulmr <- 3.267 * mean(mr, na.rm = TRUE)
  amr <- mean(mr[mr < ulmr], na.rm = TRUE)

  sigma_z <- amr / 1.128

  sd_fn <- \(x) sqrt(cl / x) * sigma_z
  cl_fn <- \(s) \(x) cl + s * sd_fn(x)

  list(
    cl = cl,
    z_i = (df$rate - cl) / sd_fn(df$denominator),
    lcl3 = cl_fn(-3),
    ucl3 = cl_fn(3),
    lcl2 = cl_fn(-2),
    ucl2 = cl_fn(2)
  )
}
