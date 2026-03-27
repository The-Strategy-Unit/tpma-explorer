test_that("ui", {
  skip_if(interactive(), "This test will fail in interactive mode")

  # in helper-ui.R, ignore lint error "no visible global function definition for 'setup_ui_test'""
  setup_ui_test() # nolint: object_usage_linter

  ui <- mod_plot_nee_ui("test")

  expect_snapshot(ui)
})

test_that("selected_nee_data", {
  # arrange
  expected <- tibble::tibble(
    param_name = "smoking",
    mean = 84.3,
    percentile10 = 98.9,
    percentile90 = 60.0
  )

  # act
  shiny::testServer(
    mod_plot_nee_server,
    args = list(
      selected_strategy = reactiveVal("smoking")
    ),
    {
      actual <- selected_nee_data()

      # assert
      expect_equal(actual, expected, tolerance = 1e-1)
    }
  )
})

test_that("nee (no rows)", {
  # arrange
  testthat::local_mocked_bindings("prepare_age_sex_data" = \(...) {
    tibble::tibble()
  })

  # act
  shiny::testServer(
    mod_plot_nee_server,
    args = list(
      selected_strategy = reactiveVal("X")
    ),
    {
      # assert
      expect_equal(
        output$nee_text,
        "This TPMA was not part of that exercise. No estimate is available."
      )
    }
  )
})


test_that("nee (with rows)", {
  # arrange
  expected <- paste0(
    "They predicted that a mean of <b>16%</b> of this type of activity could be mitigated, ",
    "with an 80% prediction interval from <b>1%</b> to <b>40%</b>."
  )

  # act
  shiny::testServer(
    mod_plot_nee_server,
    args = list(
      selected_strategy = reactiveVal("smoking")
    ),
    {
      actual <- output$nee_text

      # assert
      expect_equal(actual, expected)
    }
  )
})
