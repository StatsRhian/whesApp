source("R/load_libraries.R")
source("R/load_categories.R")
source("R/catDetail_module.R")
source("R/catSimpleSummary_module.R")
source("R/filter_disag.R")
source("R/translate.R")
source("R/cook_waffle.R")
source("R/translate_plots.R")
source("R/make_barchart.R")
source("R/generate_text.R")
source("R/generate_source.R")
source("R/calc_disags.R")

load(file = "data/clean_indicators.RData")

# Filter indicators to only show ones I have data about
indicator_info = readr::read_csv("data/indicator_info.csv")

indicator_info = 
  indicator_info %>% 
  filter(ind_id %in% indicator_data$ind_id) %>%
  mutate(disag = calc_disag_vars(ind_id)) %>%
  left_join(distinct(select(indicator_data, c(ind_id, type))))

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
brewer_pallete = "Dark2"
