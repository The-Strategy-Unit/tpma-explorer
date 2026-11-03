test_that("download_geo_data exits if path already exists", {
  # arrange
  m_dir_create <- mock()
  m__download_geo_data <- mock()

  local_mocked_bindings(
    "dir_exists" = \(...) TRUE,
    "dir_create" = m_dir_create,
    .package = "fs"
  )
  local_mocked_bindings("_download_geo_data" = m__download_geo_data)

  # act
  download_geo_data("nhp", "dev", FALSE)

  expect_called(m_dir_create, 0)
  expect_called(m__download_geo_data, 0)
})

test_that("download_geo_data continues if path already exists but redownload is TRUE", {
  # arrange
  m_dir_create <- mock()
  m__download_geo_data <- mock()

  local_mocked_bindings(
    "dir_exists" = \(...) TRUE,
    "dir_create" = m_dir_create,
    .package = "fs"
  )
  local_mocked_bindings(
    "_download_geo_data" = m__download_geo_data
  )

  # act
  download_geo_data("nhp", "dev", TRUE)

  expect_called(m_dir_create, 0)
  expect_called(m__download_geo_data, 1)
  expect_args(m__download_geo_data, 1, "nhp", "app_data/nhp", "dev")
})

test_that("download_geo_data creates path if it does not exist", {
  # arrange
  m_dir_create <- mock()
  m__download_geo_data <- mock()

  local_mocked_bindings(
    "dir_exists" = \(...) FALSE,
    "dir_create" = m_dir_create,
    .package = "fs"
  )
  local_mocked_bindings(
    "_download_geo_data" = m__download_geo_data
  )

  # act
  download_geo_data("nhp", "dev", TRUE)

  expect_called(m_dir_create, 1)
  expect_called(m__download_geo_data, 1)
  expect_args(m_dir_create, 1, "app_data/nhp", recursive = TRUE)
})

test_that("_download_geo_data calls _download_geo_data_file for each data type", {
  # arrange
  m_container <- mock("container")
  m_download_geo_data_file <- mock()
  local_mocked_bindings(
    "get_container" = m_container,
    .package = "azkit"
  )
  local_mocked_bindings(
    "_download_geo_data_file" = m_download_geo_data_file
  )

  # act
  `_download_geo_data`("nhp", "app_data/nhp", "dev")

  # assert
  expect_called(m_container, 1)
  expect_called(m_download_geo_data_file, 4)

  expect_args(
    m_download_geo_data_file,
    1,
    "age_sex",
    "app_data/nhp",
    "container",
    "dev/nhp"
  )
  expect_args(
    m_download_geo_data_file,
    2,
    "diagnoses",
    "app_data/nhp",
    "container",
    "dev/nhp"
  )
  expect_args(
    m_download_geo_data_file,
    3,
    "procedures",
    "app_data/nhp",
    "container",
    "dev/nhp"
  )
  expect_args(
    m_download_geo_data_file,
    4,
    "rates",
    "app_data/nhp",
    "container",
    "dev/nhp"
  )
})

test_that("_download_geo_data_file works", {
  # arrange
  mock_data <- data.frame(
    lad23cd = c("P1", "P2", "P3"),
    age = c(30, 40, 50),
    "strategy" = c("S1", "S2", NA_character_)
  )
  expected_data <- mock_data[1:2, ]
  names(expected_data)[[1]] <- "provider"

  m_read_azure_parquet <- mock(mock_data)
  m_write_parquet <- mock()

  local_mocked_bindings(
    "read_azure_parquet" = m_read_azure_parquet,
    .package = "azkit"
  )
  local_mocked_bindings(
    "write_parquet" = m_write_parquet,
    .package = "arrow"
  )

  # act
  actual <- `_download_geo_data_file`("data", "app_data/nhp", "container", "dev/nhp")

  # assert
  expect_equal(actual, "app_data/nhp/data.parquet")

  expect_called(m_read_azure_parquet, 1)
  expect_args(
    m_read_azure_parquet,
    1,
    "container",
    "dev/nhp/data.parquet"
  )
  expect_called(m_write_parquet, 1)
  expect_args(
    m_write_parquet,
    1,
    expected_data,
    "app_data/nhp/data.parquet"
  )
})

test_that("download_all_data works", {
  # arrange
  m_download_geo_data <- mock()
  local_mocked_bindings("download_geo_data" = m_download_geo_data)

  # act
  download_all_data("data_version", TRUE)

  # assert
  expect_called(m_download_geo_data, 3)
  expect_args(m_download_geo_data, 1, "provider", data_version = "data_version", redownload = TRUE)
  expect_args(m_download_geo_data, 2, "lad23cd", data_version = "data_version", redownload = TRUE)
  expect_args(m_download_geo_data, 3, "icb", data_version = "data_version", redownload = TRUE)
})
