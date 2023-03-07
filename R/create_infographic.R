create_infographic = function(df, ind_id, id, disag, lang = "EN") {
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
        ),
        lang = lang
      )
  } else {
    # If not waffle - make valuebox
    df %>%
      prep_valuebox(id = id, lang = lang) %>%
      create_valuebox(title = get_plot_title(ind_id, lang),
                      caption = get_caption(ind_id, lang),
                      lang = lang)
  }
}
