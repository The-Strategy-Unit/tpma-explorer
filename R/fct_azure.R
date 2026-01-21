#' Get Azure Container
#' @param tenant Character. Tenant ID.
#' @param app_id Character. App ID.
#' @param ep_uri Character. Endpoint URI.
#' @param container_name Character. The name of the blob/storage container that
#'     hosts files you want to read.
#' @return A blob_container/storage_container list.
#' @export
get_container <- function(
  ep_uri = Sys.getenv("AZ_STORAGE_EP"),
  container_name = Sys.getenv("AZ_CONTAINER_INPUTS")
) {
  # if the app_id variable is empty, we assume that this is running on an Azure
  # VM, and then we will use Managed Identities for authentication.

  token <- tryCatch(
    {
      AzureAuth::get_managed_token("https://storage.azure.com/")
    },
    error = function(...) {
      AzureAuth::get_azure_token(
        resource = "https://storage.azure.com",
        tenant = "common",
        app = "04b07795-8ddb-461a-bbee-02f9e1bf7b46",
        use_cache = TRUE # avoid browser-authorisation prompt
      )
    }
  )
  ep_uri |>
    AzureStor::blob_endpoint(token = token) |>
    AzureStor::storage_container(container_name)
}
