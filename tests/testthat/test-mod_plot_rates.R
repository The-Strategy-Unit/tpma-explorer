test_that("ui", {
  # arrange
  setup_mod_plot_rates_ui_tests()

  # act
  ui <- mod_plot_rates_ui("test")

  # assert
  expect_snapshot(ui)
})

test_that("ui calls mod_plot_rates_trend_ui", {
  # arrange
  mocks <- setup_mod_plot_rates_ui_tests()

  # act
  ui <- mod_plot_rates_ui("test")

  # assert
  expect_called(mocks$mod_plot_rates_trend_ui, 1)
  expect_args(mocks$mod_plot_rates_trend_ui, 1, "test-mod_plot_rates_trend")
})

test_that("ui calls mod_plot_rates_funnel_ui", {
  # arrange
  mocks <- setup_mod_plot_rates_ui_tests()

  # act
  ui <- mod_plot_rates_ui("test")

  # assert
  expect_called(mocks$mod_plot_rates_funnel_ui, 1)
  expect_args(mocks$mod_plot_rates_funnel_ui, 1, "test-mod_plot_rates_funnel")
})

test_that("ui calls mod_plot_rates_box_ui", {
  # arrange
  mocks <- setup_mod_plot_rates_ui_tests()

  # act
  ui <- mod_plot_rates_ui("test")

  # assert
  expect_called(mocks$mod_plot_rates_box_ui, 1)
  expect_args(mocks$mod_plot_rates_box_ui, 1, "test-mod_plot_rates_box")
})

test_that("server sets up strategies_config", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()
  m <- mocks$get_golem_config

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      # assert
      expect_equal(strategies_config, "strategies_config")
      expect_called(m, 1)
      expect_args(m, 1, "mitigators_config")
    }
  )
})

test_that("server sets up strategy_group_lookup", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()
  m <- mocks$get_golem_config

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      # assert
      expect_equal(strategy_group_lookup, "strategy_group_lookup")
      expect_called(m, 1)
      expect_args(m, 1, "mitigators_config")
    }
  )
})

test_that("modules are correctly instantiated", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      # assert
      expect_called(mocks$mod_plot_rates_trend_server, 1)
      expect_args(
        mocks$mod_plot_rates_trend_server,
        1,
        "mod_plot_rates_trend",
        rates_trend_data,
        y_axis_limits,
        y_axis_title,
        y_labels,
        selected_year,
        16
      )

      expect_called(mocks$mod_plot_rates_funnel_server, 1)
      expect_args(
        mocks$mod_plot_rates_funnel_server,
        1,
        "mod_plot_rates_funnel",
        rates_funnel_data,
        rates_funnel_calculations,
        y_axis_limits,
        funnel_x_title,
        16
      )

      expect_called(mocks$mod_plot_rates_box_server, 1)
      expect_args(
        mocks$mod_plot_rates_box_server,
        1,
        "mod_plot_rates_box",
        rates_funnel_data,
        y_axis_limits,
        16
      )
    }
  )
})

test_that("peers_lookup", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()
  m <- mocks$get_peers_lookup

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      # assert
      expect_equal(peers_lookup(), "peers_lookup")

      expect_called(m, 1)
      expect_args(m, 1, "nhp", "R00")

      selected_geography("la")
      selected_provider("E06000001")
      peers_lookup()
      expect_called(m, 2)
      expect_args(m, 2, "la", "E06000001")
    }
  )
})

test_that("providers_lookup", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()
  m <- mocks$get_providers_lookup

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      # assert
      expect_equal(providers_lookup(), "providers_lookup")

      expect_called(m, 1)
      expect_args(m, 1, "nhp")

      selected_geography("la")
      providers_lookup()
      expect_called(m, 2)
      expect_args(m, 2, "la")
    }
  )
})

test_that("rates_trend_data", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      actual <- rates_trend_data()

      # assert
      expect_equal(actual, "rates_trend_data")
      expect_called(mocks$generate_rates_trend_data, 1)
      expect_args(mocks$generate_rates_trend_data, 1, "nhp", "R00", "Strategy A", "peers_lookup")
    }
  )
})

test_that("rates_funnel_data", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      actual <- rates_funnel_data()

      # assert
      expect_equal(actual, "rates_funnel_data")
      expect_called(mocks$generate_rates_funnel_data, 1)
      expect_args(
        mocks$generate_rates_funnel_data,
        1,
        "nhp",
        "R00",
        "Strategy A",
        202324,
        "providers_lookup",
        "peers_lookup"
      )
    }
  )
})

test_that("rates_funnel_calculations", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      actual <- rates_funnel_calculations()

      # assert
      expect_equal(actual, "uprime")
      expect_called(mocks$uprime_calculations, 1)
      expect_args(
        mocks$uprime_calculations,
        1,
        "rates_funnel_data"
      )
    }
  )
})

test_that("y_axis_limits", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      actual <- y_axis_limits()

      # assert
      expect_equal(actual, "y_axis_limits")
      expect_called(mocks$get_rates_y_axis_limits, 1)
      expect_args(
        mocks$get_rates_y_axis_limits,
        1,
        "rates_trend_data",
        "rates_funnel_data",
        "uprime"
      )
    }
  )
})

test_that("strategy_config", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  strategy_config <- list(
    "group a" = list(
      y_axis_title = "y axis title",
      number_type = "y labels",
      funnel_x_title = "funnel x title"
    )
  )
  strategy_group_lookup <- list(
    "Strategy A" = "group a"
  )

  local_mocked_bindings(
    "get_golem_config" = mock(strategy_config),
    "make_strategy_group_lookup" = mock(strategy_group_lookup)
  )

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324),
      base_size = 16
    ),
    {
      # assert
      expect_equal(y_axis_title(), "y axis title")
      expect_equal(y_labels(), "y labels")
      expect_equal(funnel_x_title(), "funnel x title")
    }
  )
})
