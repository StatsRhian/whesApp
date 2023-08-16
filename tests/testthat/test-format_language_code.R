test_that("atomic language code is correctly made lowercase", {
  expect_identical(format_language_code("EN"), "en")
  expect_identical(format_language_code("en"), "en")
  expect_identical(format_language_code("CY"), "cy")
  expect_identical(format_language_code("cy"), "cy")
})

test_that("language code is correctly formatted for Chinese Simplified/Traditional", {
  expect_identical(format_language_code("ZH-HANT"), "zh-Hant")
  expect_identical(format_language_code("zh-hans"), "zh-Hans")
})

test_that("vectors of language codes are correctly converted", {
  expect_identical(format_language_code(c("en", "DE", "CY")), c("en", "de", "cy"))
})
