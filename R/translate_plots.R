# Translating all aspect of plotting

disag_facet_labels = tr_pull(translate_db,
                             key = "disag_[A-Za-z]*_value_[0-9]*",
                             lang = "EN",
                             search = TRUE)
disag_facet_labels_CY = tr_pull(translate_db,
                                key = "disag_[A-Za-z]*_value_[0-9]*",
                                lang = "CY",
                                search = TRUE)

names(disag_facet_labels_CY) = disag_facet_labels
names(disag_facet_labels) = disag_facet_labels

translate_labeller = function(lang){
  switch(lang, 
         "EN" = as_labeller(disag_facet_labels),
         "CY" = as_labeller(disag_facet_labels_CY))
}


get_breaks = function(df, col_name){
  df %>%
    select({col_name}) %>%
    pull() %>%
    unique()
}

get_labels = function(df, breaks, lang){
  if (lang == "EN") {
    labels_x = disag_facet_labels[which(disag_facet_labels %in% breaks)]
  } else if (lang == "CY") {
    labels_x = disag_facet_labels_CY[which(disag_facet_labels %in% breaks)]  
  }
}

translate_x_axis = function(g, df, col_name, lang){
  breaks = get_breaks(df, col_name)
  labels = get_labels(df, breaks, lang)
  g = g +
    scale_x_discrete(name = tr_pull(translate_db, key = glue("disaggregate_{col_name}"), lang = lang),
                     breaks = breaks,
                     labels = labels)
  return(g)
}

translate_fill = function(g, df, col_name, lang){
  breaks = get_breaks(df, col_name)
  labels = get_labels(df, breaks, lang)
  g = g +
    scale_fill_brewer(palette = brewer_pallete,
                      name = tr_pull(translate_db, key = glue("disaggregate_{col_name}"), lang = lang),
                      breaks = breaks,
                      labels = labels)
  return(g)
}

