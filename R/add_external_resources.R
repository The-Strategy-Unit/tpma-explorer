#' Add External Resources to the Application
#' This function is internally used to add external resources inside the Shiny
#' application.
add_external_resources <- function() {
  shiny::addResourcePath(
    "www",
    app_sys("app/www")
  )
  shiny::singleton(
    shiny::tags$head()
  )
}

#' Access Files in the Current App
#' @param ... character vectors, specifying subdirectory and file(s)
#'     within your package. The default, none, returns the root of the app.
#' @noRd
#' @noRd
app_sys <- function(...) {
  system.file(..., package = "cpma-explorer")
}
