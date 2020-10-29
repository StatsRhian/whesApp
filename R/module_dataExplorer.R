dataExplorerUI = function(id, cat){
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
                           label = "Please select an indicator",
                           choices =
                             filter(indicator_info, category == cat) %>%
                             select(name, ind_id) %>%
                             deframe(),
                           selectize = TRUE,
                           width = "90%"
               )
        ), # End: column
        column(2, 
               selectInput(ns("disag1"),
                           label = "Please select a grouping",
                           choices = c("Gender" = "Gender",
                                       "Age" = "Age",
                                       "Deprivation" = "Deprivation", 
                                       "Education level" = "Education"),
                           selected = "Gender")
        ), # End: column
        column(2, 
               selectInput(ns("disag2"),
                           label = "Please select a grouping",
                           choices = c("Gender" = "Gender",
                                       "Age" = "Age",
                                       "Deprivation" = "Deprivation", 
                                       "Education level" = "Education"),
                           selected = "Age")
        ), # End: column
        column(2, 
               uiOutput(ns("ci_button"))
        ) # End: column
      ), # End: fluid row
      
      fluidRow(
        column(7,
               wellPanel(
                 plotOutput(ns("bar_plot")), 
                 uiOutput(ns("download_plot_button"))
               )       
        ), # End: column
        column(5,
               wellPanel(
                 reactableOutput(ns("detailed_table")), 
                 uiOutput(ns("download_data_button"))
               )
        ) # End: column
      ), # End: fluid row
      fluidRow(
        column(12,
               tags$br(),
               uiOutput(ns("indicator_md"))
        )
      ) # End: fluid row
    )
  )
}


dataExplorer = function(input, output, session, lang, cat){
  # Translate page title ----------------------
  output$tab_heading = renderUI({
    tr_pull(translate_db, glue("{cat}_tab_title"), lang()) %>%
      h2()
  })
  
  # Update data -------------------------------
  data = reactive({
    indicator_data %>%
      filter(ind_id == input$ind_id) %>%
      filter_disag(c(input$disag1, input$disag2))
  })
  
  # Update possible groupings -----------------
  disag_choices = reactive({
    indicator_info %>%
      filter(ind_id == input$ind_id) %>%
      pull(disag) %>%
      unlist()
  })
  
  # Update if multiple groupings ---------------
  multiple_disag = reactive({
    if (length(disag_choices()) > 3) {
      disags = disag_choices()[disag_choices() != "None"]
      filtered_df = indicator_data %>%
        filter(ind_id == input$ind_id) %>%
        filter_disag(c(disags[[1]], disags[[2]]))
      out = nrow(filtered_df != 0)
    } else{
      out = TRUE
    }
    out
  })
  
  # Translate indicator drop down -------------
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
  
  
  # Translate grouping dropdown ---------------
  toListen <- reactive({
    list(lang(), input$ind_id)
  })
  
  observeEvent(toListen(),  {
    if (length(disag_choices()) == 1 & disag_choices()[[1]] == "None") {
      updateSelectInput(
        session,
        inputId = "disag1",
        label = tr_pull(translate_db, "select_disag_label", lang()),
        choices = tr_deframe(translate_db, pattern = "disaggregate_None", lang = lang())
      )
    } else {
      disag1 = disag_choices()
      names(disag1) = disag1
      search_disag = glue("disaggregate_({paste(disag1, collapse = '|')})")
      updateSelectInput(
        session,
        inputId = "disag1",
        label = tr_pull(translate_db, "select_disag_label", lang()),
        choices = tr_deframe(translate_db, pattern = search_disag, lang = lang())
      )
      if (input$disag1 != "None") {
        disag2 = disag_choices()[disag_choices() != input$disag1]
      } else {
        disag2 = disag_choices()
      }
      names(disag2) = disag2
      search_disag2 = glue("disaggregate_({paste(disag2, collapse = '|')})")
      updateSelectInput(
        session,
        inputId = "disag2",
        label = tr_pull(translate_db, "select_disag_label", lang()),
        choices = tr_deframe(translate_db, pattern = search_disag2, lang = lang()),
        selected = "None"
      )
    }
    
    
    # Update grp2 based on grp1 -----------------
    observeEvent(input$disag1,  {
      if (input$disag1 == "None" | multiple_disag() == FALSE) {
        updateSelectInput(
          session,
          inputId = "disag2",
          label = tr_pull(translate_db, "select_disag_label", lang()),
          choices = tr_deframe(translate_db, pattern = "disaggregate_None", lang = lang())
        )
      } else {
        disag2 = disag_choices()[disag_choices() != input$disag1]
        names(disag2) = disag2
        search_disag2 = glue("disaggregate_({paste(disag2, collapse = '|')})")
        updateSelectInput(
          session,
          inputId = "disag2",
          label = tr_pull(translate_db, "select_disag_label", lang()),
          choices = tr_deframe(translate_db, pattern = search_disag2, lang = lang()),
          selected = "None"
        )
      }
    })
    
    
    # Bar chart ---------------------------------
    plot_obj = reactive({
      print("Making plot")
      make_barchart(df = data(),
                    disag1 = input$disag1,
                    disag2 = input$disag2,
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
    
    output$bar_plot = renderPlot({
      print("Rendering Plot")
      plot_obj()
    })   
    
    # Table -------------------------------------
    output$detailed_table = 
      renderReactable({
        data() %>%
          tr_table(translate_db, lang = lang()) %>%
          create_reactable()
      })
    
    # Confidence Intervals Button ----------------------
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
  
  output$ci_button = renderUI({
    checkboxInput(session$ns("show_ci"), label = tr_pull(translate_db, "show_ci", lang()), value = TRUE)
  })
  
  # Indicator Information ---------------------
  output$indicator_md = reactive({
    filename = glue("www/content/{lang()}/indicators/{input$ind_id}.md")
    if (file.exists(filename)) {
      includeMarkdown(filename)
    } else {
      includeMarkdown(glue("www/content/{lang()}/indicators/missing.md"))
    }
  })
  
  # Download buttons --------------------------
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
    filename = glue("barchart_{input$ind_id}.png"),
    content = function(file) {
      ggsave(file, plot = plot_obj(), device = "png", width = 20, height = 10)
    }
  )
}