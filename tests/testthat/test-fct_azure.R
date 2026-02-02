library(mockery)

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
