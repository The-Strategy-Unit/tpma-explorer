#' Access Files in the Current App
#' @param ... Character vectors, specifying subdirectory and file(s)
#'     within your package. The default, none, returns the root of the app.
#' @noRd
app_sys <- function(...) {
  system.file(..., package = "tpma.explorer")
}
