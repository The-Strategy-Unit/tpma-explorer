# Take existing, full json lookup and filter for just the set of trusts for
# which we have rates data. Assumes existing lookup is the full trusts list.

devtools::load_all(".")
trusts_data <- get_all_geo_data("nhp")

trusts_with_data <- trusts_data |>
  purrr::pluck("rates") |>
  dplyr::filter_out(provider == "national") |>
  dplyr::pull(provider) |>
  unique() |>
  sort()

trusts_lookup_path <- "inst/app/data/nhp-datasets.json"
trusts_lookup <- jsonlite::read_json(trusts_lookup_path)

trusts_lookup_filtered <-
  trusts_lookup[names(trusts_lookup) %in% trusts_with_data]

stopifnot(length(trusts_lookup) > length(trusts_lookup_filtered))

jsonlite::write_json(
  trusts_lookup_filtered,
  trusts_lookup_path,
  auto_unbox = TRUE,
  pretty = TRUE
)

jsonlite::read_json(trusts_lookup_path)
