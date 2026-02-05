library(mockery)
library(testthat)

test_that("ui", {
  setup_ui_test()

  ui <- mod_select_strategy_ui("test")

  expect_snapshot(ui)
})


test_that("mod_select_strategy_get_strategies works", {
  # arrange
  m <- mock(
    list(
      "a" = "Strategy A (IP-AA-001)",
      "b" = "Strategy B (IP-AA-002)",
      "c" = "Strategy C (IP-EF-001)",
      "d" = "Strategy D (OP-AA-001)",
      "e" = "Strategy E (OP-AA-002)"
    )
  )
  local_mocked_bindings(
    "read_json" = m,
    .package = "jsonlite"
  )
  # nolint start
  expected <- list(
    "ip" = tibble::tribble(
      ~strategy , ~name                    ,
      "a"       , "Strategy A (IP-AA-001)" ,
      "b"       , "Strategy B (IP-AA-002)" ,
      "c"       , "Strategy C (IP-EF-001)"
    ),
    op = tibble::tribble(
      ~strategy , ~name                    ,
      "d"       , "Strategy D (OP-AA-001)" ,
      "e"       , "Strategy E (OP-AA-002)"
    )
  ) |>
    dplyr::bind_rows(.id = "category") |>
    dplyr::group_nest(.data$category) |>
    tibble::deframe()
  # nolint end

  # act
  actual <- mod_select_strategy_get_strategies()

  # assert
  expect_equal(actual, expected)
  expect_called(m, 1)
  expect_call(
    m,
    1,
    jsonlite::read_json(
      app_sys("app", "data", "mitigators.json"),
      simplify_vector = TRUE
    )
  )
})

test_that("server returns reactive", {
  # arrange
  setup_mod_select_strategy_server()

  test_server <- function(input, output, session) {
    selected_strategy <- mod_select_strategy_server("test")
  }

  # act
  shiny::testServer(test_server, {
    session$setInputs("test-strategy_select" = "a")
    expect_equal(selected_strategy(), "a")

    session$setInputs("test-strategy_select" = "b")
    expect_equal(selected_strategy(), "b")
  })
})

test_that("it calls mod_select_strategy_get_strategies", {
  # arrange
  m <- setup_mod_select_strategy_server()

  # act
  shiny::testServer(mod_select_strategy_server, {
    # assert
    expect_called(m, 1)
    expect_args(m, 1)
  })
})

test_that("selected_category", {
  # arrange
  setup_mod_select_strategy_server()

  # act
  shiny::testServer(mod_select_strategy_server, {
    session$setInputs("strategy_category_select" = "ip")
    actual <- selected_category()

    # assert
    expect_equal(actual, "ip")
  })
})

test_that("it updates the strategy_select choices", {
  # arrange
  setup_mod_select_strategy_server()
  m <- mock()
  local_mocked_bindings(
    "updateSelectInput" = m,
    .package = "shiny"
  )

  # act
  shiny::testServer(mod_select_strategy_server, {
    # assert
    session$setInputs("strategy_category_select" = "ip")
    expect_called(m, 1)
    expect_args(
      m,
      1,
      session,
      "strategy_select",
      choices = c("Strategy A" = "a", "Strategy B" = "b")
    )

    # assert
    session$setInputs("strategy_category_select" = "op")
    expect_called(m, 2)
    expect_args(
      m,
      2,
      session,
      "strategy_select",
      choices = c("Strategy C" = "c", "Strategy D" = "d")
    )
  })
})
