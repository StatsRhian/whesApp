## code to prepare `indicator_info` dataset goes here
library(dplyr)
indicator_info = readr::read_csv("inst/extdata/indicator_info.csv")
load(file = "data/indicator_data.RData")
# Create indicator info
indicator_info =
  indicator_info %>%
  dplyr::mutate(disag = whesApp:::calc_disag_vars(ind_id)) %>%
  dplyr::left_join(dplyr::distinct(dplyr::select(indicator_data,
                                                 c(ind_id, type)))) %>%
  dplyr::mutate(source_id = stringr::str_replace_na(source_id,
                                                    replacement = "temp")) %>%
  add_row(ind_id = glue::glue("ind_20{1:7}"),
          category = whesApp::cat_df$catID,
          name = rep("Covid: Example of covid indicator", 7),
          source_id = rep("temp", 7),
          disag = rep(list("None"), 7),
          type = rep("percent", 7)) %>%
  mutate(style = if_else(stringr::str_detect(name, "Covid:"),
                         "font-weight: bold;",
                         ""))
usethis::use_data(indicator_info, overwrite = TRUE)
