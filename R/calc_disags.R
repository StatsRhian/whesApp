# Calculate which disaggregates are available for all indicators
calc_disag_vars = Vectorize(function(id){
  breakdown_vars = c("Gender", "Age", "Education", "WIMD")
  disags = 
    indicator_data %>%
    filter(ind_id == id) %>%
    summarise(across(all_of(breakdown_vars), n_distinct)) %>%
    pivot_longer(cols = everything()) %>%
    filter(value > 1) %>%
    pull(name) 
  
  if (identical(disags, character(0))) {
    disags = NA
  }
  
  return(list(disags))
}, 
USE.NAMES = FALSE)

get_disag_choices = function(id){
  indicator_info %>%
    filter(ind_id == id) %>%
    pull(disag) %>%
    magrittr::extract2(1)
}



