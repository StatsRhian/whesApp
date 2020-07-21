prep_waffle = function(df, disag = input$disag){
  df %>%
    rename(Yes = prop) %>%
    mutate(No = 1 - Yes)  %>%
    select(-n_yes, -n, -ci_lower, -ci_upper, -ind_id) %>%
    when(
      (disag == "None") ~ pivot_longer(., cols = everything(),
                                             names_to = "Response",
                                             values_to = "Percent") ,
      ~  pivot_longer(., cols = -!!sym(disag),
                      names_to = "Response",
                      values_to = "Percent") 
    ) %>%
    mutate(Response = as_factor(Response)) %>%
    mutate(Percent = round(Percent * 100, 0))
}

disag_facet_labels = tr_pull(translate_db,
                             key = "disag_[A-Za-z]*_value[0-9]",
                             lang = "EN",
                             search = TRUE)
disag_facet_labels_new = tr_pull(translate_db,
                                 key = "disag_[A-Za-z]*_value[0-9]",
                                 lang = "CY",
                                 search = TRUE)

names(disag_facet_labels_new) = disag_facet_labels
names(disag_facet_labels) = disag_facet_labels

translate_labeller = function(lang){
  switch(lang, 
         "EN" = as_labeller(disag_facet_labels),
         "CY" = as_labeller(disag_facet_labels_new))
}


cook_waffle = function(df, disag = input$disag, 
                       title = "", 
                       caption = "Welsh Health Equity Status 2020",
                       legend_labels = c("Yes", "No"),
                       lang = "EN"){
  waffle = 
    df %>%
  ggplot(aes(values = Percent, label = Response, col = Response)) +
    geom_pictogram(
      n_rows = 10, size = 9.5, 
      flip = TRUE,
      family = "FontAwesome"
    ) +
    scale_color_manual(
      name = NULL,
      values = c(waffle_yes, waffle_no),
      labels = legend_labels
    ) +
    scale_label_pictogram(
      name = NULL,
      values = c("user", "user"),
      labels = legend_labels
    ) +
    labs(
      title = title,
      caption = caption
    ) +
    theme_ipsum_rc(grid = "") +
    theme_enhance_waffle()
  
  # DISAG
  if(disag == "None"){
    waffle = 
      waffle +
      coord_equal(xlim = c(1, 10),
                  ylim = c(1, 10))
  } else {
    waffle = 
      waffle +
      facet_grid(cols = vars(!!sym(disag)),
                 labeller = translate_labeller(lang = lang)) +
      scale_x_discrete(expand = c(0, 0)) +
      scale_y_discrete(expand = c(0, 0)) +
      coord_equal()
  }
  waffle
}
