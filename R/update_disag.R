update_disag = function(selected_ind_id, lang) {
  session = shiny::getDefaultReactiveDomain()

  disag_choices =
    whesApp::indicator_info %>%
    dplyr::filter(.data$ind_id == selected_ind_id) %>%
    dplyr::pull(.data$disag) %>%
    unlist()

  if (length(disag_choices) == 1 & disag_choices[[1]] == "None") {
    shinyjs::hide("disag")
    search_disag = "disaggregate_None"
  } else {
    names(disag_choices) = disag_choices
    search_disag = glue::glue("disaggregate_({paste(disag_choices, collapse = '|')})")
    shinyjs::show("disag")
  }

  shiny::updateSelectInput(
    session,
    inputId = "disag",
    label = tr_pull(whesApp::translate_db, "select_disag_label", lang),
    choices = tr_deframe(whesApp::translate_db, pattern = search_disag, lang = lang),
    selected = tr_deframe(whesApp::translate_db, pattern = "disaggregate_None", lang = lang)
  )
}
