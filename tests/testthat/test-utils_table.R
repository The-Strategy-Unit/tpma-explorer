# Tests for prepare_procedures_data ----

test_that("prepare_procedures_data returns NULL when no data matches filter", {
  # arrange
  procedures_data <- data.frame(
    provider = c("ABC", "DEF"),
    strategy = c("strategy1", "strategy2"),
    fyear = c(202324, 202324),
    procedure_code = c("P1", "P2"),
    n = c(100, 200),
    pcnt = c(0.5, 0.5),
    total = c(200, 400),
    rn = c(1, 1)
  )

  m <- mock(procedures_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  procedures_lookup <- data.frame(
    code = c("P1", "P2"),
    description = c("Procedure 1", "Procedure 2")
  )

  # act
  result <- prepare_procedures_data(
    procedures_lookup,
    geography = "nhp",
    provider = "XYZ",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_null(result)

  expect_called(m, 1)
  expect_args(m, 1, "nhp", "procedures")
})

test_that("prepare_procedures_data filters and joins data correctly", {
  # arrange
  procedures_data <- data.frame(
    provider = c("RCF", "RCF", "ABC"),
    strategy = c("strategy1", "strategy1", "strategy1"),
    fyear = c(202324, 202324, 202324),
    procedure_code = c("P1", "P2", "P3"),
    n = c(100, 200, 50),
    pcnt = c(0.4, 0.6, 0.5),
    total = c(400, 400, 400),
    rn = c(1, 2, 3)
  )

  m <- mock(procedures_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  procedures_lookup <- data.frame(
    code = c("P1", "P2", "P3"),
    description = c("Procedure 1", "Procedure 2", "Procedure 3")
  )

  # act
  result <- prepare_procedures_data(
    procedures_lookup,
    geography = "nhp",
    provider = "RCF",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_equal(nrow(result), 2)
  expect_equal(colnames(result), c("procedure_description", "n", "pcnt"))
  expect_equal(result$procedure_description, c("Procedure 1", "Procedure 2"))
  expect_equal(result$n, c(100, 200))
  expect_equal(result$pcnt, c(0.4, 0.6))
})

test_that("prepare_procedures_data handles unknown procedure codes", {
  # arrange
  procedures_data <- data.frame(
    provider = c("RCF", "RCF"),
    strategy = c("strategy1", "strategy1"),
    fyear = c(202324, 202324),
    procedure_code = c("P1", "UNKNOWN"),
    n = c(100, 50),
    pcnt = c(0.6, 0.4),
    total = c(400, 400),
    rn = c(1, 2)
  )

  m <- mock(procedures_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  procedures_lookup <- data.frame(
    code = c("P1"),
    description = c("Procedure 1")
  )

  # act
  result <- prepare_procedures_data(
    procedures_lookup,
    geography = "nhp",
    provider = "RCF",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_equal(nrow(result), 2)
  expect_equal(
    result$procedure_description,
    c("Procedure 1", "Unknown/Invalid Procedure Code")
  )
})

test_that("prepare_procedures_data adds 'Other' row when pcnt_total < 1", {
  # arrange
  procedures_data <- data.frame(
    provider = c("RCF", "RCF"),
    strategy = c("strategy1", "strategy1"),
    fyear = c(202324, 202324),
    procedure_code = c("P1", "P2"),
    n = c(100, 50),
    pcnt = c(0.4, 0.2),
    total = c(400, 400),
    rn = c(1, 2)
  )

  m <- mock(procedures_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  procedures_lookup <- data.frame(
    code = c("P1", "P2"),
    description = c("Procedure 1", "Procedure 2")
  )

  # act
  result <- prepare_procedures_data(
    procedures_lookup,
    geography = "nhp",
    provider = "RCF",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_equal(nrow(result), 3)
  expect_equal(
    result$procedure_description,
    c("Procedure 1", "Procedure 2", "Other")
  )
  expect_equal(result$pcnt[3], 0.4)
  expect_equal(result$n[3], 150 * 0.4 / 0.6)
})

test_that("prepare_procedures_data does not add 'Other' row when pcnt_total = 1", {
  # arrange
  procedures_data <- data.frame(
    provider = c("RCF", "RCF"),
    strategy = c("strategy1", "strategy1"),
    fyear = c(202324, 202324),
    procedure_code = c("P1", "P2"),
    n = c(100, 50),
    pcnt = c(0.6, 0.4),
    total = c(400, 400),
    rn = c(1, 2)
  )

  m <- mock(procedures_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  procedures_lookup <- data.frame(
    code = c("P1", "P2"),
    description = c("Procedure 1", "Procedure 2")
  )

  # act
  result <- prepare_procedures_data(
    procedures_lookup,
    geography = "nhp",
    provider = "RCF",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_equal(nrow(result), 2)
  expect_false("Other" %in% result$procedure_description)
})

# Tests for prepare_diagnoses_data ----

test_that("prepare_diagnoses_data returns NULL when no data matches filter", {
  # arrange
  diagnoses_data <- data.frame(
    provider = c("ABC", "DEF"),
    strategy = c("strategy1", "strategy2"),
    fyear = c(202324, 202324),
    diagnosis = c("D1", "D2"),
    n = c(100, 200),
    pcnt = c(0.5, 0.5),
    total = c(200, 400),
    rn = c(1, 1)
  )

  m <- mock(diagnoses_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  diagnoses_lookup <- data.frame(
    diagnosis_code = c("D1", "D2"),
    diagnosis_description = c("Diagnosis 1", "Diagnosis 2")
  )

  # act
  result <- prepare_diagnoses_data(
    diagnoses_lookup,
    geography = "nhp",
    provider = "XYZ",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_null(result)

  expect_called(m, 1)
  expect_args(m, 1, "nhp", "diagnoses")
})

test_that("prepare_diagnoses_data filters and joins data correctly", {
  # arrange
  diagnoses_data <- data.frame(
    provider = c("RCF", "RCF", "ABC"),
    strategy = c("strategy1", "strategy1", "strategy1"),
    fyear = c(202324, 202324, 202324),
    diagnosis = c("D1", "D2", "D3"),
    n = c(100, 200, 50),
    pcnt = c(0.4, 0.6, 0.5),
    total = c(200, 400, 500),
    rn = c(1, 1, 1)
  )

  m <- mock(diagnoses_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  diagnoses_lookup <- data.frame(
    diagnosis_code = c("D1", "D2", "D3"),
    diagnosis_description = c("Diagnosis 1", "Diagnosis 2", "Diagnosis 3")
  )

  # act
  result <- prepare_diagnoses_data(
    diagnoses_lookup,
    geography = "nhp",
    provider = "RCF",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_equal(nrow(result), 2)
  expect_equal(colnames(result), c("diagnosis_description", "n", "pcnt"))
  expect_equal(result$diagnosis_description, c("Diagnosis 1", "Diagnosis 2"))
  expect_equal(result$n, c(100, 200))
  expect_equal(result$pcnt, c(0.4, 0.6))
})

test_that("prepare_diagnoses_data handles unknown diagnosis codes", {
  # arrange
  diagnoses_data <- data.frame(
    provider = c("RCF", "RCF"),
    strategy = c("strategy1", "strategy1"),
    fyear = c(202324, 202324),
    diagnosis = c("D1", "UNKNOWN"),
    n = c(100, 50),
    pcnt = c(0.6, 0.4),
    total = c(200, 400),
    rn = c(1, 1)
  )

  m <- mock(diagnoses_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  diagnoses_lookup <- data.frame(
    diagnosis_code = c("D1"),
    diagnosis_description = c("Diagnosis 1")
  )

  # act
  result <- prepare_diagnoses_data(
    diagnoses_lookup,
    geography = "nhp",
    provider = "RCF",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_equal(nrow(result), 2)
  expect_equal(
    result$diagnosis_description,
    c("Diagnosis 1", "Unknown/Invalid Diagnosis Code")
  )
})

test_that("prepare_diagnoses_data adds 'Other' row when pcnt_total < 1", {
  # arrange
  diagnoses_data <- data.frame(
    provider = c("RCF", "RCF"),
    strategy = c("strategy1", "strategy1"),
    fyear = c(202324, 202324),
    diagnosis = c("D1", "D2"),
    n = c(100, 50),
    pcnt = c(0.4, 0.2),
    total = c(200, 400),
    rn = c(1, 1)
  )

  m <- mock(diagnoses_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  diagnoses_lookup <- data.frame(
    diagnosis_code = c("D1", "D2"),
    diagnosis_description = c("Diagnosis 1", "Diagnosis 2")
  )

  # act
  result <- prepare_diagnoses_data(
    diagnoses_lookup,
    geography = "nhp",
    provider = "RCF",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_equal(nrow(result), 3)
  expect_equal(
    result$diagnosis_description,
    c("Diagnosis 1", "Diagnosis 2", "Other")
  )
  expect_equal(result$pcnt[3], 0.4)
  expect_equal(result$n[3], 150 * 0.4 / 0.6)
})

test_that("prepare_diagnoses_data does not add 'Other' row when pcnt_total = 1", {
  # arrange
  diagnoses_data <- data.frame(
    provider = c("RCF", "RCF"),
    strategy = c("strategy1", "strategy1"),
    fyear = c(202324, 202324),
    diagnosis = c("D1", "D2"),
    n = c(100, 50),
    pcnt = c(0.6, 0.4),
    total = c(200, 400),
    rn = c(1, 1)
  )

  m <- mock(diagnoses_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  diagnoses_lookup <- data.frame(
    diagnosis_code = c("D1", "D2"),
    diagnosis_description = c("Diagnosis 1", "Diagnosis 2")
  )

  # act
  result <- prepare_diagnoses_data(
    diagnoses_lookup,
    geography = "nhp",
    provider = "RCF",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_equal(nrow(result), 2)
  expect_false("Other" %in% result$diagnosis_description)
})

test_that("prepare_diagnoses_data filters by correct year", {
  # arrange
  diagnoses_data <- data.frame(
    provider = c("RCF", "RCF", "RCF"),
    strategy = c("strategy1", "strategy1", "strategy1"),
    fyear = c(202324, 202425, 202324),
    diagnosis = c("D1", "D2", "D3"),
    n = c(100, 200, 50),
    pcnt = c(0.5, 0.5, 0.5),
    total = c(200, 400, 500),
    rn = c(1, 1, 1)
  )

  m <- mock(diagnoses_data)
  testthat::local_mocked_bindings(get_arrow_dataset = m)

  diagnoses_lookup <- data.frame(
    diagnosis_code = c("D1", "D2", "D3"),
    diagnosis_description = c("Diagnosis 1", "Diagnosis 2", "Diagnosis 3")
  )

  # act
  result <- prepare_diagnoses_data(
    diagnoses_lookup,
    geography = "nhp",
    provider = "RCF",
    strategy = "strategy1",
    selected_year = 202324
  )

  # assert
  expect_equal(nrow(result), 2)
  expect_equal(result$diagnosis_description, c("Diagnosis 1", "Diagnosis 3"))
})
