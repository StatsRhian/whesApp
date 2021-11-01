test_that("Dimensions", {
  expect_equal(ncol(indicator_data), 9)
})

test_that("Indicator ids", {
  data_ids = sort(unique(indicator_data$ind_id))
  expect_equal(length(data_ids), 71)
  info_ids = sort(unique(indicator_info$ind_id))
  expect_equal(data_ids, info_ids)
})
