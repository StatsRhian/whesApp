## code to prepare `essential_conditions` dataset goes here
essential_conditions =
  whesApp::indicator_info %>%
  dplyr::pull(category) %>%
  unique() %>%
  factor(levels = c(
    "outcome",
    "behaviour",
    "health",
    "income",
    "living",
    "social",
    "employment"
  )) %>%
  sort()

usethis::use_data(essential_conditions, overwrite = TRUE)
