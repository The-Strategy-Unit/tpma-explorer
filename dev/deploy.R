rsconnect::deployApp(
  appName = "cpma-explorer",
  appTitle = "CPMA explorer",
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
