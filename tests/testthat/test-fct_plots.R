test_that("plot_rates_trend", {
  # arrange
  # nolint start
  rates_trend_data <- tibble::tribble(
    ~fyear , ~rate ,
    201516 , 0.10  ,
    201617 , 0.12  ,
    201718 , 0.11  ,
    201819 , 0.09  ,
    201920 , 0.08  ,
    202021 , 0.07  ,
    202122 , 0.06  ,
    202223 , 0.05  ,
    202324 , 0.04  
  )
  # nolint end

  selected_year <- 202324
  y_axis_limits <- c(0, 0.16)
  x_axis_title <- "Financial year"
  y_axis_title <- "Rate per 100,000 population"
  y_labels <- scales::label_percent(accuracy = 0.1)

  # act
  actual <- plot_rates_trend(
    rates_trend_data,
    selected_year,
    y_axis_limits,
    x_axis_title,
    y_axis_title,
    y_labels
  )

  # assert
  vdiffr::expect_doppelganger("plot_rates_trend", actual)
})

test_that("plot_rates_funnel", {
  # arrange
  withr::local_seed(1)
  # nolint start
  rates_funnel_data <- tibble::tribble(
    ~rate , ~denominator , ~national_rate , ~is_peer , ~provider ,
    0.10  ,         1000 ,           0.08 , TRUE     , "a"       ,
    0.12  ,         1200 ,           0.08 , TRUE     , "b"       ,
    0.11  ,         1400 ,           0.08 , FALSE    , "c"       ,
    0.09  ,         1600 ,           0.08 , TRUE     , "d"       ,
    0.08  ,         1800 ,           0.08 , NA       , "e"       ,
    0.07  ,         2000 ,           0.08 , NA       , "f"       ,
    0.06  ,         2200 ,           0.08 , NA       , "g"       ,
    0.05  ,         2400 ,           0.08 , NA       , "h"       ,
    0.04  ,         2600 ,           0.08 , TRUE     , "i"       
  )
  # nolint end

  funnel_calculations <- uprime_calculations(rates_funnel_data)
  y_axis_limits <- c(0, 0.16)
  x_axis_title <- "Population size"

  # act
  actual <- plot_rates_funnel(
    rates_funnel_data,
    funnel_calculations,
    y_axis_limits,
    x_axis_title
  )

  # assert
  vdiffr::expect_doppelganger("plot_rates_funnel", actual)
})

test_that("plot_rates_box", {
  # arrange
  # nolint start
  rates_box_data <- tibble::tribble(
    ~rate , ~denominator , ~national_rate , ~is_peer , ~provider ,
    0.10  ,         1000 ,           0.08 , TRUE     , "a"       ,
    0.12  ,         1200 ,           0.08 , TRUE     , "b"       ,
    0.11  ,         1400 ,           0.08 , FALSE    , "c"       ,
    0.09  ,         1600 ,           0.08 , TRUE     , "d"       ,
    0.08  ,         1800 ,           0.08 , NA       , "e"       ,
    0.07  ,         2000 ,           0.08 , NA       , "f"       ,
    0.06  ,         2200 ,           0.08 , NA       , "g"       ,
    0.05  ,         2400 ,           0.08 , NA       , "h"       ,
    0.04  ,         2600 ,           0.08 , TRUE     , "i"       
  )
  # nolint end

  y_axis_limits <- c(0, 0.16)

  # act
  actual <- plot_rates_box(
    rates_box_data,
    y_axis_limits
  )

  # assert
  vdiffr::expect_doppelganger("plot_rates_box", actual)
})

test_that("theme_rates (has_y_axis = TRUE)", {
  actual <- theme_rates(TRUE)
  expect_snapshot(actual)
})

test_that("theme_rates (has_y_axis = FALSE)", {
  actual <- theme_rates(FALSE)
  expect_snapshot(actual)
})

test_that("plot_age_sex_pyramid", {
  # arrange
  age_sex_data <- tibble::tribble(
    ~age_group, ~sex, ~n,
    "0-4", "Males", -1,
    "5-9", "Males", -2,
    "10-14", "Males", -3,
    "15-19", "Males", -4,
    "20-24", "Males", -5,
    "25-29", "Males", -6,
    "30-34", "Males", -7,
    "35-39", "Males", -8,
    "40-44", "Males", -9,
    "45-49", "Males", -10,
    "50-54", "Males", -11,
    "55-59", "Males", -12,
    "60-64", "Males", -13,
    "65-69", "Males", -14,
    "70-74", "Males", -15,
    "75-79", "Males", -16,
    "80-84", "Males", -17,
    "85-89", "Males", -18,
    "90+", "Males", -19,
    "0-4", "Females", 19,
    "5-9", "Females", 18,
    "10-14", "Females", 17,
    "15-19", "Females", 16,
    "20-24", "Females", 15,
    "25-29", "Females", 14,
    "30-34", "Females", 13,
    "35-39", "Females", 12,
    "40-44", "Females", 11,
    "45-49", "Females", 10,
    "50-54", "Females", 9,
    "55-59", "Females", 8,
    "60-64", "Females", 7,
    "65-69", "Females", 6,
    "70-74", "Females", 5,
    "75-79", "Females", 4,
    "80-84", "Females", 3,
    "85-89", "Females", 2,
    "90+", "Females", 1
  ) |>
    dplyr::mutate(
      age_group = factor(
        age_group,
        levels = c(
          "0-4",
          "5-9",
          "10-14",
          "15-19",
          "20-24",
          "25-29",
          "30-34",
          "35-39",
          "40-44",
          "45-49",
          "50-54",
          "55-59",
          "60-64",
          "65-69",
          "70-74",
          "75-79",
          "80-84",
          "85-89",
          "90+"
        )
      )
    )

  # act
  actual <- plot_age_sex_pyramid(age_sex_data)

  # assert
  vdiffr::expect_doppelganger("plot_age_sex_pyramid", actual)
})

test_that("plot_nee", {
  # arrange
  nee_data <- tibble::tribble(
    ~strategy, ~percentile10, ~mean, ~percentile90,
    "Strategy A", 20, 50, 80
  )

  # act
  actual <- plot_nee(nee_data)

  # assert
  vdiffr::expect_doppelganger("plot_nee", actual)
})
