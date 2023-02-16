test_that("count_available_disag handles having only \"None\" disag value", {
  # Living Conditions -> "Average PM10 concentrations across Wales ..."
  expect_equal(
    object = count_available_disag("None", "ind_032", "None"),
    expected = 0L
  )
})

test_that("count_available_disag handles having one disag value.", {
  # Health Outcome -> "Death rate per 100,000 due to tuberculosis"
  expect_equal(
    object = count_available_disag(c("None", "Gender"), "ind_008", "None"),
    expected = 1L
  )
  expect_equal(
    object = count_available_disag(c("None", "Gender"), "ind_008", "Gender"),
    expected = 1L
  )
})

test_that("count_available_disag handles having four disag values.", {
  # Health Outcome -> "... Warwick Edinburgh Mental Wellbeing ..."
  expect_equal(
    object = count_available_disag(
      c("None", "Gender", "Age", "Deprivation", "Education"),
      "ind_011",
      "None"
    ),
    # If the first disag is "None", you aren't allowed to pick a second disag
    # yet, so this should behave as through only a single disag is allowed.
    expected = 1L
  )
  expect_equal(
    object = count_available_disag(
      c("None", "Gender", "Age", "Deprivation", "Education"),
      "ind_011",
      "Education"
    ),
    expected = 2L
  )
})
