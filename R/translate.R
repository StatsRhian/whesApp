translate_db = read_csv("data/translation_database.csv")

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
