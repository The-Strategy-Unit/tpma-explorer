test_that("ui", {
  setup_ui_test()

  ui <- mod_plot_rates_trend_ui("test")

  expect_snapshot(ui)
})


test_that("rates_trend_plot (no rows)", {
  # arrange

  # act
  shiny::testServer(
    mod_plot_rates_trend_server,
    args = list(
      rates = \() tibble::tibble(),
      y_axis_limits = \() c(0, 100),
      y_axis_title = \() "Y Axis",
      y_labels = \() "Y Labels",
      selected_year = \() 202324
    ),
    {
      # assert
      expect_error(
        output$rates_trend_plot,
        "No data available for these selections."
      )
    }
  )
})


test_that("rates_trend_plot (with rows)", {
  # arrange
  m <- mock("plot")
  testthat::local_mocked_bindings(
    "plot_rates_trend" = m
  )

  # replace renderPlot to avoid actual plotting, replace with renderText so we
  # can simply check the output
  testthat::local_mocked_bindings(
    "renderPlot" = shiny::renderText,
    .package = "shiny"
  )

  sample_data <- tibble::tibble(x = 1, y = 2)

  # act
  shiny::testServer(
    mod_plot_rates_trend_server,
    args = list(
      rates = \() sample_data,
      y_axis_limits = \() c(0, 100),
      y_axis_title = \() "Y Axis",
      y_labels = \() "Y Labels",
      selected_year = \() 202324
    ),
    {
      actual <- output$rates_trend_plot

      # assert
      expect_equal(actual, "plot")

      expect_called(m, 1)
      expect_args(m, 1, sample_data, 202324, c(0, 100), "Y Axis", "Y Labels")
    }
  )
})
