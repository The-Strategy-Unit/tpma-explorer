deploy <- function(type = c("dev", "prod")) {
  type <- match.arg(type)

  # prod details
  app_id <- 200
  app_name <- "tpma-explorer"
  app_title <- "TPMA explorer"

  if (type == "dev") {
    app_id <- 304
    app_name <- paste0(app_name, "-dev")
    app_title <- paste(app_title, "(dev)")
  }

  rsconnect::deployApp(
    appName = app_name,
    appTitle = app_title,
    server = "connect.strategyunitwm.nhs.uk",
    appId = app_id,
    appFiles = c(
      "R",
      "inst",
      "NAMESPACE",
      "DESCRIPTION",
      "app.R"
    ),
    lint = FALSE,
    forceUpdate = TRUE
  )
}

# Deploy development version between releases to
# https://connect.strategyunitwm.nhs.uk/tpma-explorer-dev/
deploy(type = "dev")

# Deploy on release to
# https://connect.strategyunitwm.nhs.uk/tpma-explorer/
deploy(type = "prod")
