make_barchart = function(df = data(),
                         disag1 = input$disag1, 
                         disag2 = input$disag2,
                         ci = input$show_ci,
                         title = "", 
                         caption = "Welsh Health Equity Status 2020",
                         lang = "EN"){
d = 0.9
  if (disag1 == "None" & disag2 == "None") {
    g = df %>%
      ggplot(aes(x = tr_pull(translate_db, "all", lang) , y = value)) + 
      geom_col(fill = "#1B9E77") +
      xlab("")
  } else if (disag1 != "None" & disag2 == "None") {
    g = df %>%
      ggplot(aes(x = !!sym(disag1), y = value, fill = !!sym(disag1))) + 
      geom_col()
    g = g %>%
      translate_x_axis(df, disag1, lang = lang) %>%
      translate_fill(df, disag1, lang = lang)
  } else if (disag1 != "None" & disag2 != "None") {
    g = df %>%
      ggplot(aes(x = !!sym(disag2), y = value, fill = !!sym(disag1))) + 
      geom_col(position = position_dodge(d)) 
    g = g %>%
      translate_x_axis(df, disag2, lang = lang) %>%
      translate_fill(df, disag1, lang = lang)
  }
  
  # Add captions & theme
  g = g + 
    labs(title = wrapper(title, width = 100),
         caption = caption) +
    theme_minimal(base_size = 14) 
  
  if (!is.null(ci)) {
  if (!all(is.na(df$ci_lower)) & (ci == TRUE)) {
    g = g +
      geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper),
                    width = 0.3,
                    alpha = 0.8,
                    position = position_dodge(d)) 
  }
  }
  
  if (unique(df$type) == "percent") {
    g = g + 
      scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
      ylab(tr_pull(translate_db, "percent", lang))
  }
  return(g)
}