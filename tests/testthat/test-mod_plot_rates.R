library(mockery)
library(testthat)


setup_mod_plot_rates_ui_tests <- function(.env = parent.frame()) {
  testthat::local_mocked_bindings(
    "p_randomInt" = \(...) "X",
    .package = "shiny",
    .env = .env
  )

  mocks <- list(
    "mod_plot_rates_trend_ui" = mock("mod_plot_rates_trend"),
    "mod_plot_rates_funnel_ui" = mock("mod_plot_rates_funnel"),
    "mod_plot_rates_box_ui" = mock("mod_plot_rates_box")
  )

  do.call(testthat::local_mocked_bindings, c(mocks, .env = .env))

  mocks
}

server_mod_plot_rates_server_tests <- function(.env = parent.frame()) {
  mocks <- list(
    "mod_plot_rates_trend_server" = mock(),
    "mod_plot_rates_funnel_server" = mock(),
    "mod_plot_rates_box_server" = mock(),
    "get_golem_config" = mock("strategies_config"),
    "make_strategy_group_lookup" = mock("strategy_group_lookup"),
    "get_peers_lookup" = mock("peers_lookup", cycle = TRUE),
    "get_rates_data" = mock("rates"),
    "get_rates_trend_data" = mock("rates_trend"),
    "generate_rates_baseline_data" = mock("rates_baseline"),
    "uprime_calculations" = mock("uprime")
  )
  do.call(testthat::local_mocked_bindings, c(mocks, .env = .env))

  mocks
}

# nolint start
inputs_data_sample <- list(
  "rates" = tibble::tribble(
    ~fyear , ~provider  , ~strategy    , ~crude_rate , ~std_rate ,
    202223 , "a"        , "Strategy A" ,           1 ,         2 ,
    202223 , "b"        , "Strategy A" ,           3 ,         4 ,
    202223 , "national" , "Strategy A" ,           5 ,         6 ,
    202324 , "A"        , "Strategy A" ,           7 ,         8 ,
    202324 , "B"        , "Strategy A" ,           9 ,        10 ,
    202324 , "national" , "Strategy A" ,          10 ,        12 ,

    202223 , "a"        , "Strategy B" ,           2 ,         1 ,
    202223 , "b"        , "Strategy B" ,           4 ,         3 ,
    202223 , "national" , "Strategy B" ,           6 ,         5 ,
    202324 , "A"        , "Strategy B" ,           8 ,         7 ,
    202324 , "B"        , "Strategy B" ,          10 ,         9 ,
    202324 , "national" , "Strategy B" ,          12 ,        11
  )
)
# nolint end

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
      inputs_data = shiny::reactiveVal(inputs_data_sample),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
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
      inputs_data = shiny::reactiveVal(inputs_data_sample),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
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
      inputs_data = shiny::reactiveVal(inputs_data_sample),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
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
        selected_year
      )

      expect_called(mocks$mod_plot_rates_funnel_server, 1)
      expect_args(
        mocks$mod_plot_rates_funnel_server,
        1,
        "mod_plot_rates_funnel",
        rates_baseline_data,
        rates_funnel_calculations,
        y_axis_limits,
        funnel_x_title
      )

      expect_called(mocks$mod_plot_rates_box_server, 1)
      expect_args(
        mocks$mod_plot_rates_box_server,
        1,
        "mod_plot_rates_box",
        rates_baseline_data,
        y_axis_limits
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
      inputs_data = shiny::reactiveVal(inputs_data_sample),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
    ),
    {
      # assert
      expect_equal(peers_lookup(), "peers_lookup")

      expect_called(m, 1)
      expect_args(m, 1, "nhp")

      selected_geography("la")
      peers_lookup()
      expect_called(m, 2)
      expect_args(m, 2, "la")
    }
  )
})

test_that("rates_data", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      inputs_data = shiny::reactiveVal(list(rates = "sample_data")),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
    ),
    {
      actual <- rates_data()

      # assert
      expect_equal(actual, "rates")
      expect_called(mocks$get_rates_data, 1)
      expect_args(mocks$get_rates_data, 1, "sample_data", "Strategy A")
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
      inputs_data = shiny::reactiveVal(list(rates = "sample_data")),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
    ),
    {
      actual <- rates_trend_data()

      # assert
      expect_equal(actual, "rates_trend")
      expect_called(mocks$get_rates_trend_data, 1)
      expect_args(mocks$get_rates_trend_data, 1, "rates", "R00")
    }
  )
})

test_that("rates_baseline", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      inputs_data = shiny::reactiveVal(list(rates = "sample_data")),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
    ),
    {
      actual <- rates_baseline_data()

      # assert
      expect_equal(actual, "rates_baseline")
      expect_called(mocks$generate_rates_baseline_data, 1)
      expect_args(
        mocks$generate_rates_baseline_data,
        1,
        "rates",
        "R00",
        "peers_lookup",
        202324
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
      inputs_data = shiny::reactiveVal(list(rates = "sample_data")),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
    ),
    {
      actual <- rates_funnel_calculations()

      # assert
      expect_equal(actual, "uprime")
      expect_called(mocks$uprime_calculations, 1)
      expect_args(
        mocks$uprime_calculations,
        1,
        "rates_baseline"
      )
    }
  )
})

test_that("y_axis_limits (funnel values are max)", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  trends_df <- tibble::tibble(
    rate = 1:10
  )

  baseline_df <- tibble::tibble(
    denominator = c(1, 10, 15, 100),
    rate = c(50, 40, 30, 20)
  )

  uprime <- list(
    z_i = c(2, 10, 2, 2)
  )

  local_mocked_bindings(
    "get_rates_trend_data" = mock(trends_df),
    "generate_rates_baseline_data" = mock(baseline_df),
    "uprime_calculations" = mock(uprime),
  )

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      inputs_data = shiny::reactiveVal(list(rates = "sample_data")),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
    ),
    {
      actual <- y_axis_limits()

      # assert
      expect_equal(actual, c(0, 30))
    }
  )
})

test_that("y_axis_limits (trend values are max)", {
  # arrange
  mocks <- server_mod_plot_rates_server_tests()

  trends_df <- tibble::tibble(
    rate = 300
  )

  baseline_df <- tibble::tibble(
    denominator = c(1, 10, 15, 100),
    rate = c(50, 40, 30, 20)
  )

  uprime <- list(
    z_i = c(2, 10, 2, 2)
  )

  local_mocked_bindings(
    "get_rates_trend_data" = mock(trends_df),
    "generate_rates_baseline_data" = mock(baseline_df),
    "uprime_calculations" = mock(uprime),
  )

  # act
  shiny::testServer(
    mod_plot_rates_server,
    args = list(
      inputs_data = shiny::reactiveVal(list(rates = "sample_data")),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
    ),
    {
      actual <- y_axis_limits()

      # assert
      expect_equal(actual, c(0, 300))
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
      inputs_data = shiny::reactiveVal(list(rates = "sample_data")),
      selected_geography = shiny::reactiveVal("nhp"),
      selected_provider = shiny::reactiveVal("R00"),
      selected_strategy = shiny::reactiveVal("Strategy A"),
      selected_year = shiny::reactiveVal(202324)
    ),
    {
      # assert
      expect_equal(y_axis_title(), "y axis title")
      expect_equal(y_labels(), "y labels")
      expect_equal(funnel_x_title(), "funnel x title")
    }
  )
})
