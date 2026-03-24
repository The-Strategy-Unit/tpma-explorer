test_that("generate_rates_funnel_data", {
  # arrange
  # nolint start
  rates <- tibble::tribble(
    ~provider  , ~fyear , ~strategy    , ~std_rate , ~crude_rate ,
    "a"        , 202223 , "strategy_a" ,  1        , 0           ,
    "b"        , 202223 , "strategy_a" ,  2        , 0           ,
    "c"        , 202223 , "strategy_a" ,  3        , 0           ,
    "d"        , 202223 , "strategy_a" ,  4        , 0           ,
    "national" , 202223 , "strategy_a" ,  5        , 0           ,
    "a"        , 202324 , "strategy_a" ,  6        , 0           ,
    "b"        , 202324 , "strategy_a" ,  7        , 0           ,
    "c"        , 202324 , "strategy_a" ,  8        , 0           ,
    "d"        , 202324 , "strategy_a" ,  9        , 0           ,
    "national" , 202324 , "strategy_a" , 10        , 0           ,
    "a"        , 202223 , "strategy_B" , 11        , 0           ,
    "a"        , 202324 , "strategy_B" , 12        , 0
  )

  providers_lookup <- tibble::tribble(
    ~provider , ~label ,
    "a"       , "A"    ,
    "b"       , "B"    ,
    "c"       , "C"    ,
    "d"       , "D"
  )
  peers_lookup <- c("b", "c")

  m <- mock(rates)
  # nolint end
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  # nolint start
  expected <- tibble::tribble(
    ~provider , ~fyear , ~strategy    , ~rate , ~national_rate , ~label , ~is_peer ,
      "d"       , 202324 , "strategy_a" , 9    , 10             , "D"    , "other" ,
      "b"       , 202324 , "strategy_a" , 7    , 10             , "B"    , "peer"  ,
      "c"       , 202324 , "strategy_a" , 8    , 10             , "C"    , "peer"  ,
      "a"       , 202324 , "strategy_a" , 6    , 10             , "A"    , "self"
  )
  # nolint end

  # act
  actual <- generate_rates_funnel_data(
    "nhp",
    "a",
    "strategy_a",
    202324,
    providers_lookup,
    peers_lookup
  )

  # assert
  expect_equal(actual, expected)

  expect_called(m, 1)
  expect_args(m, 1, "nhp", "rates")
})

test_that("generate_rates_trend_data", {
  # arrange
  # nolint start
  rates <- tibble::tribble(
    ~provider  , ~fyear , ~strategy    , ~std_rate , ~crude_rate ,
    "a"        , 202223 , "strategy_a" ,  1        , 0           ,
    "b"        , 202223 , "strategy_a" ,  2        , 0           ,
    "c"        , 202223 , "strategy_a" ,  3        , 0           ,
    "d"        , 202223 , "strategy_a" ,  4        , 0           ,
    "national" , 202223 , "strategy_a" ,  5        , 0           ,
    "a"        , 202324 , "strategy_a" ,  6        , 0           ,
    "b"        , 202324 , "strategy_a" ,  7        , 0           ,
    "c"        , 202324 , "strategy_a" ,  8        , 0           ,
    "d"        , 202324 , "strategy_a" ,  9        , 0           ,
    "national" , 202324 , "strategy_a" , 10        , 0           ,
    "a"        , 202223 , "strategy_B" , 11        , 0           ,
    "a"        , 202324 , "strategy_B" , 12        , 0
  )

  providers_lookup <- tibble::tribble(
    ~provider , ~label ,
    "a"       , "A"    ,
    "b"       , "B"    ,
    "c"       , "C"    ,
    "d"       , "D"
  )
  peers_lookup <- c("b", "c")

  m <- mock(rates)
  # nolint end
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  # nolint start
  expected <- tibble::tribble(
    ~provider , ~fyear , ~strategy    , ~rate , ~is_peer ,
    "a"       , 202223 , "strategy_a" , 1    , "self"   ,
    "b"       , 202223 , "strategy_a" , 2    , "peer"   ,
    "c"       , 202223 , "strategy_a" , 3    , "peer"   ,
    "a"       , 202324 , "strategy_a" , 6    , "self"   ,
    "b"       , 202324 , "strategy_a" , 7    , "peer"   ,
    "c"       , 202324 , "strategy_a" , 8    , "peer"
  )
  # nolint end
  # act
  actual <- generate_rates_trend_data("nhp", "a", "strategy_a", peers_lookup)

  # assert
  expect_equal(actual, expected)

  expect_called(m, 1)
  expect_args(m, 1, "nhp", "rates")
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
