source("R/load_libraries.R")
source("R/load_categories.R")
source("R/catDetail_module.R")
source("R/catSimpleSummary_module.R")
source("R/filter_disag.R")
source("R/cook_waffle.R")
source("R/generate_text.R")
source("R/generate_source.R")
source("R/calc_disags.R")

enableBookmarking(store = "url")

load(file = "data/clean_indicators.RData")

# Filter indicators to only show ones I have data about
indicator_info = readr::read_csv("data/indicator_info.csv")

indicator_info = 
  indicator_info %>% 
  filter(ind_id %in% indicator_data$ind_id) %>%
  mutate(disag = calc_disag_vars(ind_id)) %>%
  left_join(distinct(select(indicator_data, c(ind_id, type)))) %>%
  filter(type == "percent") %>%
  filter(ind_id != "ind_019")

# Colour schemes
waffle_no = "grey"
waffle_yes = "firebrick"