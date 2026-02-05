test_that("get_container uses get_azure_token when not in a managed environment", {
  # arrange
  m_get_managed_token <- \() stop("expected error")
  m_get_azure_token <- mock("token")
  m_blob_endpoint <- mock("ep")
  m_storage_container <- mock("container")

  stub(get_container, "AzureAuth::get_managed_token", m_get_managed_token)
  stub(get_container, "AzureAuth::get_azure_token", m_get_azure_token)
  stub(get_container, "AzureStor::blob_endpoint", m_blob_endpoint)
  stub(get_container, "AzureStor::storage_container", m_storage_container)

  # act
  actual <- get_container("ep_uri", "container_name")

  # assert
  expect_called(m_get_azure_token, 1)
  expect_args(
    m_get_azure_token,
    1,
    resource = "https://storage.azure.com",
    tenant = "common",
    app = "04b07795-8ddb-461a-bbee-02f9e1bf7b46",
    use_cache = TRUE
  )

  expect_called(m_blob_endpoint, 1)
  expect_args(m_blob_endpoint, 1, "ep_uri", token = "token")

  expect_called(m_storage_container, 1)
  expect_args(m_storage_container, 1, "ep", "container_name")

  expect_equal(actual, "container")
})

test_that("get_container uses get_managed_token when in a managed environment", {
  # arrange
  m_get_managed_token <- mock("token")
  m_get_azure_token <- mock()
  m_blob_endpoint <- mock("ep")
  m_storage_container <- mock("container")

  stub(get_container, "AzureAuth::get_managed_token", m_get_managed_token)
  stub(get_container, "AzureAuth::get_azure_token", m_get_azure_token)
  stub(get_container, "AzureStor::blob_endpoint", m_blob_endpoint)
  stub(get_container, "AzureStor::storage_container", m_storage_container)

  # act
  actual <- get_container("ep_uri", "container_name")

  # assert
  expect_called(m_get_managed_token, 1)
  expect_args(m_get_managed_token, 1, "https://storage.azure.com/")

  expect_called(m_get_azure_token, 0)

  expect_called(m_blob_endpoint, 1)
  expect_args(m_blob_endpoint, 1, "ep_uri", token = "token")

  expect_called(m_storage_container, 1)
  expect_args(m_storage_container, 1, "ep", "container_name")

  expect_equal(actual, "container")
})

test_that("get_all_geo_data works for nhp geography", {
  # arrange
  data_types <- c(
    "age_sex",
    "diagnoses",
    "procedures",
    "rates"
  )

  mock_age_sex <- data.frame(provider = c("P1", "P2"), age = c(30, 40))
  mock_diagnoses <- data.frame(
    provider = c("P1", "P2"),
    diagnosis = c("D1", "D2")
  )
  mock_procedures <- data.frame(
    provider = c("P1", "P2"),
    procedure = c("PR1", "PR2")
  )
  mock_rates <- data.frame(provider = c("P1", "P2"), rate = c(0.1, 0.2))

  m_get_container <- mock("container")
  m_read_azure_parquet <- mock(
    mock_age_sex,
    mock_diagnoses,
    mock_procedures,
    mock_rates
  )

  withr::local_envvar("DATA_VERSION" = "dev")

  local_mocked_bindings("get_container" = m_get_container)
  local_mocked_bindings(
    "read_azure_parquet" = m_read_azure_parquet,
    .package = "azkit"
  )

  # act
  result <- get_all_geo_data("nhp")

  # assert
  expect_type(result, "list")
  expect_length(result, 4)
  expect_named(result, data_types)

  # verify get_container was called correctly
  expect_called(m_get_container, 1)
  expect_args(m_get_container, 1)

  # verify read_azure_parquet was called 4 times with correct arguments
  expect_called(m_read_azure_parquet, 4)

  for (i in seq_along(data_types)) {
    expect_args(
      m_read_azure_parquet,
      i,
      "container",
      data_types[i],
      "dev/provider"
    )
  }

  # verify the data is returned correctly
  expect_equal(result$age_sex, mock_age_sex)
  expect_equal(result$diagnoses, mock_diagnoses)
  expect_equal(result$procedures, mock_procedures)
  expect_equal(result$rates, mock_rates)
})

test_that("get_all_geo_data works for la geography and renames lad23cd to provider", {
  # arrange
  data_types <- c(
    "age_sex",
    "diagnoses",
    "procedures",
    "rates"
  )

  mock_age_sex <- data.frame(lad23cd = c("P1", "P2"), age = c(30, 40))
  mock_diagnoses <- data.frame(
    lad23cd = c("P1", "P2"),
    diagnosis = c("D1", "D2")
  )
  mock_procedures <- data.frame(
    lad23cd = c("P1", "P2"),
    procedure = c("PR1", "PR2")
  )
  mock_rates <- data.frame(lad23cd = c("P1", "P2"), rate = c(0.1, 0.2))

  expected_age_sex <- dplyr::rename(mock_age_sex, provider = lad23cd)
  expected_diagnoses <- dplyr::rename(mock_diagnoses, provider = lad23cd)
  expected_procedures <- dplyr::rename(mock_procedures, provider = lad23cd)
  expected_rates <- dplyr::rename(mock_rates, provider = lad23cd)

  m_get_container <- mock("container")
  m_read_azure_parquet <- mock(
    mock_age_sex,
    mock_diagnoses,
    mock_procedures,
    mock_rates
  )

  withr::local_envvar("DATA_VERSION" = "dev")

  local_mocked_bindings("get_container" = m_get_container)
  local_mocked_bindings(
    "read_azure_parquet" = m_read_azure_parquet,
    .package = "azkit"
  )

  # act
  result <- get_all_geo_data("la")

  # assert
  expect_type(result, "list")
  expect_length(result, 4)
  expect_named(result, data_types)

  # verify get_container was called correctly
  expect_called(m_get_container, 1)
  expect_args(m_get_container, 1)

  # verify read_azure_parquet was called 4 times with correct arguments
  expect_called(m_read_azure_parquet, 4)

  for (i in seq_along(data_types)) {
    expect_args(
      m_read_azure_parquet,
      i,
      "container",
      data_types[i],
      "dev/lad23cd"
    )
  }

  # verify lad23cd column was renamed to provider
  expect_equal(result$age_sex, expected_age_sex)
  expect_equal(result$diagnoses, expected_diagnoses)
  expect_equal(result$procedures, expected_procedures)
  expect_equal(result$rates, expected_rates)
})

test_that("get_all_geo_data throws error for unknown geography", {
  # arrange
  local_mocked_bindings("get_container" = mock())

  # act and assert
  expect_error(
    get_all_geo_data("unknown_geography"),
    "Unknown geography"
  )
})
