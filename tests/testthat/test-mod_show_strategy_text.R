library(mockery)
library(testthat)

test_that("ui", {
  testthat::local_mocked_bindings(
    "p_randomInt" = \(...) "X",
    .package = "shiny"
  )

  ui <- mod_show_strategy_text_ui("test")

  expect_snapshot(ui)
})

test_that("server loads descriptions lookup", {
  # arrange
  m <- mock("descriptions_lookup")
  local_mocked_bindings(
    "read_json" = m,
    .package = "jsonlite"
  )

  # act
  shiny::testServer(mod_show_strategy_text_server, {
    # assert
    expect_called(m, 1)
    expect_call(
      m,
      1,
      jsonlite::read_json(
        app_sys("app", "data", "descriptions.json"),
        simplifyVector = TRUE
      )
    )
  })
})

test_that("strategy_text is rendered", {
  # arrange
  local_mocked_bindings(
    "read_json" = \(...) "descriptions_lookup",
    .package = "jsonlite"
  )

  m1 <- mock("strategy text")
  m2 <- mock("html")

  local_mocked_bindings(
    "fetch_strategy_text" = m1,
    "convert_md_to_html" = m2
  )

  # act
  shiny::testServer(
    mod_show_strategy_text_server,
    args = list(selected_strategy = reactiveVal("a")),
    {
      # assert
      actual <- output$strategy_text

      expect_equal(actual, "html")

      expect_called(m1, 1)
      expect_args(
        m1,
        1,
        "a",
        "descriptions_lookup"
      )

      expect_called(m2, 1)
      expect_args(m2, 1, "strategy text")
    }
  )
})

test_that("strategy_text caches properly", {
  # arrange
  local_mocked_bindings(
    "read_json" = \(...) "descriptions_lookup",
    .package = "jsonlite"
  )

  m1 <- mock("t1", "t2", "t3")
  m2 <- mock("h1", "h2", "h3")

  local_mocked_bindings(
    "fetch_strategy_text" = m1,
    "convert_md_to_html" = m2
  )

  # act
  shiny::testServer(
    mod_show_strategy_text_server,
    args = list(selected_strategy = reactiveVal()),
    {
      # assert
      selected_strategy("a")
      session$private$flush()
      a1 <- output$strategy_text

      selected_strategy("b")
      session$private$flush()
      a2 <- output$strategy_text

      selected_strategy("a")
      session$private$flush()
      a3 <- output$strategy_text

      expect_equal(a1, "h1")
      expect_equal(a2, "h2")
      expect_equal(a3, "h1")

      expect_called(m1, 2)
      expect_args(m1, 1, "a", "descriptions_lookup")
      expect_args(m1, 2, "b", "descriptions_lookup")

      expect_called(m2, 2)
      expect_args(m2, 1, "t1")
      expect_args(m2, 2, "t2")
    }
  )
})
