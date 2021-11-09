## Code to prepare and update translation database
library("dplyr")

translate_db = readr::read_csv("inst/extdata/translation_database.csv")
translate_db = whesApp:::update_db(whesApp::indicator_info, translate_db)

usethis::use_data(translate_db, overwrite = TRUE)
