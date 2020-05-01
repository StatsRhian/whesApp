
if (is.null(input$disag)) {
  g = data() %>%
    ggplot(aes(x = "All", y = Percent)) + 
    geom_col(fill = "#1B9E77")
} else if (length(input$disag) == 1) {
  g = data() %>%
    ggplot(aes(x = !!sym(input$disag), y = Percent)) + 
    geom_col(aes(fill = !!sym(input$disag))) 
} else if (length(input$disag) == 2) {
  g = data() %>%
    ggplot(aes(x = !!syms(input$disag)[[2]], y = Percent)) + 
    geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") 
}  else if (length(input$disag) == 3) {
  g = data() %>%
    ggplot(aes(x = !!syms(input$disag)[[2]], y = Percent)) + 
    geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") + 
    facet_wrap(vars(!!!syms(input$disag)[[3]]))
} else if (length(input$disag) == 4) {
  g = data() %>%
    ggplot(aes(x = !!syms(input$disag)[[2]], y = Percent)) + 
    geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") + 
    facet_grid(rows = vars(!!!syms(input$disag)[[3]]), 
               cols = vars(!!!syms(input$disag)[[4]]))
}

g + 
  labs(y = input$plot_y_axis,
       x = input$plot_x_axis,
       title = input$plot_title,
       caption = input$plot_caption) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  coord_cartesian(ylim = c(0, 0.5)) +
  theme_minimal() +
  scale_fill_brewer(palette = "Dark2")