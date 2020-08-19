filter_disag = function(df, disag = input$disag){
  breakdown_vars = c("Gender", "Age", "Deprivation", "Education")
  keep_vars = breakdown_vars[(breakdown_vars %in% disag)]
  remove_vars = breakdown_vars[!(breakdown_vars %in% disag)]
  
  # Set none disagregates to All
  for (i in seq_along(remove_vars)) {
    df = filter(df, !!sym(remove_vars[[i]]) == "All") 
  }
  
  # Remove "All" case for disagregate
  if (length(keep_vars) > 0) {
    for (i in seq_along(keep_vars))
    df = filter(df, !!sym(keep_vars[[i]]) != "All")
  }
  # Remove unneccersary columns
  df = select(df, -any_of(remove_vars))
  return(df)
}
