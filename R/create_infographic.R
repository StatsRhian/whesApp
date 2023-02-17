create_infographic = function(df, ind_id, id, disag, lang) {
  session = shiny::getDefaultReactiveDomain() # nolint

  if (is_percent(ind_id)) {
    # If percent - make a waffle chart
    df %>%
      tr_table(lang) %>%
      prep_waffle(disag) %>%
      create_waffle(disag,
        title = get_plot_title(ind_id, lang),
        caption = get_caption(ind_id, lang),
        legend_labels = tr_pull(
          key = "waffle_legend_label",
          lang = lang
        )
      )
  } else {
    # If not waffle - make valuebox
    df %>%
      prep_valuebox(lang = lang, id = id) %>%
      create_valuebox(caption = get_caption(ind_id, lang))
  }
}
