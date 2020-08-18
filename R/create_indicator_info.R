# Create indicator master
# Not to live in final app
create_indicator_info = function(){
indicator_info =
  readxl::read_excel("~/Downloads/20200403_HealthEquityDataset_IndicatorListForJumpingRivers_FINAL_sp.xlsx")

# Fix typos
indicator_info$`Category/Policy area`[8] = "Morbidity"

indicator_info =
indicator_info %>%
  rename(ind_id = `...1`) %>%
  rename(category = `Category/Policy area`) %>%
  rename(name = `Suggested Welsh indicator`) %>%
  rename(source = `Suggested source`) %>%
  rename(source_link = `Link to source`) %>%
  rename(year = `Period`) %>%
  dplyr::select(ind_id, category, name, name, source, source_link, year) %>%
  dplyr::filter(!is.na(name)) %>%
  dplyr::mutate(ind_id = glue::glue("ind_{sprintf('%03d', ind_id)}")) %>%
  dplyr::mutate(category = stringr::str_to_lower(category)) %>%
  tidyr::separate(category, into = c("category"), sep = " ")

write_csv(indicator_info, "data/indicator_info.csv")
}

