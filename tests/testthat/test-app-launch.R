test_that("The app runs", {
  app = shinytest::ShinyDriver$new(system.file("app", package = "whesApp"),
                                   loadTimeout = 10000)
  expect_equal(app$getTitle(), "Welsh Health Equity Solutions Platform")
  app$stop()
})
