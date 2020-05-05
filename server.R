shinyServer(function(input, output, session) {
  
  # Call modules for infographics page
  callModule(module = catSimpleSummary, id = "simple-wellbeing")
  callModule(module = catSimpleSummary, id = "simple-morbidity")
  callModule(module = catSimpleSummary, id = "simple-health")
  callModule(module = catSimpleSummary, id = "simple-income")
  callModule(module = catSimpleSummary, id = "simple-living")
  callModule(module = catSimpleSummary, id = "simple-social")
  callModule(module = catSimpleSummary, id = "simple-employment")
  
  # Call modules for detail page
  callModule(module = catDetail, id = "detail-wellbeing")
  callModule(module = catDetail, id = "detail-morbidity")
  callModule(module = catDetail, id = "detail-health")
  callModule(module = catDetail, id = "detail-income")
  callModule(module = catDetail, id = "detail-living")
  callModule(module = catDetail, id = "detail-social")
  callModule(module = catDetail, id = "detail-employment")
  
  output$test_lang = renderText(input$lang)
  
  output$indicator_search = renderDataTable({
    indicators %>%
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




