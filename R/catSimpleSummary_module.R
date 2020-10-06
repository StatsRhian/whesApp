catSimpleSummaryUI = function(id, cat){
  ns = NS(id)
  category_name = cat_df$name[cat_df$catID == cat]
  tagList(
    fluidPage(
      fluidRow(
        column(12,
               br(),
               h2(category_name), 
               br()
        )
      ), # End: fluid row
      
      fluidRow(
        column(6,
               selectInput(ns("ind_id"),
                           label = "Please select an indicator. You can type in the box to search for a key word.",
                           choices = 
                             filter(indicator_info, category == cat) %>%
                             select(name, ind_id) %>%
                             deframe(),
                           selectize = TRUE,
                           width = "90%"
               )
        ), # End: column
        column(6, 
               selectInput(ns("disag"),
                           label = "Please select a disaggregate",
                           choices = c("None" = "None",
                                       "Gender" = "Gender",
                                       "Age" = "Age",
                                       "Deprivation" = "Deprivation", 
                                       "Education level" = "Education"),
                           selected = "None")
        ) # End: column
      ), # End: fluid row
      
      fluidRow(
        htmlOutput(ns("simple_summary"))
      ), # End: fluid row
      
      fluidRow(
        plotOutput(ns("infographic")),
        uiOutput(ns("download_plot_button"))
      ) # End: fluid row
    )
  )
}

catSimpleSummary = function(input, output, session, lang, cat) {
  
  # Hide Waffle & download button if not a pecentage indicator
  observeEvent(input$ind_id, {
    type = 
      indicator_info %>%
      filter(ind_id == input$ind_id) %>%
      pull(type)
    if (type != "percent") {
      hide("infographic")
      hide("download_plot_button")
    } else {
      show("infographic")
      show("download_plot_button")
    }
  })
  
  waffle_plot = reactive({
    title = 
      indicator_info %>%
      filter(ind_id == input$ind_id) %>%
      pull(name)
    
    indicator_data %>%
      filter(ind_id == input$ind_id) %>%
      filter_disag(input$disag) %>%
      prep_waffle(input$disag) %>%
      cook_waffle(input$disag, 
                  title = tr_pull(translate_db, 
                                  key = input$ind_id,
                                  lang = lang(),
                                  search = TRUE), 
                  caption = tr_pull(translate_db, 
                                    key = "caption",
                                    lang = lang()),
                  legend_labels = tr_pull(translate_db, 
                                          key = "waffle_legend_label",
                                          lang = lang()),
                  lang = lang())
  })
  
  observeEvent(lang(), { 
    ## Translate indicators
    updateSelectInput(
      session,
      inputId = "ind_id",
      label = tr_pull(translate_db, "select_ind_label", lang()),
      choices = tr_deframe_inds(translate_db,
                                key_group = cat,
                                lang = lang(),
                                indicator_info = indicator_info)
    )
  })
  
  toListen <- reactive({
    list(lang(), input$ind_id)
  })
  
  observeEvent(toListen(),  {
    # Translate the disaggregates
    disag_choices =
      indicator_info %>%
      filter(ind_id == input$ind_id) %>%
      pull(disag) %>%
      unlist()
    
    if (length(disag_choices) == 1 & disag_choices[[1]] == "None") {
      hide("disag")
      search_disag = "disaggregate_None"
    } else {
    names(disag_choices) = disag_choices
    search_disag = glue("disaggregate_({paste(disag_choices, collapse = '|')})")
    show("disag")
    }
    
    updateSelectInput(
      session,
      inputId = "disag",
      label = tr_pull(translate_db, "select_disag_label", lang()),
      choices = tr_deframe(translate_db, pattern = search_disag, lang = lang()),
      selected = tr_deframe(translate_db, pattern = "disaggregate_None", lang = lang())
    )
  })
  
  output$simple_summary = renderUI({
    type = indicator_info %>%
      filter(ind_id == input$ind_id) %>% 
      pull(type)
    
    statement = indicator_info %>%
      filter(ind_id == input$ind_id) %>% 
      pull(name)
    
    indicator_data %>%
      filter(ind_id == input$ind_id) %>%
      filter_disag(input$disag) %>%
      generate_text(statement, input$disag, type) %>%
      HTML() %>%
      style_text()
  })
  
  
  output$infographic = renderPlot({
    waffle_plot()
  })
  
  
  output$download_plot_button = renderUI({
    downloadButton(session$ns("download_plot"), tr_pull(translate_db, "download", lang()))
  })
  
  output$download_plot = downloadHandler(
    filename = function() { 
      glue("infographic_{input$ind_id}.png") 
    },
    content = function(file) {
      ggsave(file, plot =  waffle_plot(), device = "png")
    }
  )
}