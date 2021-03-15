#' Define categories
#' @return Define categories for five essential conditions
define_categories = function() {
  tibble::tibble(catID = c("wellbeing",
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
}

#' Full category
#' Extract full category name from short name
#' @param cat The short category name
#' @return The long format name
full_category = Vectorize(function(cat) {
  return(whesApp::cat_df$name[whesApp::cat_df$catID == cat])
},
USE.NAMES = FALSE
)
