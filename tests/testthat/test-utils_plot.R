library(mockery)
library(testthat)

test_that("isolate_provider_peers", {
  # arrange
  peers <- tibble::tribble(
    ~procode , ~peer ,
    "A"      , "B"   ,
    "A"      , "C"   ,
    "B"      , "A"   ,
    "B"      , "C"
  )
  expected <- c("B", "C")

  # act
  actual <- isolate_provider_peers("A", peers)

  # assert
  expect_equal(actual, expected)
})

test_that("generate_rates_baseline_data", {
  # arrange
  rates <- tibble::tribble(
    ~provider , ~strategy , ~fyear ,
    "A"       , "S1"      , 202223 ,
    "B"       , "S1"      , 202223 ,
    "C"       , "S1"      , 202223 ,
    "D"       , "S1"      , 202223 ,
    "A"       , "S1"      , 202324 ,
    "B"       , "S1"      , 202324 ,
    "C"       , "S1"      , 202324 ,
    "D"       , "S1"      , 202324 ,

    "A"       , "S2"      , 202223 ,
    "B"       , "S2"      , 202223 ,
    "C"       , "S2"      , 202223 ,
    "D"       , "S2"      , 202223 ,
    "A"       , "S2"      , 202324 ,
    "B"       , "S2"      , 202324 ,
    "C"       , "S2"      , 202324 ,
    "D"       , "S2"      , 202324 ,
  )
  provider <- "A"
  peers <- c("B", "C")
  strategy <- "S1"
  selected_year <- 202324

  expected <- tibble::tribble(
    ~provider , ~strategy , ~fyear , ~is_peer ,
    "B"       , "S1"      , 202324 , TRUE     ,
    "C"       , "S1"      , 202324 , TRUE     ,
    "A"       , "S1"      , 202324 , FALSE    ,
    "D"       , "S1"      , 202324 , NA
  )

  # act
  actual <- generate_rates_baseline_data(
    rates,
    provider,
    peers,
    strategy,
    selected_year
  )

  # assert
  expect_equal(actual, expected)
})

test_that("uprime_calculations", {
  # arrange
  df <- tibble::tribble(
    ~denominator , ~rate , ~national_rate ,
            1000 , 2.0   , 1.9            ,
            2000 , 1.5   , 1.9            ,
            1500 , 2.5   , 1.9            ,
            2500 , 1.8   , 1.9
  )

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
