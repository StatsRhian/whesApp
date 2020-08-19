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
# tr_pull(translate_db, key = "ind_001", lang = "EN", search = TRUE)


# indented for the search filters
tr_deframe = function(translate_db, key_group, lang){
  translate_db %>%
    filter(str_detect(key, {{ key_group }})) %>% 
    mutate(ind_id = str_extract(key, "_.*"),
           ind_id = str_remove(ind_id, "_")) %>% 
    select({{ lang }}, ind_id) %>% 
    deframe()
}

