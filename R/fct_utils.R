#' Convert a Financial Year to Character
#' @param year Integer. Expressed in the form `202526`. To be converted to the
#'     form `"2025/26"`.
enstring_fyear <- function(year) {
  yyyy <- stringr::str_sub(year, 1, 4)
  yy <- stringr::str_sub(year, -2)
  paste0(yyyy, "/", yy)
}
