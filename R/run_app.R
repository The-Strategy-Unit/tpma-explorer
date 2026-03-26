#' Run the Shiny Application
#' @export
run_app <- function() {
  download_all_data()

  shiny::shinyApp(
    ui = app_ui,
    server = app_server,
    enableBookmarking = "server"
  )
}
