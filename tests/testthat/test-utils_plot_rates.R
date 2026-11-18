test_that("get_peers_lookup uses get_peers for nhp and la", {
  # arrange
  m <- mock(c("R1H", "RJE"), c("E06000003", "E08000018"))
  stub(get_peers_lookup, "get_peers", m)

  # act
  actual_nhp <- get_peers_lookup("nhp", "R0A")
  actual_la <- get_peers_lookup("la", "E06000001")

  # assert
  expect_equal(actual_nhp, c("R1H", "RJE"))
  expect_equal(actual_la, c("E06000003", "E08000018"))
  expect_called(m, 2)
  expect_args(m, 1, "nhp", "R0A")
  expect_args(m, 2, "la", "E06000001")
})

test_that("get_peers_lookup reads the csv for icb", {
  # arrange
  icb_peers_csv <- withr::local_tempfile(fileext = ".csv")
  tibble::tribble(
    ~procode , ~peer ,
    "QOX"    , "QOX" , # self listed as a peer, should be dropped
    "QOX"    , "QWE" ,
    "QOX"    , "QJG" ,
    "QWE"    , "QOX"   # a different provider's row, should be dropped
  ) |>
    readr::write_csv(icb_peers_csv)

  api_mock <- mock()
  stub(get_peers_lookup, "get_peers", api_mock)
  stub(get_peers_lookup, "app_sys", icb_peers_csv)

  # act
  actual <- get_peers_lookup("icb", "QOX")

  # assert
  expect_equal(actual, c("QWE", "QJG"))
  expect_called(api_mock, 0)
})

test_that("get_peers_lookup errors when the provider is missing", {
  expect_error(get_peers_lookup("other"))
})

test_that("get_peers returns the peers from the response", {
  # arrange
  mockery::stub(get_peers, "create_openplan_api_request", "req")
  mockery::stub(get_peers, "httr2::req_perform", "resp")
  mockery::stub(get_peers, "httr2::resp_body_json", c("RYY", "RZZ"))

  # act and assert
  expect_equal(get_peers("nhp", "RXX"), c("RYY", "RZZ"))
})

test_that("get_peers drops the provider itself from its peers", {
  # arrange
  mockery::stub(get_peers, "create_openplan_api_request", "req")
  mockery::stub(get_peers, "httr2::req_perform", "resp")
  mockery::stub(get_peers, "httr2::resp_body_json", c("RXX", "RYY", "RZZ"))

  # act and assert
  expect_equal(get_peers("nhp", "RXX"), c("RYY", "RZZ"))
})

test_that("get_peers propagates a 400 from the API", {
  # arrange
  mockery::stub(get_peers, "create_openplan_api_request", "req")
  mockery::stub(
    get_peers,
    "httr2::req_perform",
    function(...) rlang::abort("HTTP 400 Bad Request.", class = "httr2_http_400")
  )

  # act and assert
  expect_error(get_peers("nhp", ""), class = "httr2_http_400")
})

test_that("get_providers_lookup", {
  # arrange
  nhp <- list(
    "R00" = "ABC (R00)",
    "R01" = "DEF (R01)"
  )

  la <- list(
    "E00000001" = "LA A (E00000001)",
    "E00000002" = "LA B (E00000002)"
  )

  m <- mock(nhp, la)
  local_mocked_bindings(read_json_file = m, .package = "yyjsonr")
  local_mocked_bindings(app_sys = file.path)

  expected_nhp <- tibble::tibble(
    provider = c("R00", "R01"),
    provider_label = c("R00", "R01")
  )
  expected_la <- tibble::tibble(
    provider = c("E00000001", "E00000002"),
    provider_label = c("LA A", "LA B")
  )

  # act
  actual_nhp <- get_providers_lookup("nhp")
  actual_la <- get_providers_lookup("la")

  # assert
  expect_equal(actual_nhp, expected_nhp)
  expect_equal(actual_la, expected_la)

  expect_error(get_providers_lookup("other"))
})

test_that("get_rates_data", {
  # arrange

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

  # act
  actual_a <- get_rates_data(inputs_data_sample, "Strategy A")
  actual_b <- get_rates_data(inputs_data_sample, "Strategy B")

  # assert
  expect_equal(actual_a, expected_a)
  expect_equal(actual_b, expected_b)
})

test_that("get_rates_trend_data", {
  # arrange

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

  # act
  actual <- get_rates_trend_data(df, "a")

  # assert
  expect_equal(actual, expected)
})


test_that("y_axis_limits (funnel values are max)", {
  # arrange
  td <- tibble::tibble(
    rate = 1:10
  )

  bd <- tibble::tibble(
    denominator = c(1, 10, 15, 100),
    rate = c(50, 40, 30, 20)
  )

  fc <- list(
    z_i = c(2, 10, 2, 2)
  )

  # act
  actual <- get_rates_y_axis_limits(td, bd, fc)

  # assert
  expect_equal(actual, c(0, 30))
})

test_that("y_axis_limits (trend values are max)", {
  # arrange
  td <- tibble::tibble(
    rate = 300
  )

  bd <- tibble::tibble(
    denominator = c(1, 10, 15, 100),
    rate = c(50, 40, 30, 20)
  )

  fc <- list(
    z_i = c(2, 10, 2, 2)
  )

  # act
  actual <- get_rates_y_axis_limits(td, bd, fc)

  # assert
  expect_equal(actual, c(0, 300))
})
