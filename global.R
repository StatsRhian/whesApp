source("R/load_libraries.R")
source("R/load_categories.R")
source("R/catDetail_module.R")
source("R/catSimpleSummary_module.R")

enableBookmarking(store = "url")

indicators = readr::read_csv("data/indicators.csv")
load(file = "data/clean_indicators.RData")
