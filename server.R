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
  
  output$indicator_search = renderDataTable({
    indicator_info %>%
      DT::datatable()
  })
  
  shinyjs::onclick("img_health",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected = cat_df$name[cat_df$catID == "health"]))
  shinyjs::onclick("img_income",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected = cat_df$name[cat_df$catID == "income"]))
  
  shinyjs::onclick("img_living",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected = cat_df$name[cat_df$catID == "living"]))
  
  shinyjs::onclick("img_social",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected = cat_df$name[cat_df$catID == "social"]))
  
  shinyjs::onclick("img_employment",
                   updateTabsetPanel(session,
                                     inputId = "tab_categories",
                                     selected = cat_df$name[cat_df$catID == "employment"]))
  
})




