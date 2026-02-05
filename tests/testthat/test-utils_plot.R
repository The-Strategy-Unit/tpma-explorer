test_that("isolate_provider_peers", {
  # arrange
  # nolint start
  peers <- tibble::tribble(
    ~procode , ~peer ,
    "A"      , "B"   ,
    "A"      , "C"   ,
    "B"      , "A"   ,
    "B"      , "C"
  )
  # nolint end
  expected <- c("B", "C")

  # act
  actual <- isolate_provider_peers("A", peers)

  # assert
  expect_equal(actual, expected)
})

test_that("generate_rates_baseline_data", {
  # arrange
  m <- mock(c("B", "C"))
  local_mocked_bindings("isolate_provider_peers" = m)

  # nolint start
  rates <- tibble::tribble(
    ~provider , ~fyear ,
    "A"       , 202223 ,
    "B"       , 202223 ,
    "C"       , 202223 ,
    "D"       , 202223 ,
    "A"       , 202324 ,
    "B"       , 202324 ,
    "C"       , 202324 ,
    "D"       , 202324 ,
  )
  provider <- "A"
  selected_year <- 202324

  expected <- tibble::tribble(
    ~provider , ~fyear , ~is_peer ,
    "B"       , 202324 , TRUE     ,
    "C"       , 202324 , TRUE     ,
    "A"       , 202324 , FALSE    ,
    "D"       , 202324 , NA
  )
  # nolint end

  # act
  actual <- generate_rates_baseline_data(
    rates,
    provider,
    "peers_lookup",
    selected_year
  )

  # assert
  expect_equal(actual, expected)

  expect_called(m, 1)
  expect_args(m, 1, "A", "peers_lookup")
})

test_that("uprime_calculations", {
  # arrange
  # nolint start
  df <- tibble::tribble(
    ~denominator , ~rate , ~national_rate ,
            1000 , 2.0   , 1.9            ,
            2000 , 1.5   , 1.9            ,
            1500 , 2.5   , 1.9            ,
            2500 , 1.8   , 1.9
  )
  # nolint end

  # act
  actual <- uprime_calculations(df)

  # assert
  expect_equal(actual$cl, 1.9)
  expect_equal(
    actual$z_i,
    c(0.1444332, 1.0613633, -0.8170378, -0.2283690),
    tolerance = 1e-6
  )

  expect_equal(
    actual$lcl3(c(1000, 1500)),
    c(-0.1770841, 0.2040680),
    tolerance = 1e-6
  )
  expect_equal(
    actual$lcl2(c(1000, 1500)),
    c(0.5152773, 0.7693786),
    tolerance = 1e-6
  )
  expect_equal(
    actual$ucl2(c(1000, 1500)),
    c(3.284723, 3.030621),
    tolerance = 1e-6
  )
  expect_equal(
    actual$ucl3(c(1000, 1500)),
    c(3.977084, 3.595932),
    tolerance = 1e-6
  )
})
