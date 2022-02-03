create_infographic = function(df, ind_id, id, disag, lang) {
  session = shiny::getDefaultReactiveDomain()

  if (get_ind_type(ind_id) == "percent") {
    shinyjs::show("disag")

    df %>%
      tr_table(lang) %>%
      prep_waffle(disag) %>%
      create_waffle(disag,
        title = tr_pull(
          key = ind_id,
          lang = lang,
          search = TRUE
        ),
        caption = get_caption(ind_id, lang),
        legend_labels = tr_pull(
          key = "waffle_legend_label",
          lang = lang
        ),
        plot_width = get_plot_width(df, ind_id, disag)
      )
  } else {
    shinyjs::hide("disag")
    df %>%
      prep_valuebox(lang = lang, id = id) %>%
      create_valuebox(caption = get_caption(ind_id, lang))
  }
}
