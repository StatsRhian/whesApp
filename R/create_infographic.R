create_infographic = function(df, id, disag, lang) {
  session = shiny::getDefaultReactiveDomain()

  if (get_ind_type(id) == "percent") {
    shinyjs::show("disag")
    title =
      whesApp::indicator_info %>%
      dplyr::filter(.data$ind_id == id) %>%
      dplyr::pull(.data$name)

    df %>%
      tr_table(whesApp::translate_db, lang) %>%
      prep_waffle(disag) %>%
      create_waffle(disag,
                    title = tr_pull(whesApp::translate_db,
                                    key = id,
                                    lang = lang,
                                    search = TRUE),
                    caption = get_caption(id, lang),
                    legend_labels = tr_pull(whesApp::translate_db,
                                            key = "waffle_legend_label",
                                            lang = lang),
                    plot_width = get_plot_width(df, id, disag),
                    lang = lang)
  } else {
    shinyjs::hide("disag")
    df %>%
      prep_valuebox(lang = lang) %>%
      create_valuebox(caption = get_caption(id, lang))
  }
}
