#' Run the Shiny Application
#' @export
run_app <- function() {
  shiny::addResourcePath(
    "www",
    system.file("app/www", package = "tpma.explorer")
  )

  download_all_data()

  shiny::shinyApp(
    ui = app_ui,
    server = app_server,
    enableBookmarking = "server"
  )
}
