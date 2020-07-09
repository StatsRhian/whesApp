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
  
#   output$tabs = renderUI({
# #    lapply(c("wellbeing", "morbidity"), generate_tabPanel)
#   })
#   
### Update tabpanel titles
  
  output$overview_tab_title = renderUI({
    tr_pull(translate_db, "overview_tab_title", lan())
  })
  
  output$wellbeing_tab_title = renderUI({
    tr_pull(translate_db, "wellbeing_tab_title", lan())
  })
  
  output$morbidity_tab_title = renderUI({
    tr_pull(translate_db, "morbidity_tab_title", lan())
  })
  
  
  output$health_tab_title = renderUI({
    tr_pull(translate_db, "health_tab_title", lan())
  })
  
  output$income_tab_title = renderText({
    tr_pull(translate_db, "income_tab_title", lan())
  })
  
  output$living_tab_title = renderUI({
    tr_pull(translate_db, "living_tab_title", lan())
  })
  
  output$social_tab_title = renderUI({
    tr_pull(translate_db, "social_tab_title", lan())
  })
  
  output$employment_tab_title = renderUI({
    tr_pull(translate_db, "employment_tab_title", lan())
  })
  
  output$infographics = renderText({
    tr_pull(translate_db, key = "infographics_tab_title", lan())
  })
  
  output$details = renderText({
    tr_pull(translate_db, key = "details_tab_title", lan())
  })
  
  output$policies = renderText({
    tr_pull(translate_db, key = "policies_tab_title", lan())
  })
  
  observe({
    print(input$lang)
  })
  
})




