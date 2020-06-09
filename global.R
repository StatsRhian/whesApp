source("R/load_libraries.R")
source("R/load_categories.R")
source("R/catDetail_module.R")
source("R/catSimpleSummary_module.R")
source("R/filter_disag.R")
source("R/cook_waffle.R")

enableBookmarking(store = "url")

indicators = readr::read_csv("data/indicators.csv")
ind_001 = readRDS(file = "data/indicators/ind_001.RDS")

# Colour schemes
waffle_no = "grey"
waffle_yes =  "firebrick"
