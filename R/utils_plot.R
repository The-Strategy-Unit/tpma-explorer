#' Generate Rates Baseline Data
#' @param selected_geography Character. Selected geography, either `"nhp"` or `"la"`.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_year Integer. Selected year in the form `202324`.
#' @param selected_strategy Character. Strategy variable name, e.g. `"alcohol_partially_attributable_acute"`.
#' @param providers_lookup Dataframe. A lookup from a provider code to its name.
#' @param peers_lookup Dataframe. A lookup from a provider to its peers.
#' @return A data.frame.
#' @export
generate_rates_funnel_data <- function(
  selected_geography,
  selected_provider,
  selected_strategy,
  selected_year,
  providers_lookup,
  peers_lookup
) {
  geography <- switch(selected_geography, "nhp" = "provider", "la" = "lad23cd")

  filename <- app_sys("app", "data", geography, "rates.parquet")

  df <- arrow::open_dataset(filename) |>
    dplyr::filter(
      .data$strategy == .env$selected_strategy,
      .data$fyear == .env$selected_year,
    ) |>
    dplyr::collect()

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
    dplyr::select(-"crude_rate") |>
    dplyr::inner_join(providers_lookup, by = "provider") |> # adds plotting label
    dplyr::mutate(
      is_peer = dplyr::case_when(
        .data$provider == .env$selected_provider ~ "self",
        .data$provider %in% .env$peers_lookup ~ "peer",
        .default = "other"
      )
    ) |>
    dplyr::arrange(.data$is_peer) # to plot focal scheme last
}

#' Generate Rates Trend Data
#' @param selected_geography Character. Selected geography, either `"nhp"` or `"la"`.
#' @param selected_provider Character. Provider code, e.g. `"RCF"`.
#' @param selected_strategy Character. Strategy variable name, e.g. `"alcohol_partially_attributable_acute"`.
#' @return A data.frame.
#' @export
generate_rates_trend_data <- function(
  selected_geography,
  selected_provider,
  selected_strategy,
  peers_lookup
) {
  geography <- switch(selected_geography, "nhp" = "provider", "la" = "lad23cd")

  filename <- app_sys("app", "data", geography, "rates.parquet")

  arrow::open_dataset(filename) |>
    dplyr::filter(
      .data$provider %in% c(.env$selected_provider, .env$peers_lookup),
      .data$strategy == .env$selected_strategy
    ) |>
    dplyr::collect() |>
    dplyr::rename(rate = "std_rate") |>
    dplyr::select(-"crude_rate") |>
    dplyr::mutate(
      is_peer = dplyr::case_when(
        .data$provider == .env$selected_provider ~ "self",
        .data$provider %in% .env$peers_lookup ~ "peer",
        .default = "other"
      )
    )
}

#' Generate Function to Calculate U-Prime values
#' @param df A data.frame. Rates data
#' @return A list containing items to produce a U-Prime funnel chart.
#' @export
uprime_calculations <- function(df) {
  df <- dplyr::arrange(df, .data$denominator)

  cl <- df$national_rate[[1]] # centre line
  stdev <- sqrt(cl / df$denominator)
  z_i <- (df$rate - cl) / stdev
  mr <- abs(diff(z_i)) # moving range
  ulmr <- 3.267 * mean(mr, na.rm = TRUE) # upper-limit of moving range
  amr <- mean(mr[mr < ulmr], na.rm = TRUE) # average moving range
  sigma_z <- amr / 1.128
  sd_fn <- \(x) sqrt(cl / x) * sigma_z
  cl_fn <- \(s) \(x) cl + s * sd_fn(x)

  list(
    cl = cl,
    z_i = (df$rate - cl) / sd_fn(df$denominator),
    lcl3 = cl_fn(-3), # lower control limit
    ucl3 = cl_fn(3), # upper control limit
    lcl2 = cl_fn(-2),
    ucl2 = cl_fn(2)
  )
}
