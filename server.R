shinyServer(function(input, output, session) {
  
  # Call modules for tabs
  purrr::map(cat_df$catID, ~callModule(module = categoryPanel,
                                       id = .x,
                                       lang = lang,
                                       cat = .x))
  lang = reactive({
    input$lan
  })  

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
  
### Function to create onclick event for images
  onclick_tabset = function(category){
    shinyjs::onclick(glue("img_{category}"),
                     updateNavlistPanel(session,
                                       inputId = "tab_categories",
                                       selected = category))
  }

### Apply above function to each category
  purrr::map(c("health", "income", "living", "social", "employment"),
             onclick_tabset)
 
### Update tabpanel titles
  output$whes_title = renderText({
    tr_pull(translate_db, "whes_title", lang())
  })
    
  output$overview_tab_title = renderUI({
    tr_pull(translate_db, "overview_tab_title", lang())
  })
  
  output$wellbeing_tab_title = renderUI({
    tr_pull(translate_db, "wellbeing_tab_title", lang())
  })
  
  output$morbidity_tab_title = renderUI({
    tr_pull(translate_db, "morbidity_tab_title", lang())
  })
  
  output$health_tab_title = renderUI({
    tr_pull(translate_db, "health_tab_title", lang())
  })
  
  output$income_tab_title = renderText({
    tr_pull(translate_db, "income_tab_title", lang())
  })
  
  output$living_tab_title = renderUI({
    tr_pull(translate_db, "living_tab_title", lang())
  })
  
  output$social_tab_title = renderUI({
    tr_pull(translate_db, "social_tab_title", lang())
  })
  
  output$employment_tab_title = renderUI({
    tr_pull(translate_db, "employment_tab_title", lang())
  })
  
  output$intro_md = reactive({
    filename = glue("www/content/{lang()}/intro.md")
    includeMarkdown(filename)
  })
  

  
})

