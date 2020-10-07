
make_barchart = function(df = data(),
                         disag = input$disag, 
                         title = "", 
                         caption = "Welsh Health Equity Status 2020",
                         lang = "EN"){
  
  if (is.null(disag)) {
    g = df %>%
      ggplot(aes(x = tr_pull(translate_db, "all", lang) , y = value)) + 
      geom_col(fill = "#1B9E77") +
      xlab("")
  } else if (length(disag) == 1) {
    g = df %>%
      ggplot(aes(x = !!sym(disag), y = value)) + 
      geom_col(aes(fill = !!sym(disag)))
  } else if (length(disag) == 2) {
    g = df %>%
      ggplot(aes(x = !!syms(disag)[[2]], y = value)) + 
      geom_col(aes(fill = !!syms(disag)[[1]]),  position = "dodge") 
  }  else if (length(disag) == 3) {
    g = df %>%
      ggplot(aes(x = !!syms(disag)[[2]], y = value)) + 
      geom_col(aes(fill = !!syms(disag)[[1]]),  position = "dodge") + 
      facet_wrap(vars(!!syms(disag)[[3]]),
                 labeller = translate_labeller(lang = lang))
    
  } else if (length(disag) == 4) {
    g = df %>%
      ggplot(aes(x = !!syms(disag)[[2]], y = value)) + 
      geom_col(aes(fill = !!syms(disag)[[1]]),  position = "dodge") + 
      facet_grid(rows = vars(!!syms(disag)[[3]]), 
                 cols = vars(!!syms(disag)[[4]]),
                 labeller = translate_labeller(lang = lang))
  }
  
  # Translate fill & x axis
  if (length(disag) == 1) {
    g = g %>%
      translate_x_axis(df, disag, lang = lang) %>%
      translate_fill(df, disag, lang = lang)
  } else if (length(disag) >= 2) {
    g = g %>%
      translate_x_axis(df, disag[[2]], lang = lang) %>%
      translate_fill(df, disag[[1]], lang = lang)
  }
  
  # Add captions & theme
  g = g + 
    labs(title = title,
         caption = caption) +
    theme_minimal() 
  
  if (unique(df$type) == "percent") {
    g = g + 
      scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
      ylab(tr_pull(translate_db, "percent", lang))
  }
  return(g)
}