# Translating all aspect of plotting

#' Translate labels for ggplot
#' Runs once on start up
#' @param translate_db The translation database

translate_labels = function(translate_db) {
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

labels = list(
  CY = disag_facet_labels_CY,
  EN = disag_facet_labels
)
return(labels)
}

get_breaks = function(df, col_name) {
  df %>%
    dplyr::select({col_name}) %>% #nolint
    dplyr::pull() %>%
    unique()
}

get_labels = function(df, breaks, lang, labels) {
  if (lang == "EN") {
    labels_x = labels$EN[which(labels$EN %in% breaks)]
  } else if (lang == "CY") {
    labels_x = labels$CY[which(labels$EN %in% breaks)]
  }
}

translate_x_axis = function(g, df, col_name, lang, labels) {
  breaks = get_breaks(df, col_name)
  labels = get_labels(df, breaks, lang, labels)
  g = g +
    ggplot2::scale_x_discrete(name = tr_pull(whesApp::translate_db,
                                             key = glue::glue("disaggregate_{col_name}"), lang = lang),
                              breaks = breaks,
                              labels = labels)
  return(g)
}

translate_fill = function(g, df, col_name, lang, labels) {
  breaks = get_breaks(df, col_name)
  labels = get_labels(df, breaks, lang, labels)
  g = g +
    ggplot2::scale_fill_brewer(palette = "Dark2",
                               name = tr_pull(whesApp::translate_db,
                                              key = glue::glue("disaggregate_{col_name}"), lang = lang),
                               breaks = breaks,
                               labels = labels)
  return(g)
}
