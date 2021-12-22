test_that("ind_001", {
  all =
    indicator_data %>%
    dplyr::filter(ind_id == "ind_001") %>%
    filter_disag("None") %>%
    dplyr::pull(value) %>%
    round(2)
  expect_equal(all, 0.28)
})
