test_that("mod_select_geography", {
  # arrange
  mocks <- setup_app_server_tests()

  # act
  shiny::testServer(
    app_server,
    {
      # assert
      expect_equal(selected_geography(), "nhp")
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
      expect_equal(selected_provider(), "ABC")
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
      expect_equal(selected_strategy(), "strategy")
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
      withr::local_envvar("BASELINE_YEAR" = NULL)
      expect_equal(selected_year(), 202324)
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
    }
  )
})

test_that("sidebar accordion opens", {
  # arrange
  mocks <- setup_app_server_tests()

  m <- mock()
  local_mocked_bindings(accordion_panel_open = m, .package = "bslib")
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

test_that("sidebar opens when Visualisations tab is selected", {
  # arrange
  mocks <- setup_app_server_tests()
  m <- mock()
  local_mocked_bindings(toggle_sidebar = m, .package = "bslib")

  shiny::testServer(
    app_server,
    {
      # act
      session$setInputs(page_navbar = "Visualisations")
      session$flushReact()

      # assert
      expect_called(m, 1)
      expect_args(m, 1, "sidebar", open = TRUE)
    }
  )
})

test_that("sidebar closes when a non-Visualisations tab is selected", {
  # arrange
  mocks <- setup_app_server_tests()
  m <- mock()
  local_mocked_bindings(toggle_sidebar = m, .package = "bslib")

  shiny::testServer(
    app_server,
    {
      # act
      session$setInputs(page_navbar = "Information")
      session$flushReact()

      # assert
      expect_called(m, 1)
      expect_args(m, 1, "sidebar", open = FALSE)
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
        selected_geography,
        selected_provider,
        selected_strategy,
        selected_year,
        16
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
        selected_geography,
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
        selected_geography,
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
        selected_geography,
        selected_provider,
        selected_strategy,
        selected_year,
        16
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
