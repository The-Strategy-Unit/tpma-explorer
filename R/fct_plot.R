#' Plot Trend in Rates
#' @param rates_df A data.frame. Must contain columns given by `fyear_col` and
#'     `rate_col`. Pre-filtered for a given provider and strategy. One row per
#'     financial year.
#' @param fyear_col Character. Name of the column in `rates_df` containing the
#'     financial year in the form `"2023/24"`.
#' @param rate_col Character. Name of the column in `rates_df` containing the
#'     rate value (the type of which is dependent on the strategy).
#' @return A ggplot2 object.
#' @export
plot_rates <- function(rates_df, fyear_col = "fyear", rate_col = "rate") {
  rates_df |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[[fyear_col]],
        y = .data[[rate_col]]
      )
    ) +
    ggplot2::geom_line() +
    ggplot2::labs(
      x = "Financial year",
      y = "Rate"
    )
}
