source("R/load_libraries.R")
source("R/load_categories.R")
source("R/catDetail_module.R")
source("R/catSimpleSummary_module.R")
source("R/filter_disag.R")
source("R/cook_waffle.R")

enableBookmarking(store = "url")

# Read in indicator data and info
indicator_info = readr::read_csv("data/indicator_info.csv")
indicator_data = readRDS(file = "data/clean_indicators.RDS")

# Read in data source info
# source_info = readr::read_csv("data/source_info.csv")

# Colour schemes
waffle_no = "grey"
waffle_yes =  "firebrick"
