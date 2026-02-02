#' Run the Shiny Application
#' @export
run_app <- function() {
  shiny::shinyOptions(cache = cachem::cache_disk(".cache"))

  shiny::shinyApp(
    ui = app_ui,
    server = app_server,
    enableBookmarking = "server"
  )
}
