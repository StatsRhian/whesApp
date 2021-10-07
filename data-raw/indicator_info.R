## code to prepare `indicator_info` dataset goes here
library(dplyr)
indicator_info = readr::read_csv("inst/extdata/indicator_info.csv")
load(file = "data/indicator_data.RData")
# Create indicator info
indicator_info =
  indicator_info %>%
  dplyr::mutate(disag = whesApp:::calc_disag_vars(ind_id)) %>%
  dplyr::left_join(dplyr::distinct(dplyr::select(
    indicator_data,
    c(ind_id, type)
  ))) %>%
  dplyr::mutate(source_id = stringr::str_replace_na(source_id,
    replacement = "temp"
  ))
usethis::use_data(indicator_info, overwrite = TRUE)
