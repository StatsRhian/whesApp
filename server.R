shinyServer(function(input, output, session) {
  
  lan = reactive({
    input$lan
    })
  
  # Call modules for infographics page
  
  purrr::map(cat_df$catID, ~callModule(module = catSimpleSummary, 
                                       id = paste0("simple-", .x),
                                       lang = lan,
                                       cat = .x))
  

  # Call modules for detail page
  
  purrr::map(cat_df$catID, ~callModule(module = catDetail, 
                                       id = paste0("simple-", .x),
                                       lang = lan,
                                       cat = .x))
  
  
  # output$test_lang = renderText(input$lang)
  # 
  output$indicator_search = renderDataTable({
    indicator_info %>%
      DT::datatable()
  })
  

### Function to create onclick event for images
  onclick_tabset = function(category){
    shinyjs::onclick(paste0("img_", category),
                     updateTabsetPanel(session,
                                       inputId = "tab_categories",
                                       selected = cat_df$name[cat_df$catID == category]))
  }

### Apply above function to each category
  purrr::map(c("health", "income", "living", "social", "employment"),
             onclick_tabset)
  
})




