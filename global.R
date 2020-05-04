source("R/load_libraries.R")
source("R/load_categories.R")
source("R/catDetail_module.R")
source("R/catSimpleSummary_module.R")

indicators = readr::read_csv("data/indicators.csv")
wellbeing_df = readRDS("data/wellbeing.RDS")

ind001_df = 
  wellbeing_df %>%
  filter(indID == "ind001") %>%
  mutate(WIMD = as_factor(WIMD)) %>%
  mutate(Educat = fct_relevel(Educat, "Low", "Medium", "High")) %>%
  mutate(Age = fct_relevel(Age, "Child", "Young Adult",
                           "Working Age Adult", "Retirement Age Adult"))