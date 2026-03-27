test_that("ui", {
  skip_if(interactive(), "This test will fail in interactive mode")

  # in helper-ui.R, ignore lint error "no visible global function definition for 'setup_ui_test'""
  setup_ui_test() # nolint: object_usage_linter

  ui <- mod_select_strategy_ui("test")

  expect_snapshot(ui)
})


test_that("mod_select_strategy_get_strategies works", {
  # arrange
  m_json <- mock(
    list(
      "a" = "Strategy A (IP-AA-001)",
      "b" = "Strategy B (IP-AA-002)",
      "c" = "Strategy C (IP-EF-001)",
      "d" = "Strategy D (OP-AA-001)",
      "e" = "Strategy E (OP-AA-002)"
    )
  )
  m_csv <- mock(
    tibble::tibble(
      strategy = c("a", "b", "c", "d", "e"),
      category = c("aa", "aa", "ef", "aa", "aa"),
      category_name = c(
        "Admission avoidance",
        "Admission avoidance",
        "Efficiency",
        "Admission avoidance",
        "Admission avoidance"
      ),
      is_care_shift = c(TRUE, FALSE, TRUE, TRUE, FALSE)
    )
  )
  local_mocked_bindings(
    "read_csv" = m_csv,
    .package = "readr"
  )
  local_mocked_bindings(
    "read_json_file" = m_json,
    .package = "yyjsonr"
  )
  expected <- tibble::tibble(
    strategy = c("a", "b", "c", "d", "e"),
    strategy_name = c(
      "Strategy A (IP-AA-001)",
      "Strategy B (IP-AA-002)",
      "Strategy C (IP-EF-001)",
      "Strategy D (OP-AA-001)",
      "Strategy E (OP-AA-002)"
    ),
    activity_type = c("ip", "ip", "ip", "op", "op"),
    activity_type_name = c(
      "Inpatients",
      "Inpatients",
      "Inpatients",
      "Outpatients",
      "Outpatients"
    ),
    category = c("aa", "aa", "ef", "aa", "aa"),
    category_name = c(
      "Admission avoidance",
      "Admission avoidance",
      "Efficiency",
      "Admission avoidance",
      "Admission avoidance"
    ),
    is_care_shift = c(TRUE, FALSE, TRUE, TRUE, FALSE)
  )

  # act
  actual <- mod_select_strategy_get_strategies()

  # assert
  expect_equal(actual, expected)
  expect_called(m_csv, 1)
  expect_called(m_json, 1)
  expect_call(
    m_json,
    1,
    yyjsonr::read_json_file(
      app_sys("app", "reference", "mitigators.json")
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


test_that("strategies_filtered works", {
  # arrange
  setup_mod_select_strategy_server()

  # act
  shiny::testServer(mod_select_strategy_server, {
    # act 1
    session$setInputs(
      "strategy_activity_type_select" = "ip",
      "strategy_care_shift_checkbox" = TRUE
    )
    session$private$flush()

    # assert 1
    expect_equal(
      strategies_filtered()$strategy,
      c("a")
    )

    # act 2
    session$setInputs(
      "strategy_activity_type_select" = "ip",
      "strategy_care_shift_checkbox" = FALSE
    )
    session$private$flush()

    # assert 2
    expect_equal(
      strategies_filtered()$strategy,
      c("a", "b")
    )
  })
})

test_that("it updates the strategy_category_select choices", {
  # arrange
  setup_mod_select_strategy_server()

  m <- mock()
  local_mocked_bindings(
    "updateSelectInput" = m,
    .package = "shiny"
  )

  # act
  shiny::testServer(mod_select_strategy_server, {
    session$setInputs(
      "strategy_activity_type_select" = "ip",
      "strategy_care_shift_checkbox" = FALSE
    )
    session$private$flush()

    # assert
    expect_called(m, 1)
    expect_args(
      m,
      1,
      session,
      "strategy_category_select",
      choices = c("Admission avoidance" = "aa", "Efficiency" = "ef")
    )
  })
})

test_that("it updates the strategy_select choices (pending_selected is NULL)", {
  # arrange
  setup_mod_select_strategy_server()
  m <- mock()
  local_mocked_bindings(
    "updateSelectInput" = m,
    .package = "shiny"
  )

  # act
  shiny::testServer(mod_select_strategy_server, {
    session$setInputs(
      "strategy_activity_type_select" = "ip",
      "strategy_care_shift_checkbox" = FALSE,
      "strategy_category_select" = "aa"
    )
    session$private$flush()

    # assert
    expect_called(m, 2)
    expect_args(
      m,
      2,
      session,
      "strategy_select",
      choices = c("Strategy A" = "a"),
      selected = NULL
    )
  })
})


test_that("it updates the strategy_select choices (pending_selected is not NULL)", {
  # arrange
  setup_mod_select_strategy_server()
  m <- mock()
  local_mocked_bindings(
    "updateSelectInput" = m,
    .package = "shiny"
  )

  # act
  shiny::testServer(mod_select_strategy_server, {
    pending_strategy("a")
    session$setInputs(
      "strategy_activity_type_select" = "ip",
      "strategy_care_shift_checkbox" = FALSE,
      "strategy_category_select" = "aa"
    )
    session$private$flush()

    # assert
    expect_called(m, 2)
    expect_args(
      m,
      2,
      session,
      "strategy_select",
      choices = c("Strategy A" = "a"),
      selected = "a"
    )
  })
})

test_that("it updates the strategy_select choices (pending_selected is not valid)", {
  # arrange
  setup_mod_select_strategy_server()
  m <- mock()
  local_mocked_bindings(
    "updateSelectInput" = m,
    .package = "shiny"
  )

  # act
  shiny::testServer(mod_select_strategy_server, {
    pending_strategy("b")
    session$setInputs(
      "strategy_activity_type_select" = "ip",
      "strategy_care_shift_checkbox" = FALSE,
      "strategy_category_select" = "aa"
    )
    session$private$flush()

    # assert
    expect_called(m, 2)
    expect_args(
      m,
      2,
      session,
      "strategy_select",
      choices = c("Strategy A" = "a"),
      selected = NULL
    )
  })
})

test_that("it updates the pending_strategy when strategy_select changes", {
  # arrange
  setup_mod_select_strategy_server()

  # act
  shiny::testServer(mod_select_strategy_server, {
    # act 1
    session$setInputs("strategy_select" = "a")
    session$private$flush()

    # assert 1
    expect_equal(pending_strategy(), "a")

    # act 2
    session$setInputs("strategy_select" = "b")
    session$private$flush()

    # assert 2
    expect_equal(pending_strategy(), "b")
  })
})

test_that("onRestored works correctly", {
  # arrange
  setup_mod_select_strategy_server()
  m_update <- mock()
  m_restored <- mock()
  local_mocked_bindings(
    "updateSelectInput" = m_update,
    "onRestored" = m_restored,
    .package = "shiny"
  )

  # act
  shiny::testServer(mod_select_strategy_server, {
    # assert
    expect_called(m_restored, 1)
    expect_args(m_restored, 1, restore)

    restore(list(
      input = list(
        strategy_category_select = "aa",
        strategy_select = "a"
      )
    ))

    expect_called(m_update, 1)
    expect_args(
      m_update,
      1,
      session,
      "strategy_category_select",
      selected = "aa"
    )
  })
})
