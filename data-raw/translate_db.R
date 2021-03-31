## Code to prepare and update translation database
translate_db = readr::read_csv("inst/extdata/translation_database.csv")
development = FALSE

# Covid temp data (to remove)
translate_db =
  translate_db %>%
  dplyr::add_row(key = c("wellbeing_ind_201",
                  "morbidity_ind_202",
                  "health_ind_203",
                  "income_ind_204",
                  "living_ind_205",
                  "social_ind_206",
                  "employment_ind_207"))

if (development) {
  # Ensure indicator titles are updated in the translation
  # if the indicator info file changes
  translate_db = whesApp:::update_db(indicator_info, translate_db)
}

usethis::use_data(translate_db, overwrite = TRUE)
