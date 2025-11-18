#' Prepare Age-Sex Data
#' @param age_sex_data A data.frame. Read from Azure. Counts for each strategy
#'     split by provider, year, age group and sex.
#' @return A data.frame.
#' @export
prepare_age_sex_data <- function(age_sex_data) {
  age_fct <- age_sex_data[["age_group"]] |> unique() |> sort()
  age_sex_data |>
    dplyr::mutate(
      age_group = factor(
        .data[["age_group"]],
        levels = .env[["age_fct"]]
      ),
      dplyr::across(
        "sex",
        \(value) {
          forcats::fct_recode(
            as.character(value),
            "Males" = "1",
            "Females" = "2"
          )
        }
      ),
      dplyr::across(
        "n",
        \(value) {
          dplyr::if_else(
            .data[["sex"]] == "Males",
            value * -1, # negative, to appear on the left of the pyramid
            value # positive, to appear on the right of the pyramid
          )
        }
      )
    )
}
