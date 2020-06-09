# Create indicator master

indicator_info = 
  readxl::read_excel("~/Downloads/20200403_HealthEquityDataset_IndicatorListForJumpingRivers_FINAL.xlsx")

indicator_info = 
indicator_info %>% 
  rename(ind_id = `...1`)%>%
  rename(category = `Category/Policy area`) %>%
  rename(name = `Suggested Welsh indicator`) %>%
  dplyr::select(ind_id, category, name) %>%
  dplyr::filter(!is.na(name)) %>% 
  dplyr::mutate(ind_id = glue::glue("ind_{sprintf('%03d', ind_id)}")) %>%
  dplyr::mutate(category = stringr::str_to_lower(category)) %>%
  tidyr::separate(category, into = c("category"), sep = " ")

write_csv(indicator_info, "data/indicator_info.csv")
