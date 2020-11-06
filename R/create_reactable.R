create_reactable = function(df, lang){
  
  type = unique(df$type)
  
  # Translate any disaggregate columns
  col_id = which(names(df) %in% breakdown_vars)
  for (i in seq_along(col_id)) {
    names(df)[col_id[i]] = tr_pull(translate_db, key = glue("disaggregate_{names(df)[col_id[i]]}"), lang = lang)
  }
  
  # Remove columns with NA and drop unnecessary cols
  df = janitor::remove_empty(df, which = c("rows", "cols")) %>%
    select(-ind_id, -type)
  
  # Format confidence intervals
  if ("ci_lower" %in% names(df)) {
    if (type == "percent") {
      df = mutate(df, across(c(ci_upper, ci_lower), ~ percent(round(., 2))))
    }
    else {
      df = mutate(df, across(c(ci_upper, ci_lower), ~ round(., 0)))
    }
    df =
    df %>%
      unite(col = "confidence", ci_lower:ci_upper, sep = " - ") %>%
      relocate(confidence, .after = value) %>%
      rename_with(~tr_pull(translate_db, "col_confidence", lang), "confidence")
  }
  
  if (type == "percent") {
    table_out = 
      df %>%
      reactable(
        showPageSizeOptions = TRUE,
        columns = list(
          value = colDef(name = tr_pull(translate_db, "col_value", lang),
                         format = colFormat(percent = TRUE, digits = 1),
                         na = "*")
        ))
  } else {
    table_out = 
      df %>%
      reactable(
        showPageSizeOptions = TRUE,
        columns = list(
          value = colDef(name = tr_pull(translate_db, "col_value", lang),
                         na = "*")
        )
      )
  }
  return(table_out)
}