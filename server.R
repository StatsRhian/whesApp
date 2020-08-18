shinyServer(function(input, output, session) {
  
  # Call modules for all seven categories
  callModule(categoryPanel, "wellbeing")
  callModule(categoryPanel, "morbidity")
  callModule(categoryPanel, "health")
  callModule(categoryPanel, "income")
  callModule(categoryPanel, "living")
  callModule(categoryPanel, "social")
  callModule(categoryPanel, "employment")
  
  output$test_lang = renderText(input$lang)
  
  output$indicator_search = renderReactable({
    indicator_info %>%
      mutate(category = full_category(category)) %>%
      select(name, category) %>%
      reactable(
        defaultPageSize = 5,
        compact = TRUE,
        searchable = TRUE,
        columns = list(
          name = colDef(name = "Indicator"),
          category = colDef(name = "Category")
        ),
        defaultColDef = colDef(
          align = "left",
          headerStyle = list(background = "#f7f7f8")
        ))
    
  })
  
  shinyjs::onclick("img_health",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected =  full_category("health")))
  shinyjs::onclick("img_income",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected =  full_category("income")))
  
  shinyjs::onclick("img_living",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected =  full_category("living")))
  
  shinyjs::onclick("img_social",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected =  full_category("social")))
  
  shinyjs::onclick("img_employment",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected = full_category("employment")))
  
  observe({
    # Trigger this observer every time an input changes
    reactiveValuesToList(input)
    session$doBookmark()
  })
  onBookmarked(function(url) {
    updateQueryString(url)
  })
  
  setBookmarkExclude(c("living-simple-ind_id",
                       "wellbeing-simple-ind_id",
                       "employment-simple-disag",
                       "morbidity-simple-disag",
                       "income-detailed-ind_id",
                       "wellbeing-detailed-ind_id",
                       "income-detailed-plot_title",
                       "wellbeing-detailed-plot_title",
                       "health-detailed-plot_caption",
                       "income-detailed-edit_plot",
                       "morbidity-simple-ind_id",
                       "morbidity-detailed-plot_title",
                       "social-detailed-plot_title",
                       "social-detailed-ind_id",
                       "living-detailed-edit_plot",
                       "living-detailed-editPlotModal",
                       "income-detailed-editPlotModal",
                       "employment-detailed-editPlotModal",
                       "health-detailed-plot_title",
                       "indicator_search__reactable__page",
                       "health-detailed-editPlotModal",
                       "health-detailed-edit_plot",
                       "living-detailed-ind_id",
                       "employment-detailed-plot_caption",
                       "living-detailed-disag",
                       "indicator_search__reactable__pages",
                       "living-simple-disag",
                       "income-detailed-disag",
                       "income-simple-ind_id",
                       "wellbeing-detailed-editPlotModal",
                       "health-simple-ind_id",
                       "living-detailed-plot_title",
                       "wellbeing-detailed-edit_plot",
                       "health-detailed-disag",
                       "morbidity-detailed-disag",
                       "wellbeing-detailed-disag",
                       "living-detailed-plot_caption",
                       "social-simple-disag",
                       "employment-detailed-edit_plot",
                       "morbidity-detailed-plot_caption",
                       "social-detailed-edit_plot",
                       "employment-detailed-plot_title",
                       "health-simple-disag",
                       "category",
                       "employment-detailed-ind_id",
                       "indicator_search__reactable__selected",
                       "employment-simple-ind_id",
                       "social-detailed-editPlotModal",
                       "wellbeing-detailed-plot_caption",
                       "indicator_search__reactable__pageSize",
                       #"lang",
                       "social-detailed-disag",
                       "income-detailed-plot_caption",
                       "social-detailed-plot_caption",
                       "morbidity-detailed-edit_plot",
                       "wellbeing-simple-disag",
                       "morbidity-detailed-editPlotModal",
                       "employment-detailed-disag",
                       "income-simple-disag",
                       "morbidity-detailed-ind_id",
                       "health-detailed-ind_id",
                       "social-simple-ind_id"))
  
})


