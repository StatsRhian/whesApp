translate_db = read_csv("www/translation_database.csv")

tr = function(key, lang){
  translate_db %>%
    filter(section == key) %>%
    pull(lang)
}
