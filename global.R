source("R/load_libraries.R")
source("R/load_categories.R")
source("R/catDetail_module.R")
source("R/catSimpleSummary_module.R")
source("R/filter_disag.R")
source("R/cook_waffle.R")
source("R/generate_text.R")

enableBookmarking(store = "url")

indicator_info = readr::read_csv("data/indicator_info.csv")
load(file = "data/clean_indicators.RData")

# Colour schemes
waffle_no = "grey"
waffle_yes =  "firebrick"