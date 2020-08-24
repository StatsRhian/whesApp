source("R/load_libraries.R")
source("R/load_categories.R")
source("R/catDetail_module.R")
source("R/catSimpleSummary_module.R")
source("R/filter_disag.R")
source("R/translate.R")
source("R/cook_waffle.R")
source("R/generate_text.R")
source("R/generate_source.R")
source("R/calc_disags.R")

enableBookmarking(store = "url")

load(file = "data/clean_indicators.RData")

#! Move this data processing to WHESPrep
indicator_data = 
  indicator_data %>%
  rename(`Deprivation` = WIMD) %>%
  mutate(`Deprivation` = 
           forcats::fct_recode(`Deprivation`,
                               "Most deprived 20%" = "1",
                               "Quintile 2" = "2",
                               "Quintile 3" = "3",
                               "Quintile 4" = "4",
                               "Least deprived 20%" = "5"))

# Filter indicators to only show ones I have data about
indicator_info = readr::read_csv("data/indicator_info.csv")

indicator_info = 
  indicator_info %>% 
  filter(ind_id %in% indicator_data$ind_id) %>%
  mutate(disag = calc_disag_vars(ind_id)) %>%
  left_join(distinct(select(indicator_data, c(ind_id, type)))) %>%
  filter(type == "percent")

# Also filter the translated
trans_other = 
  translate_db %>%
  filter(!str_detect(key, "_ind_"))
  
trans_ind = 
  translate_db %>%
  filter(str_detect(key, "_ind_")) %>%
  filter(EN %in% indicator_info$name)

translate_db = 
  bind_rows(trans_ind, trans_other)

# Colour schemes
waffle_no = "grey"
waffle_yes = "firebrick"