library(mockery)
library(testthat)

test_that("mod_select_geography", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_called(mocks$mod_select_geography_server, 1)
      expect_args(mocks$mod_select_geography_server, 1, "mod_select_geography")
    }
  )
})

test_that("mod_select_provider", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_called(mocks$mod_select_provider_server, 1)
      expect_args(
        mocks$mod_select_provider_server,
        1,
        "mod_select_provider",
        selected_geography
      )
    }
  )
})

test_that("mod_select_strategy", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_called(mocks$mod_select_strategy_server, 1)
      expect_args(
        mocks$mod_select_strategy_server,
        1,
        "mod_select_strategy"
      )
    }
  )
})

test_that("selected_year (env var not set)", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      withr::local_envvar("BASELINE_YEAR" = "")
      expect_equal(selected_year(), 202324)
      expect_called(mocks$get_all_geo_data, 1)
      expect_args(mocks$get_all_geo_data, 1, "nhp")
    }
  )
})


test_that("selected_year (env var set)", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      withr::local_envvar("BASELINE_YEAR" = "3")
      expect_equal(selected_year(), 3)
      expect_called(mocks$get_all_geo_data, 0)
    }
  )
})

test_that("inputs_data", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      withr::local_envvar("BASELINE_YEAR" = "")
      expect_equal(inputs_data(), inputs_data_sample)
      expect_called(mocks$get_all_geo_data, 1)
      expect_args(mocks$get_all_geo_data, 1, "nhp")

      # test caching - not changing geography, so shouldn't call again
      inputs_data()
      expect_called(mocks$get_all_geo_data, 1)

      # test caching - changing geography, so should call again
      selected_geography("la")
      inputs_data()
      expect_called(mocks$get_all_geo_data, 2)
      expect_args(mocks$get_all_geo_data, 2, "la")

      # test caching - changing geography back, so shouldn't call again
      selected_geography("nhp")
      inputs_data()
      expect_called(mocks$get_all_geo_data, 2)
    }
  )
})

test_that("sidebar accordion opens", {
  # arrange
  mocks <- setup_app_server_tests()

  m <- mock()
  mockery::stub(app_server, "bslib::accordion_panel_open", m)
  # act

  shiny::testServer(
    app_server,
    {
      session$flushReact() # trigger observer
      expect_called(m, 1)
      expect_args(m, 1, id = "sidebar_accordion", values = TRUE)
    }
  )
})

test_that("mod_show_strategy_text_server", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_called(mocks$mod_show_strategy_text_server, 1)
      expect_args(
        mocks$mod_show_strategy_text_server,
        1,
        "mod_show_strategy_text",
        selected_strategy
      )
    }
  )
})

test_that("mod_plot_rates_server", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_called(mocks$mod_plot_rates_server, 1)
      expect_args(
        mocks$mod_plot_rates_server,
        1,
        "mod_plot_rates",
        inputs_data,
        selected_geography,
        selected_provider,
        selected_strategy,
        selected_year
      )
    }
  )
})

test_that("mod_table_procedures_server", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_called(mocks$mod_table_procedures_server, 1)
      expect_args(
        mocks$mod_table_procedures_server,
        1,
        "mod_table_procedures",
        inputs_data,
        selected_provider,
        selected_strategy,
        selected_year
      )
    }
  )
})

test_that("mod_table_diagnoses_server", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_called(mocks$mod_table_diagnoses_server, 1)
      expect_args(
        mocks$mod_table_diagnoses_server,
        1,
        "mod_table_diagnoses",
        inputs_data,
        selected_provider,
        selected_strategy,
        selected_year
      )
    }
  )
})

test_that("mod_plot_age_sex_pyramid_server", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_called(mocks$mod_plot_age_sex_pyramid_server, 1)
      expect_args(
        mocks$mod_plot_age_sex_pyramid_server,
        1,
        "mod_plot_age_sex_pyramid",
        inputs_data,
        selected_provider,
        selected_strategy,
        selected_year
      )
    }
  )
})

test_that("mod_plot_nee_server", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_called(mocks$mod_plot_nee_server, 1)
      expect_args(
        mocks$mod_plot_nee_server,
        1,
        "mod_plot_nee",
        selected_strategy
      )
    }
  )
})
