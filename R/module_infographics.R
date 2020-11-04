infographicsUI = function(id, cat){
  ns = NS(id)
  tagList(
    fluidPage(
      fluidRow(
        column(12,
               br(),
               uiOutput(ns("tab_heading")),
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
                           label = "Please select a grouping",
                           choices = c("None" = "None",
                                       "Gender" = "Gender",
                                       "Age" = "Age",
                                       "Deprivation" = "Deprivation", 
                                       "Education level" = "Education"),
                           selected = "None")
        ) # End: column
      ), # End: fluid row,
      
      fluidRow(
        plotOutput(ns("infographic")),
        uiOutput(ns("download_plot_button"))
      ) # End: fluid row
    )
  )
}

infographics = function(input, output, session, lang, cat) {
  
  ind_df = reactive({
    indicator_data %>%
      filter(ind_id == input$ind_id) %>%
      filter_disag(input$disag)
  })
  
  ind_type = reactive({
    indicator_info %>%
      filter(ind_id == input$ind_id) %>%
      pull(type)
  })
  
  infographic = reactive({
    if (ind_type() == "percent") {
      show("disag")
      title = 
        indicator_info %>%
        filter(ind_id == input$ind_id) %>%
        pull(name)
      
      ind_df() %>%
        tr_table(translate_db, lang()) %>%
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
                    plot_width = plot_width(),
                    lang = lang())
    } else {
      hide("disag")
      ind_df() %>%
        mutate(label = tr_pull(translate_db, key = ind_id, lang = lang(), search = TRUE)) %>%
        mutate(label = wrapper(label, 50)) %>%
        mutate(icon = "fa-bar-chart") %>% # Allow to update depending on indicator
        make_valuebox(caption = tr_pull(translate_db, key = "caption", lang = lang()))
    }
    
    
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
  
  plot_width = reactive({
    # Multiplier for download settings
    
    if (ind_type() == "percent") {
      if (input$disag == "None") {
        n = 1
      } else
      {
        n = ind_df() %>% pull(input$disag) %>% length()
      }
    } else {
      n = 1.6
    }
    
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
  
  output$infographic = renderPlot({
    infographic()
  })
  
  output$tab_heading = renderUI({
    tr_pull(translate_db, glue("category_{cat}"), lang()) %>%
      h2()
  })
  
  output$download_plot_button = renderUI({
    downloadButton(session$ns("download_plot"), tr_pull(translate_db, "download", lang()))
  })
  
  output$download_plot = downloadHandler(
    filename = function() { 
      glue("infographic_{input$ind_id}.png") 
    },
    content = function(file) {
      ggsave(file, plot = infographic(), device = "png", width = plot_width() * 6, height = 6)
    }
  )
}