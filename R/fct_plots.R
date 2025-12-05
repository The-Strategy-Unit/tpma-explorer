#' Plot Rates Trend Over Time
#' @param rates_trend_data A data.frame. Rates data read in from Azure, filtered
#'     for a given provider and strategy, and arranged by year.
#' @param baseline_year Integer. Baseline year in the form `202324`.
#' @param y_axis_limits Numeric vector. Min and max values for the y axis.
#' @param x_axis_title Character. Title for the x-axis.
#' @param y_axis_title Character. Title for the y-axis.
#' @return A 'ggplot2' object.
#' @export
plot_rates_trend <- function(
  rates_trend_data,
  baseline_year,
  y_axis_limits,
  x_axis_title = "Financial year",
  y_axis_title
) {
  rates_trend_data |>
    ggplot2::ggplot(
      ggplot2::aes(as.factor(.data[["fyear"]]), .data[["rate"]], group = 1)
    ) +
    ggplot2::geom_line() +
    ggplot2::geom_point(
      data = \(.x) dplyr::filter(.x, .data[["fyear"]] == baseline_year),
      colour = "red"
    ) +
    # TODO: add labels = number_format to scale_y_continuous
    ggplot2::scale_y_continuous(name = y_axis_title) +
    ggplot2::coord_cartesian(ylim = y_axis_limits) +
    ggplot2::scale_x_discrete(
      labels = \(.x) stringr::str_replace(.x, "^(\\d{4})(\\d{2})$", "\\1/\\2")
    ) +
    ggplot2::labs(x = x_axis_title) +
    theme_rates()
}

#' Plot Rates Funnel with Peers
#' @param rates_funnel_data A data.frame. Rates data read in from Azure and
#'     processed with [generate_rates_baseline_data] to filter for provider,
#'     strategy and year, followed by [generate_rates_funnel_data] to generate
#'     values for funnel structure.
#' @param y_axis_limits Numeric vector. Min and max values for the y axis.
#' @param x_axis_title Character. Title for the x-axis.
#' @return A 'ggplot2' object.
#' @export
plot_rates_funnel <- function(rates_funnel_data, y_axis_limits, x_axis_title) {
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
    ggplot2::coord_cartesian(ylim = y_axis_limits) +
    ggplot2::labs(x = x_axis_title) +
    theme_rates(has_y_axis = FALSE)
}

#' Plot Rates Boxplot with Peers
#' @param rates_box_data A data.frame. Rates data read in from Azure and
#'     processed with [generate_rates_baseline_data] to filter for provider,
#'     strategy and year.
#' @param y_axis_limits Numeric vector. Min and max values for the y axis.
#' @return A 'ggplot2' object.
#' @export
plot_rates_box <- function(rates_box_data, y_axis_limits) {
  rates_box_data |>
    ggplot2::ggplot(ggplot2::aes(x = "", y = .data$rate)) +
    ggplot2::geom_boxplot(alpha = 0.2, outlier.shape = NA) +
    ggbeeswarm::geom_quasirandom(ggplot2::aes(colour = .data$is_peer)) +
    ggplot2::scale_colour_manual(
      values = c("TRUE" = "black", "FALSE" = "red"),
      na.value = "lightgrey"
    ) +
    ggplot2::coord_cartesian(ylim = y_axis_limits) +
    ggplot2::labs(x = "") +
    theme_rates(has_y_axis = FALSE)
}

#' A 'ggplot2' Theme for Rates Plots
#' @param has_y_axis Logical. Should the y-axis, ticks and labels be shown?
#'     Default `TRUE`.
#' @return A 'ggplot2' theme.
#' @export
theme_rates <- function(has_y_axis = TRUE) {
  theme <- ggplot2::theme(
    legend.position = "none",
    panel.background = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(
      "#9d928a",
      linetype = "dotted"
    )
  )

  if (!has_y_axis) {
    theme <- theme +
      ggplot2::theme(
        axis.ticks.x = ggplot2::element_blank(),
        axis.ticks.y = ggplot2::element_blank(),
        axis.text.y = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_blank()
      )
  }

  theme
}

#' Plot Age-Sex Pyramid
#' @param age_sex_data A data.frame. Age-sex data read from Azure and processed
#'     with [prepare_age_sex_data]. Counts for each strategy split by provider,
#'     year, age group and sex.
#' @return A 'ggplot2' object.
#' @export
plot_age_sex_pyramid <- function(age_sex_data) {
  age_sex_data |>
    ggplot2::ggplot(
      ggplot2::aes(
        .data[["n"]],
        .data[["age_group"]],
        colour = .data[["sex"]],
        fill = ggplot2::after_scale(ggplot2::alpha(.data[["colour"]], 0.4))
      )
    ) +
    ggplot2::geom_col(position = "stack", width = 1, na.rm = TRUE) +
    ggplot2::scale_colour_manual(
      values = c("Males" = "#5881c1", "Females" = "#ec6555")
    ) +
    ggplot2::scale_x_continuous(labels = purrr::compose(scales::comma, abs)) +
    ggplot2::scale_y_discrete(drop = FALSE) +
    ggplot2::guides(
      colour = ggplot2::guide_legend(NULL)
    ) +
    ggplot2::labs(x = NULL, y = NULL) +
    ggplot2::theme(
      legend.position = "bottom",
      panel.background = ggplot2::element_blank()
    )
}

#' Plot National Elicitation Exercise (NEE) Interval
#' @param nee_data A data.frame. Mean, p10 and p90 predictions for each of the
#'     strategies that were part of the National Elicitation Exercise (NEE),
#'     filtered for the user's selected strategy.
#' @return A 'ggplot2' object.
#' @export
plot_nee <- function(nee_data) {
  nee_data |>
    ggplot2::ggplot() +
    ggplot2::geom_segment(
      ggplot2::aes(
        y = 1,
        yend = 1,
        x = .data[["percentile10"]],
        xend = .data[["percentile90"]]
      ),
      linewidth = 2
    ) +
    ggplot2::geom_point(
      ggplot2::aes(y = 1, x = mean),
      size = 5,
      colour = "#f9bf14"
    ) +
    ggplot2::xlim(0, 100) +
    ggplot2::xlab(
      "80% prediction interval"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.title.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank()
    )
}
