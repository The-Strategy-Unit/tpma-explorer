# Generate a lookup of care-shift TPMA groupings

# Read lookups ----

# Adjust paths as needed

# Lookup provided via Sharepoint
# https://github.com/The-Strategy-Unit/tpma-explorer/issues/130#issuecomment-3915631889
cat_path <- r"{Groupings for care shift(All TPMAs).csv}"
cs_path <- r"{Groupings for care shift(Care shift sub set).csv}"

# Some of the TPMA names in the provided lookup are out of date. We can use the
# TPMA lookup from Project Information to match in the correct names:
# https://connect.strategyunitwm.nhs.uk/nhp/project_information/user_guide/mitigators_lookup.html
pi_path <- r"{data.csv}"

# Prepare combined lookup ----

cat_lookup_provided <- cat_path |>
  readr::read_csv(col_types = "c") |>
  dplyr::mutate(
    code = Code,
    category_name = `Sub category`,
    .keep = "none"
  )

cs_tpma_codes <- cs_path |>
  readr::read_csv(col_select = "Code", col_types = "c") |>
  dplyr::pull()

pi_lookup <- readr::read_csv(pi_path, col_types = "c") |>
  dplyr::filter(To == "-") |> # filter out deprecated TPMAs
  dplyr::select(code = Code, strategy = Variable)

cs_lookup <- pi_lookup |>
  dplyr::full_join(cat_lookup_provided, by = "code") |>
  dplyr::mutate(
    category_name = dplyr::if_else(
      is.na(category_name),
      "Other",
      category_name
    ),
    category = stringr::str_to_snake(category_name),
    is_care_shift = dplyr::if_else(code %in% cs_tpma_codes, TRUE, FALSE)
  ) |>
  dplyr::select(strategy, category, category_name, is_care_shift)

readr::write_csv(cs_lookup, "inst/app/data/mitigator-categories.csv")
