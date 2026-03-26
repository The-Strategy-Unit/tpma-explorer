test_that("entable_encounters (diagnoses)", {
  skip_if(interactive(), "This test will fail in interactive mode")

  # arrange
  withr::local_seed(1)
  df <- tibble::tribble(
    ~diagnosis_description, ~n, ~pcnt,
    "A", 100, 0.5,
    "B", 50, 0.25,
    "C", 25, 0.125,
    "Other", 25, 0.125
  )

  # act
  actual <- entable_encounters(df)

  # assert
  expect_snapshot(actual)
})

test_that("entable_encounters (procedures)", {
  skip_if(interactive(), "This test will fail in interactive mode")

  # arrange
  withr::local_seed(1)
  df <- tibble::tribble(
    ~procedures_description, ~n, ~pcnt,
    "A", 100, 0.5,
    "B", 50, 0.25,
    "C", 25, 0.125,
    "Other", 25, 0.125
  )

  # act
  actual <- entable_encounters(df)

  # assert
  expect_snapshot(actual)
})
