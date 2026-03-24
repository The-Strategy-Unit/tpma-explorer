test_that("prepare_age_sex_data", {
  # arrange
  # nolint start
  age_sex_data <- tibble::tribble(
    ~age_group , ~sex , ~n , ~ provider, ~ strategy, ~ fyear,
    "0-4"      ,  "1" ,  5 , "R00"     , "a"      , 2 ,
    "5-9"      ,  "1" , 10 , "R00"     , "a"      , 2 ,
    "10-14"    ,  "1" , 20 , "R00"     , "a"      , 2 ,
    "0-4"      ,  "2" ,  7 , "R00"     , "a"      , 2 ,
    "5-9"      ,  "2" , 12 , "R00"     , "a"      , 2 ,
    "10-14"    ,  "2" , 22 , "R00"     , "a"      , 2 ,
    # rows that should be filtered out:
    "0-4"      ,  "1" , 10 , "R01"     , "a"      , 2 ,
    "5-9"      ,  "1" , 20 , "R00"     , "b"      , 2 ,
    "10-14"    ,  "1" , 40 , "R00"     , "a"      , 3
  )
  # nolint end

  m <- mock(age_sex_data)
  testthat::local_mocked_bindings(
    "get_arrow_dataset" = m
  )

  expected <- structure(
    list(
      sex = structure(
        c(1L, 1L, 1L, 2L, 2L, 2L),
        levels = c("Males", "Females"),
        class = "factor"
      ),
      age_group = structure(
        c(1L, 3L, 2L, 1L, 3L, 2L),
        levels = c("0-4", "10-14", "5-9"),
        class = "factor"
      ),
      n = c(-5, -10, -20, 7, 12, 22)
    ),
    row.names = c(NA, -6L),
    class = c("tbl_df", "tbl", "data.frame")
  )

  # act
  actual <- prepare_age_sex_data("provider", "R00", "a", 2)

  # assert
  expect_equal(actual, expected)
  expect_called(m, 1)
  expect_args(m, 1, "provider", "age_sex")
})

test_that("get_golem_config", {
  # arrange
  m <- mock("config")
  local_mocked_bindings(
    "get" = m,
    .package = "config"
  )

  local_mocked_bindings(
    "app_sys" = \(...) file.path(...)
  )

  # act
  actual <- get_golem_config("value", "config")

  # assert
  expect_equal(actual, "config")

  expect_called(m, 1)
  expect_args(
    m,
    1,
    value = "value",
    config = "config",
    file = "golem-config.yml",
    use_parent = TRUE
  )
})

test_that("make_strategy_group_lookup", {
  # arrange
  config <- list(
    "a" = list(
      strategy_subset = c("s1" = "S1", "s2" = "S2")
    ),
    b = list(
      strategy_subset = c("s3" = "S3")
    )
  )
  expected <- list(
    "s1" = "a",
    "s2" = "a",
    "s3" = "b"
  )

  # act
  actual <- make_strategy_group_lookup(config)

  # assert
  expect_equal(actual, expected)
})

test_that("md_file_to_html returns NULL if file doesn't exist", {
  # act
  actual <- md_file_to_html("nonexistent_file.md")

  # assert
  expect_null(actual)
})

test_that("md_file_to_html reads valid file", {
  # arrange
  local_mocked_bindings(
    "app_sys" = \(...) file.path(...),
    "file.exists" = \(...) TRUE
  )

  m1 <- mock("content")
  m2 <- mock("html")
  local_mocked_bindings(
    "mark_html" = m1,
    .package = "markdown"
  )
  local_mocked_bindings(
    "HTML" = m2,
    .package = "shiny"
  )

  # act
  actual <- md_file_to_html("file.md")

  # assert
  expect_equal(actual, "html")

  expect_called(m1, 1)
  expect_args(m1, 1, "file.md", output = FALSE, template = FALSE)

  expect_called(m2, 1)
  expect_args(m2, 1, "content")
})


test_that("md_string_to_html", {
  # arrange
  m1 <- mock("content")
  m2 <- mock("html")
  local_mocked_bindings(
    "mark_html" = m1,
    .package = "markdown"
  )
  local_mocked_bindings(
    "HTML" = m2,
    .package = "shiny"
  )

  # act
  actual <- md_string_to_html("text")

  # assert
  expect_equal(actual, "html")

  expect_called(m1, 1)
  expect_args(m1, 1, "text", output = FALSE, template = FALSE)

  expect_called(m2, 1)
  expect_args(m2, 1, "content")
})

test_that("get_arrow_dataset", {
  # arrange
  m <- mock("dataset", cycle = TRUE)
  local_mocked_bindings("app_sys" = file.path)
  local_mocked_bindings(
    "open_dataset" = m,
    .package = "arrow"
  )

  # act
  actual1 <- get_arrow_dataset("nhp", "dataset")
  actual2 <- get_arrow_dataset("la", "dataset")

  # assert
  expect_equal(actual1, "dataset")
  expect_equal(actual2, "dataset")
  expect_called(m, 2)
  expect_args(m, 1, "app/data/provider/dataset.parquet")
  expect_args(m, 2, "app/data/lad23cd/dataset.parquet")

  expect_equal(.arrow_dataset_cache[["provider::dataset"]], "dataset")
  expect_equal(.arrow_dataset_cache[["lad23cd::dataset"]], "dataset")
})
