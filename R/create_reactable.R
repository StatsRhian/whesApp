create_reactable = function(df){
  type = unique(df$type)
  
  # Remove columns with NA
  df = janitor::remove_empty(df)
  
  if (type == "percent" & "ci_lower" %in% names(df)) {
    table_out = 
      df %>%
      select(-ind_id, -type) %>%
      mutate(across(c(ci_upper, ci_lower), ~ percent(round(., 2)))) %>%
      unite(col = "Confidence", ci_lower:ci_upper, sep = " - ") %>%
      relocate(Confidence, .after = value) %>%
      rename(Value = value) %>%
      reactable(columns = list(
        Value = colDef(format = colFormat(percent = TRUE, digits = 1))
      ))
  } else if (type == "percent") {
  table_out = 
    df %>%
    select(-ind_id, -type) %>%
    rename(Value = value) %>%
    reactable(columns = list(
      Value = colDef(format = colFormat(percent = TRUE, digits = 1))
    ))
} else {
  table_out = 
    df %>%
    select(-ind_id, -type) %>%
    reactable()
}
return(table_out)
}