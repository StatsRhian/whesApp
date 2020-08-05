create_reactable = function(df){
  type = unique(df$type)
  
  # Remove columns with NA
  df = janitor::remove_empty(df)
  
  if (type == "percent") {
    table_out = 
      df %>%
      select(-ind_id, -type) %>%
      reactable(columns = list(
        value = colDef(format = colFormat(percent = TRUE, digits = 1))
      ))
  } else {
    table_out = 
      df %>%
      select(-ind_id, -type) %>%
      reactable()
  }
  return(table_out)
}