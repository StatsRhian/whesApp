# Define categories
cat_df = 
  tibble(catID = c("wellbeing", 
                   "morbidity", 
                   "health",
                   "income", 
                   "living", 
                   "social", 
                   "employment"
  ),
  name = c("Well-being",
              "Morbidity",
              "Health Services", 
              "Income and Social Protection",
              "Living Environment",
              "Social and Human Capital",
              "Employment and Working Conditions"), 
  icon = c("smile-beam",
           "procedures",
           "medkit",
           "pound-sign",
           "tree",
           "users",
           "wrench"
  )
  )

full_category = Vectorize(function(cat){
  return(cat_df$name[cat_df$catID == cat])
}, 
USE.NAMES = FALSE
)

