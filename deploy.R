rsconnect::deployApp(
  appName = "tpma-explorer",
  appTitle = "Explore TPMA data",
  server = "connect.strategyunitwm.nhs.uk",
  appId = 200,
  appFiles = c(
    "R/",
    "inst/",
    "NAMESPACE",
    "DESCRIPTION",
    "app.R"
  ),
  lint = FALSE,
  forceUpdate = TRUE
)
