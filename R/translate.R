translate_db = read_csv("data/translation_database.csv")

update_db = function(indicator_info, translate_db){
info_titles = indicator_info$name
tran_titles = translate_db$EN
missing = which(!(info_titles %in% tran_titles))

if (length(missing > 0)) {
new = info_titles[missing]
new_id = indicator_info$ind_id[missing]

for (i in seq_along(new_id)) {
  id = new_id[i]
  trans_row = str_which(translate_db$key, id)
  if (length(trans_row) != 1) {
    stop("Error in updating translation db")
  }
  translate_db$EN[trans_row] = new[i]
}
write_csv(translate_db, file = "data/translation_database.csv")
}
return(translate_db)
}

tr_pull = function(translate_db, key, lang, search = FALSE){
  if (search) {
    translate_db %>%
      filter(str_detect(key, {{ key }})) %>%
      pull({{ lang }})
  } else {
    translate_db %>%
      filter(key == {{ key }}) %>%
      pull({{ lang }})
  }
}

tr_table = function(df, translate_db, lang){
  
  if (lang == "CY") {
    breakdown_vars = c("Gender", "Age", "Deprivation", "Education")
    df_breakdown = which(breakdown_vars %in% names(df))
    
    for (i in seq_along(df_breakdown)) {
      disag = breakdown_vars[df_breakdown[i]]
      mini_trans = 
        translate_db %>%
        filter(str_detect(key, glue("^disag_{disag}")))
      
      disag_levels = levels(df %>% pull({{ disag }}))
      levels_CY = mini_trans$CY[match(disag_levels, mini_trans$EN)]
      
      df = suppressWarnings(
          df %>%
          left_join(mini_trans, by = setNames("EN", disag)) %>%
          select(-key, -{{ disag }}) %>%
          rename({{ disag }} := "CY") %>%
          relocate({{ disag }}, .before = value) %>%
          mutate({{ disag }} := fct_relevel(as_factor(!!sym(disag)), levels = levels_CY)) # keep level order
      )
    }
  }
  return(df)
}

tr_deframe_inds = function(translate_db, key_group, lang, indicator_info){
  available_inds = 
    indicator_info %>%
    filter(category == key_group) %>%
    pull(ind_id) 
  
  pattern = glue("^{key_group}_({paste(available_inds, collapse = '|')})$")
  return(tr_deframe(translate_db, pattern, lang))
}

# indented for the search filters
tr_deframe = function(translate_db, pattern, lang){
  translate_db %>%
    filter(str_detect(key,  pattern)) %>% 
    mutate(ind_id = str_extract(key, "_.*"),
           ind_id = str_remove(ind_id, "_")) %>% 
    select({{ lang }}, ind_id) %>% 
    deframe()
}
