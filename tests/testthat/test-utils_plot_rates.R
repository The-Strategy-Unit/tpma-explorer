library(mockery)
library(testthat)

test_that("get_peers_lookup", {
  # arrange
  m <- mock("peers", cycle = TRUE)
  local_mocked_bindings(
    "read_csv" = m,
    .package = "readr"
  )
  local_mocked_bindings("app_sys" = file.path)

  # act
  actual_nhp <- get_peers_lookup("nhp")
  actual_la <- get_peers_lookup("la")

  # assert
  expect_equal(actual_nhp, "peers")
  expect_equal(actual_la, "peers")

  expect_called(m, 2)
  expect_args(m, 1, "app/data/nhp-peers.csv", "col_types" = "c")
  expect_args(m, 2, "app/data/la-peers.csv", "col_types" = "c")

  expect_error(get_peers_lookup("other"))
})

test_that("get_rates_data", {
  # arrange
  # nolint start
  inputs_data_sample <- tibble::tribble(
    ~fyear , ~provider  , ~strategy    , ~crude_rate , ~std_rate ,
    202223 , "a"        , "Strategy A" ,           1 ,         2 ,
    202223 , "b"        , "Strategy A" ,           3 ,         4 ,
    202223 , "national" , "Strategy A" ,           5 ,         6 ,
    202324 , "a"        , "Strategy A" ,           7 ,         8 ,
    202324 , "b"        , "Strategy A" ,           9 ,        10 ,
    202324 , "national" , "Strategy A" ,          10 ,        12 ,
    202223 , "a"        , "Strategy B" ,           2 ,         1 ,
    202223 , "b"        , "Strategy B" ,           4 ,         3 ,
    202223 , "national" , "Strategy B" ,           6 ,         5 ,
    202324 , "a"        , "Strategy B" ,           8 ,         7 ,
    202324 , "b"        , "Strategy B" ,          10 ,         9 ,
    202324 , "national" , "Strategy B" ,          12 ,        11
  )

  expected_a <- tibble::tribble(
    ~fyear , ~provider , ~strategy    , ~rate , ~national_rate ,
    202223 , "a"       , "Strategy A" ,     2 ,              6 ,
    202223 , "b"       , "Strategy A" ,     4 ,              6 ,
    202324 , "a"       , "Strategy A" ,     8 ,             12 ,
    202324 , "b"       , "Strategy A" ,    10 ,             12
  )

  expected_b <- tibble::tribble(
    ~fyear , ~provider , ~strategy    , ~rate , ~national_rate ,
    202223 , "a"       , "Strategy B" ,     1 ,              5 ,
    202223 , "b"       , "Strategy B" ,     3 ,              5 ,
    202324 , "a"       , "Strategy B" ,     7 ,             11 ,
    202324 , "b"       , "Strategy B" ,     9 ,             11
  )
  # nolint end

  # act
  actual_a <- get_rates_data(inputs_data_sample, "Strategy A")
  actual_b <- get_rates_data(inputs_data_sample, "Strategy B")

  # assert
  expect_equal(actual_a, expected_a)
  expect_equal(actual_b, expected_b)
})

test_that("get_rates_trend_data", {
  # arrange
  # nolint start
  df <- tibble::tribble(
    ~fyear , ~provider , ~strategy    , ~rate , ~national_rate ,
    202223 , "a"       , "Strategy A" ,     2 ,              6 ,
    202223 , "b"       , "Strategy A" ,     4 ,              6 ,
    202324 , "a"       , "Strategy A" ,     8 ,             12 ,
    202324 , "b"       , "Strategy A" ,    10 ,             12
  )

  expected <- tibble::tribble(
    ~fyear , ~provider , ~strategy    , ~rate , ~national_rate ,
    202223 , "a"       , "Strategy A" ,     2 ,              6 ,
    202324 , "a"       , "Strategy A" ,     8 ,             12
  )
  # nolint end

  # act
  actual <- get_rates_trend_data(df, "a")

  # assert
  expect_equal(actual, expected)
})
