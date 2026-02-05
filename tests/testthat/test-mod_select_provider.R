library(mockery)
library(testthat)

test_that("ui", {
  testthat::local_mocked_bindings(
    "p_randomInt" = \(...) "X",
    .package = "shiny"
  )

  ui <- mod_select_provider_ui("test")

  expect_snapshot(ui)
})

test_that("server returns reactive", {
  # arrange
  test_server <- function(input, output, session) {
    selected_provider <- mod_select_provider_server("test", reactiveVal("nhp"))
  }

  # act
  shiny::testServer(test_server, {
    session$setInputs("test-provider_select" = "a")
    expect_equal(selected_provider(), "a")

    session$setInputs("test-provider_select" = "b")
    expect_equal(selected_provider(), "b")
  })
})

test_that("providers reactive", {
  # arrange
  m <- mock("providers nhp", "providers la")

  testthat::local_mocked_bindings(
    "read_json" = m,
    .package = "jsonlite"
  )
  testthat::local_mocked_bindings(
    "app_sys" = \(...) file.path("inst", ...),
  )

  # act
  shiny::testServer(
    mod_select_provider_server,
    args = list(
      selected_geography = reactiveVal()
    ),
    {
      # assert
      selected_geography("nhp")
      expect_equal(providers(), "providers nhp")

      selected_geography("la")
      expect_equal(providers(), "providers la")

      selected_geography("other")
      expect_error(providers())

      expect_called(m, 2)
      expect_args(
        m,
        1,
        "inst/app/data/nhp-datasets.json",
        simplify_vector = TRUE
      )
      expect_args(
        m,
        2,
        "inst/app/data/la-datasets.json",
        simplify_vector = TRUE
      )
    }
  )
})


test_that("it updates the select input", {
  # arrange
  m <- mock()
  testthat::local_mocked_bindings(
    "updateSelectInput" = m,
    .package = "shiny"
  )

  # mock what will happen to providers as we change the selected geography
  testthat::local_mocked_bindings(
    "read_json" = mock(
      list("A" = "a", "B" = "b"),
      list("C" = "c", "D" = "d")
    ),
    .package = "jsonlite"
  )

  # act
  shiny::testServer(
    mod_select_provider_server,
    args = list(
      selected_geography = reactiveVal()
    ),
    {
      # assert
      selected_geography("nhp")
      session$flushReact()
      expect_called(m, 1)
      expect_args(
        m,
        1,
        session,
        "provider_select",
        label = "Choose a trust:",
        choices = c("a" = "A", "b" = "B")
      )

      selected_geography("la")
      session$flushReact()
      expect_called(m, 2)
      expect_args(
        m,
        2,
        session,
        "provider_select",
        label = "Choose an LA:",
        choices = c("c" = "C", "d" = "D")
      )
    }
  )
})
