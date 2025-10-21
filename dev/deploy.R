rsconnect::deployApp(
  appName = "tpma-explorer",
  appTitle = "TPMA explorer",
  server = "connect.strategyunitwm.nhs.uk",
  appId = 200,
  appFiles = c(
    "R/",
    "inst/",
    "NAMESPACE",
    "DESCRIPTION",
    "app.R"
  ),
  envVars = c(
    "AZ_CONTAINER_INPUTS",
    "AZ_STORAGE_EP"
  ),
  lint = FALSE,
  forceUpdate = TRUE
)
