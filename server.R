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
  
})


