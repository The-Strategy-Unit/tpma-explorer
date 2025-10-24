#' Plot Rates Trend Over Time
#' @param rates_df A data.frame. Must contain columns given by `fyear_col` and
#'     `rate_col`. Pre-filtered for a given provider and strategy. One row per
#'     financial year.
#' @param fyear_col Character. Name of the column in `rates_df` containing the
#'     financial year in the form `"2023/24"`.
#' @param rate_col Character. Name of the column in `rates_df` containing the
#'     rate value (the type of which is dependent on the strategy).
#' @return A ggplot2 object.
#' @export
plot_rates_trend <- function(rates_df, fyear_col = "fyear", rate_col = "rate") {
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

#' Plot Rates Funnel with Peers
#' @param rates_funnel_data A data.frame.
#' @param plot_range Character. A vector of length two giving the y-axis limits.
#' @param x_axis_title Character.
#' @return A ggplot2 object.
#' @export
plot_rates_funnel <- function(rates_funnel_data, plot_range, x_axis_title) {
  lines_data <- rates_funnel_data |>
    dplyr::select(
      "denominator",
      tidyselect::matches("^(lower|upper)"),
      "mean"
    ) |>
    tidyr::pivot_longer(-"denominator", values_to = "rate")

  rates_funnel_data |>
    ggplot2::ggplot(ggplot2::aes(.data$denominator, .data$rate)) +
    ggplot2::geom_line(
      data = lines_data,
      ggplot2::aes(group = .data$name),
      linetype = "dashed",
      na.rm = TRUE
    ) +
    ggplot2::geom_point(ggplot2::aes(colour = .data$is_peer)) +
    ggrepel::geom_text_repel(
      data = dplyr::filter(rates_funnel_data, !is.na(.data$is_peer)),
      ggplot2::aes(label = .data$provider, colour = .data$is_peer),
      max.overlaps = Inf # include all labels
    ) +
    ggplot2::scale_colour_manual(
      values = c("TRUE" = "black", "FALSE" = "red"),
      na.value = "lightgrey"
    ) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::scale_x_continuous(labels = scales::comma_format()) +
    ggplot2::coord_cartesian(ylim = plot_range) +
    ggplot2::labs(x = x_axis_title) +
    ggplot2::theme(
      axis.ticks.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      legend.position = "none",
      panel.background = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_line("#9d928a", linetype = "dotted")
    )
}

#' Plot Rates Boxplot with Peers
#' @param trend_data A data.frame.
#' @param plot_range Character. A vector of length two giving the y-axis limits.
#' @return A ggplot2 object.
#' @export
plot_rates_box <- function(trend_data, plot_range) {
  trend_data |>
    ggplot2::ggplot(ggplot2::aes(x = "", y = .data$rate)) +
    ggplot2::geom_boxplot(alpha = 0.2, outlier.shape = NA) +
    ggbeeswarm::geom_quasirandom(ggplot2::aes(colour = .data$is_peer)) +
    ggplot2::scale_colour_manual(
      values = c("TRUE" = "black", "FALSE" = "red"),
      na.value = "lightgrey"
    ) +
    ggplot2::coord_cartesian(ylim = plot_range) +
    ggplot2::labs(x = "") +
    ggplot2::theme(
      axis.ticks.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      legend.position = "none",
      panel.background = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_line("#9d928a", linetype = "dotted")
    )
}
