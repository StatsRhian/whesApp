source("R/load_libraries.R")
source("R/load_categories.R")
source("R/filter_disag.R")
source("R/translate.R")
source("R/cook_waffle.R")
source("R/translate_plots.R")
source("R/create_barchart.R")
source("R/calc_disags.R")

# Install fonts for font awesome
dir.create('~/.fonts')
file.copy(list.files("www/fonts", full.names = TRUE), "~/.fonts",)
system('fc-cache -f ~/.fonts')

breakdown_vars = c("Gender", "Age", "Deprivation", "Education")
globalVariables(breakdown_vars)

load(file = "data/clean_indicators.RData")
indicator_info = readr::read_csv("data/indicator_info.csv")

indicator_info = 
  indicator_info %>% 
  mutate(disag = calc_disag_vars(ind_id)) %>%
  left_join(distinct(select(indicator_data, c(ind_id, type))))

development = FALSE
if (development) {
  # Ensure indicator titles are updated in the translation
  # if the indicator info file changes
  translate_db = update_db(indicator_info, translate_db)
}

# Colour schemes and fonts
brewer_pallete = "Dark2"
primary = "#1A5D7E"
secondary = "#c60158"
waffle_no = "grey"
waffle_yes = secondary
font_family = "Helvetica Neue"