shinyServer(function(input, output, session) {
  
  # Call modules for tabs
  purrr::map(cat_df$catID, ~callModule(module = categoryPanel,
                                       id = .x,
                                       lang = lang,
                                       cat = .x))
  lang = reactive({
    input$lan
  })  
  
  observeEvent(lang(), {
    options(reactable.language = reactableLang(
      searchPlaceholder = tr_pull(translate_db, "table_search", lang()),
      noData =  tr_pull(translate_db, "table_no_entries", lang()),
      pageInfo = tr_pull(translate_db, "table_entries", lang()),
      pageSizeOptions = tr_pull(translate_db, "table_rows", lang()),
      pagePrevious = "\u276e",
      pageNext = "\u276f",
      pagePreviousLabel = tr_pull(translate_db, "table_previous", lang()),
      pageNextLabel = tr_pull(translate_db, "table_next", lang())
    ))
  })
  
  output$indicator_search = renderReactable({
    indicator_info %>%
      mutate(name =  map2_chr(ind_id, category, ~tr_pull(translate_db, glue("{.y}_{.x}"), lang()))) %>%
      mutate(category = map_chr(category, ~tr_pull(translate_db, glue("category_{.x}"), lang()))) %>%
      select(name, category) %>%
      reactable(
        defaultPageSize = 10,
        compact = TRUE,
        searchable = TRUE,
        showPageSizeOptions = TRUE,
        columns = list(
          name = colDef(name = tr_pull(translate_db, "table_indicator", lang())),
          category = colDef(name = tr_pull(translate_db, "table_category", lang()))
        ),
        defaultColDef = colDef(
          align = "left",
          headerStyle = list(background = "#f7f7f8")
        )
      )
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
    tr_pull(translate_db, "category_wellbeing", lang())
  })
  
  output$morbidity_tab_title = renderUI({
    tr_pull(translate_db, "category_morbidity", lang())
  })
  
  output$health_tab_title = renderUI({
    tr_pull(translate_db, "category_health", lang())
  })
  
  output$income_tab_title = renderText({
    tr_pull(translate_db, "category_income", lang())
  })
  
  output$living_tab_title = renderUI({
    tr_pull(translate_db, "category_living", lang())
  })
  
  output$social_tab_title = renderUI({
    tr_pull(translate_db, "category_social", lang())
  })
  
  output$employment_tab_title = renderUI({
    tr_pull(translate_db, "category_employment", lang())
  })
  
  output$intro_md = reactive({
    filename = glue("www/content/{lang()}/intro.md")
    includeMarkdown(filename)
  })
  
  ## Fix tab title
  observeEvent(lang(), {
    title =  tr_pull(translate_db, "whes_title", lang())
    session$sendCustomMessage("changetitle", title)
  })
  
})
