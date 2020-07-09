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

cook_waffle = function(df, disag = input$disag, 
                       title = "", 
                       caption = "Welsh Health Equity Status 2020",
                       legend_labels = c("Yes", "No")){
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
      facet_grid(cols = vars(!!sym(disag))) +
      scale_x_discrete(expand = c(0, 0)) +
      scale_y_discrete(expand = c(0, 0)) +
      coord_equal()
  }
  waffle
}
