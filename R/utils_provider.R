get_provider_prompt <- function(geography) {
  unit <- switch(
    geography,
    "la" = "a local authority",
    "nhp" = "a provider trust",
    "icb" = "an ICB"
  )

  glue::glue("Select {unit}:")
}
