#' Plot Trend in Rates
#' @param rates_df A data.frame. Must contain columns given by `fyear_col` and
#'     `rate_col`. Pre-filtered for a given provider and strategy. One row per
#'     financial year.
#' @param fyear_col Character. Name of the column in `rates_df` containing the
#'     financial year in the form `"2023/24"`.
#' @param rate_col Character. Name of the column in `rates_df` containing the
#'     rate value (the type of which is dependent on the strategy).
plot_rates <- function(rates_df, fyear_col = "fyear", rate_col = "rate") {
  x_breaks <- rates_df[[fyear_col]]
  x_labels <- enstring_fyear(x_breaks)

  rates_df |>
    ggplot2::ggplot(ggplot2::aes(
      x = .data[[fyear_col]],
      y = .data[[rate_col]]
    )) +
    ggplot2::geom_line() +
    ggplot2::labs(
      x = "Financial year",
      y = "Rate"
    ) +
    ggplot2::scale_x_continuous(
      breaks = x_breaks,
      labels = x_labels,
      guide = ggplot2::guide_axis(angle = 45)
    )
}
