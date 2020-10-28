
make_barchart = function(df = data(),
                         disag = input$disag, 
                         ci = input$show_ci,
                         title = "", 
                         caption = "Welsh Health Equity Status 2020",
                         lang = "EN"){
d = 0.9
  if (is.null(disag)) {
    g = df %>%
      ggplot(aes(x = tr_pull(translate_db, "all", lang) , y = value)) + 
      geom_col(fill = "#1B9E77") +
      xlab("")
  } else if (length(disag) == 1) {
    g = df %>%
      ggplot(aes(x = !!sym(disag), y = value, fill = !!sym(disag))) + 
      geom_col()
  } else if (length(disag) == 2) {
    g = df %>%
      ggplot(aes(x = !!syms(disag)[[2]], y = value, fill = !!syms(disag)[[1]])) + 
      geom_col(position = position_dodge(d)) 
  }
  
  # Translate fill & x axis
  if (length(disag) == 1) {
    g = g %>%
      translate_x_axis(df, disag, lang = lang) %>%
      translate_fill(df, disag, lang = lang)
  } else if (length(disag) == 2) {
    g = g %>%
      translate_x_axis(df, disag[[2]], lang = lang) %>%
      translate_fill(df, disag[[1]], lang = lang)
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
                    size = 0.4,
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