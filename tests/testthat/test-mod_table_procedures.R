test_that("ui", {
  skip_if(interactive(), "This test will fail in interactive mode")

  setup_ui_test()

  ui <- mod_table_procedures_ui("test")

  expect_snapshot(ui)
})

test_that("it loads the procedures csv", {
  # arrange
  m <- mock("procedures_lookup")
  testthat::local_mocked_bindings("read_csv" = m, .package = "readr")

  # act
  shiny::testServer(
    mod_table_procedures_server,
    args = list(
      selected_geography = reactiveVal("nhp"),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("strategy"),
      selected_year = reactiveVal(1)
    ),
    {
      # assert
      expect_equal(procedures_lookup, "procedures_lookup")
      expect_called(m, 1)
      expect_call(
        m,
        1,
        readr::read_csv(
          app_sys("app", "reference", "procedures.csv"),
          col_types = "c"
        )
      )
    }
  )
})

test_that("procedures_prepared", {
  # arrange
  testthat::local_mocked_bindings(
    "read_csv" = \(...) "procedures_lookup",
    .package = "readr"
  )

  m <- mock("procedures_prepared")
  testthat::local_mocked_bindings(
    "prepare_procedures_data" = m
  )

  # act
  shiny::testServer(
    mod_table_procedures_server,
    args = list(
      selected_geography = reactiveVal("nhp"),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("strategy"),
      selected_year = reactiveVal(1)
    ),
    {
      actual <- procedures_prepared()

      # assert
      expect_equal(actual, "procedures_prepared")
      expect_called(m, 1)
      expect_args(m, 1, "procedures_lookup", "nhp", "R00", "strategy", 1)
    }
  )
})

test_that("procedures_table (no rows)", {
  # arrange
  testthat::local_mocked_bindings("prepare_procedures_data" = \(...) {
    tibble::tibble()
  })

  # act
  shiny::testServer(
    mod_table_procedures_server,
    args = list(
      selected_geography = reactiveVal("nhp"),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("strategy"),
      selected_year = reactiveVal(1)
    ),
    {
      # assert
      expect_error(
        output$procedures_table,
        "No procedures to display."
      )
    }
  )
})

test_that("procedures_table (with rows)", {
  # arrange
  sample_prepared_data <- tibble::tibble(a = 1, b = 2)

  m <- mock("entabled")
  testthat::local_mocked_bindings(
    "prepare_procedures_data" = \(...) sample_prepared_data,
    "entable_encounters" = m
  )

  testthat::local_mocked_bindings(
    "render_gt" = shiny::renderText,
    .package = "gt"
  )

  # act
  shiny::testServer(
    mod_table_procedures_server,
    args = list(
      selected_geography = reactiveVal("nhp"),
      selected_provider = reactiveVal("R00"),
      selected_strategy = reactiveVal("strategy"),
      selected_year = reactiveVal(1)
    ),
    {
      actual <- output$procedures_table

      # assert
      expect_equal(actual, "entabled")
      expect_called(m, 1)
      expect_args(m, 1, sample_prepared_data)
    }
  )
})
