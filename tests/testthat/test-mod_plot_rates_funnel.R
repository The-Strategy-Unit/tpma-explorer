library(mockery)
library(testthat)

test_that("ui", {
  testthat::local_mocked_bindings(
    "p_randomInt" = \(...) "X",
    .package = "shiny"
  )

  ui <- mod_plot_rates_funnel_ui("test")

  expect_snapshot(ui)
})


test_that("rates_funnel_plot (no rows)", {
  # arrange

  # act
  shiny::testServer(
    mod_plot_rates_funnel_server,
    args = list(
      rates = \() tibble::tibble(),
      funnel_calculations = \() "funnel calculations",
      y_axis_limits = \() c(0, 100),
      x_axis_title = \() "X Axis"
    ),
    {
      # assert
      expect_error(
        output$rates_funnel_plot,
        "No data available for these selections."
      )
    }
  )
})


test_that("rates_funnel_plot (with rows)", {
  # arrange
  m <- mock("plot")
  testthat::local_mocked_bindings(
    "plot_rates_funnel" = m
  )

  # replace renderPlot to avoid actual plotting, replace with renderText so we
  # can simply check the output
  testthat::local_mocked_bindings(
    "renderPlot" = shiny::renderText,
    .package = "shiny"
  )

  sample_data = tibble::tibble(x = 1, y = 2)

  # act
  shiny::testServer(
    mod_plot_rates_funnel_server,
    args = list(
      rates = \() sample_data,
      funnel_calculations = \() "funnel calculations",
      y_axis_limits = \() c(0, 100),
      x_axis_title = \() "X Axis"
    ),
    {
      actual <- output$rates_funnel_plot

      # assert
      expect_equal(actual, "plot")

      expect_called(m, 1)
      expect_args(m, 1, sample_data, "funnel calculations", c(0, 100), "X Axis")
    }
  )
})
