test_that("Indicators wording is correct in translation db", {
  ind1 = whesApp::indicator_info %>% dplyr::pull(name)
  ind2 = whesApp::translate_db %>%
    dplyr::filter(stringr::str_detect(key, "^ind_\\d{3}")) %>%
    dplyr::pull("EN")
  expect_identical(length(which(!(ind1 %in% ind2))), 0L)
})

test_that("Source keys present in translation db", {
  source1 = whesApp::indicator_info %>% dplyr::pull(source_id)
  source2 = whesApp::translate_db %>%
    dplyr::pull(key) %>%
    stringr::str_replace("source_", "")
  expect_identical(length(which(!(source1 %in% source2))), 0L)
})

test_that("All indicators present in translation db", {
  ind1 = whesApp::indicator_info %>% dplyr::pull(ind_id)
  ind2 = whesApp::translate_db %>%
    dplyr::filter(stringr::str_detect(key, "^ind_\\d{3}")) %>%
    dplyr::pull(key)
  expect_identical(length(which(!(ind1 %in% ind2))), 0L)
})

test_that("All indicators present in translation db are unique", {
  ind = whesApp::translate_db %>%
    dplyr::filter(stringr::str_detect(key, "^ind_\\d{3}")) %>%
    dplyr::pull(key)
  expect_false(any(duplicated(ind)))
})

test_that("All indicators labels are present in translation db", {
  all_in_translation = function(x) {
    all(x %in% whesApp:::translate_labels()$EN) #nolint
  }

  whesApp::indicator_data %>%
    dplyr::select(whesApp::breakdown_vars) %>%
    purrr::map(unique) %>%
    purrr::map_lgl(all_in_translation) %>%
    all() %>%
    expect_true()
})
