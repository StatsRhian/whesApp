source("R/load_libraries.R")
source("R/load_categories.R")
source("R/filter_disag.R")
source("R/translate.R")
source("R/cook_waffle.R")
source("R/translate_plots.R")
source("R/make_barchart.R")
source("R/calc_disags.R")

load(file = "data/clean_indicators.RData")
indicator_info = readr::read_csv("data/indicator_info.csv")

indicator_info = 
  indicator_info %>% 
  mutate(disag = calc_disag_vars(ind_id)) %>%
  left_join(distinct(select(indicator_data, c(ind_id, type))))

# Colour schemes
waffle_no = "grey"
waffle_yes = "firebrick"
brewer_pallete = "Dark2"
