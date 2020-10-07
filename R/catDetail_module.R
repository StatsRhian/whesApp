catDetailUI = function(id, cat){
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
                           label = "Please select an indicator",
                           choices =
                             filter(indicator_info, category == cat) %>%
                             select(name, ind_id) %>%
                             deframe(),
                           selectize = TRUE,
                           width = "90%"
               )
        ), # End: column
        column(4, 
               selectInput(ns("disag"),
                           label = "Please select a grouping",
                           choices = c("Gender" = "Gender",
                                       "Age" = "Age",
                                       "Deprivation" = "Deprivation", 
                                       "Education level" = "Education"),
                           selected = "Gender", 
                           multiple = TRUE)
        ), # End: column
        column(2, 
               uiOutput(ns("ci_button"))
        ) # End: column
      ), # End: fluid row
      
      fluidRow(
        column(8,
               wellPanel(
                 plotOutput(ns("bar_plot")), 
                 uiOutput(ns("download_plot_button"))
               )       
        ), # End: column
        column(4,
               wellPanel(
                 reactableOutput(ns("detailed_table")), 
                 uiOutput(ns("download_data_button"))
               )
        ) # End: column
      ), # End: fluid row
      fluidRow(
        column(12,
        tags$br(),
        includeMarkdown("www/content/ind_001.md")   
        )
      ) # End: fluid row
    )
    
  )
}


catDetail = function(input, output, session, lang, cat){
  
  data = 
    reactive({
      indicator_data %>%
        filter(ind_id == input$ind_id) %>%
        filter_disag(input$disag)
    })
  
  # Plot
  plot_obj = reactive({
    print(data())
    print(input$ind_id)
    print(input$disag)
    print(input$show_ci)

    make_barchart(df = data(),
                  disag = input$disag,
                  ci = input$show_ci,
                  title = tr_pull(translate_db, 
                                  key = input$ind_id,
                                  lang = lang(),
                                  search = TRUE), 
                  caption = tr_pull(translate_db, 
                                    key = "caption",
                                    lang = lang()),
                  lang = lang())

  })

  ## Translate indicators
  observeEvent(lang(), {
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
      updateSelectInput(
        session,
        inputId = "disag",
        label = tr_pull(translate_db, "select_disag_label", lang()),
        choices = tr_deframe(translate_db, pattern = "disaggregate_None", lang = lang())
      )
      hide("disag")
    } else {
      disag_choices = disag_choices[disag_choices != "None"]
      names(disag_choices) = disag_choices
      search_disag = glue("disaggregate_({paste(disag_choices, collapse = '|')})")
      updateSelectInput(
        session,
        inputId = "disag",
        label = tr_pull(translate_db, "select_disag_label", lang()),
        choices = tr_deframe(translate_db, pattern = search_disag, lang = lang())
      )
      show("disag")
    }
    
    no_ci = 
      indicator_data %>%
      filter(ind_id == input$ind_id) %>%
      pull(ci_lower) %>%
      is.na() %>%
      all()
    
    if (no_ci) {
      hide("ci_button")
    } else {
      show("ci_button")
    }
  })
  
  output$bar_plot = renderPlot({
    plot_obj()
  })

  output$detailed_table = 
    renderReactable({
      data() %>%
        create_reactable()
    })
  
  output$ci_button = renderUI({
    checkboxInput(session$ns("show_ci"), label = tr_pull(translate_db, "show_ci", lang()), value = TRUE)
  })
  
  output$download_data_button = renderUI({
    downloadButton(session$ns("download_data"), tr_pull(translate_db, "download", lang()))
  })
  
  output$download_data = downloadHandler(
    filename = function() {
      glue("data_{input$ind_id}.csv")
    },
    content = function(file) {
      write.csv(data(), file, row.names = FALSE)
    }
  )
  
  output$download_plot_button = renderUI({
    downloadButton(session$ns("download_plot"), tr_pull(translate_db, "download", lang()))
  })
  
  output$download_plot = downloadHandler(
    filename = function() { 
      glue("barchart_{input$ind_id}.png")
    },
    content = function(file) {
      ggsave(file, plot =  plot_obj(), device = "png", width = 20, height = 10)
    }
  )
}