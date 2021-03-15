## Code to prepare and update translation database
translate_db = readr::read_csv("inst/extdata/translation_database.csv")
development = FALSE
if (development) {
  # Ensure indicator titles are updated in the translation
  # if the indicator info file changes
  translate_db = whesApp::update_db(indicator_info, translate_db)
}
usethis::use_data(translate_db, overwrite = TRUE)
