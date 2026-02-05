test_that("ui", {
  setup_ui_test()

  ui <- mod_show_strategy_text_ui("test")

  expect_snapshot(ui)
})

test_that("mod_show_strategy_text_get_descriptions_lookup", {
  # arrange
  sample_descriptions_lookup <- c(
    "strategy_a",
    "strategy_b"
  )
  m <- mock(sample_descriptions_lookup)
  local_mocked_bindings(
    "read_json" = m,
    .package = "jsonlite"
  )

  # act
  actual <- mod_show_strategy_text_get_descriptions_lookup()

  # assert
  expect_equal(actual, sample_descriptions_lookup)
})

test_that("strategy_stub", {
  # arrange
  local_mocked_bindings(
    "mod_show_strategy_text_get_descriptions_lookup" = \() {
      c(
        "strategy_a",
        "strategy_b"
      )
    }
  )

  # act
  shiny::testServer(
    mod_show_strategy_text_server,
    args = list(selected_strategy = reactiveVal("a")),
    {
      # assert
      selected_strategy("strategy_a_acute")
      actual1 <- strategy_stub()

      selected_strategy("strategy_a_chronic")
      actual2 <- strategy_stub()

      selected_strategy("strategy_b")
      actual3 <- strategy_stub()

      expect_equal(actual1, "strategy_a")
      expect_equal(actual2, "strategy_a")
      expect_equal(actual3, "strategy_b")
    }
  )
})

test_that("strategy_text", {
  # arrange
  m <- mock("text_a", "text_b")
  local_mocked_bindings(
    "mod_show_strategy_text_get_descriptions_lookup" = \() {
      c(
        "strategy_a",
        "strategy_b"
      )
    },
    "fetch_strategy_text" = m
  )

  # act
  shiny::testServer(
    mod_show_strategy_text_server,
    args = list(selected_strategy = reactiveVal("a")),
    {
      # act
      selected_strategy("strategy_a_acute")
      actual1 <- strategy_text()

      selected_strategy("strategy_b")
      actual2 <- strategy_text()

      # validate caching: this should not call fetch_strategy_text again
      selected_strategy("strategy_a_chronic")
      actual3 <- strategy_text()

      # assert
      expect_equal(actual1, "text_a")
      expect_equal(actual2, "text_b")
      expect_equal(actual3, "text_a")

      expect_called(m, 2)
      expect_args(m, 1, "strategy_a")
      expect_args(m, 2, "strategy_b")
    }
  )
})

test_that("strategy_text is rendered", {
  # arrange
  m <- mock("html")
  local_mocked_bindings(
    "mod_show_strategy_text_get_descriptions_lookup" = \() {
      c(
        "strategy_a",
        "strategy_b"
      )
    },
    "fetch_strategy_text" = \(...) "strategy text",
    "md_string_to_html" = m
  )

  # act
  shiny::testServer(
    mod_show_strategy_text_server,
    args = list(selected_strategy = reactiveVal("strategy_a")),
    {
      # assert
      actual <- output$strategy_text

      expect_equal(actual, "html")

      expect_called(m, 1)
      expect_args(
        m,
        1,
        "strategy text"
      )
    }
  )
})
