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
        column(6, 
               selectInput(ns("disag"),
                           label = "Please select a disaggregate",
                           choices = c("Gender" = "Gender",
                                       "Age" = "Age",
                                       "Deprivation" = "Deprivation", 
                                       "Education level" = "Education"),
                           selected = "Gender", 
                           multiple = TRUE)
        ) # End: column
      ), # End: fluid row
      
      fluidRow(
        column(12,
        htmlOutput(ns("source_info")),
        tags$br()
        )
      ), # End: fluid row
      
      fluidRow(
        column(8,
               wellPanel(
                 plotOutput(ns("bar_plot")), 
                 actionButton(ns("edit_plot"), "Edit", icon = icon("pencil")),
                 downloadButton(ns("downloadPlot"), "Download"),
                 bsModal(ns("editPlotModal"),
                         title = "",
                         trigger = ns("edit_plot"),
                         size = "large",
                         textInput(ns("plot_title"),
                                   label = "Plot title"
                         ),
                         textInput(ns("plot_caption"),
                                   label = "Caption",
                                   value = "Welsh Health Equity Solutions Platform, WHESRi 2020"
                         )
                 )
               )       
        ), # End: column
        column(4,
               wellPanel(
                 reactableOutput(ns("detailed_table")), 
                 downloadButton(ns("downloadData"), "Download")
               )
        ) # End: column
      ), # End: fluid row
      fluidRow(
        column(12,
        tags$br(),
        includeMarkdown("www/content/ind001.md")   
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
    if (is.null(input$disag)) {
      g = data() %>%
        ggplot(aes(x = "All", y = value)) + 
        geom_col(fill = "#1B9E77") +
        xlab("")
    } else if (length(input$disag) == 1) {
      g = data() %>%
        ggplot(aes(x = !!sym(input$disag), y = value)) + 
        geom_col(aes(fill = !!sym(input$disag))) 
    } else if (length(input$disag) == 2) {
      g = data() %>%
        ggplot(aes(x = !!syms(input$disag)[[2]], y = value)) + 
        geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") 
    }  else if (length(input$disag) == 3) {
      g = data() %>%
        ggplot(aes(x = !!syms(input$disag)[[2]], y = value)) + 
        geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") + 
        facet_wrap(vars(!!!syms(input$disag)[[3]]))
    } else if (length(input$disag) == 4) {
      g = data() %>%
        ggplot(aes(x = !!syms(input$disag)[[2]], y = value)) + 
        geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") + 
        facet_grid(rows = vars(!!!syms(input$disag)[[3]]), 
                   cols = vars(!!!syms(input$disag)[[4]]))
    }
    
    g = 
      g + 
      labs(title = input$plot_title,
           caption = input$plot_caption) +
      #coord_cartesian(ylim = c(0, 0.5)) +
      theme_minimal() +
      scale_fill_brewer(palette = "Dark2")
    
    if (data()$type == "percent") {
      g = g + 
        scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
        ylab("Percent")
    }
    return(g)
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
    
    names(disag_choices) = disag_choices
    search_disag = glue("disaggregate_({paste(disag_choices, collapse = '|')})")
    
    updateSelectInput(
      session,
      inputId = "disag",
      label = tr_pull(translate_db, "select_disag_label", lang()),
      choices = tr_deframe(translate_db, pattern = search_disag, lang = lang())
    )
  })
  
  output$bar_plot = renderPlot({
    plot_obj()
  })

  output$detailed_table = 
    renderReactable({
      data() %>%
        create_reactable()
    })
  
  output$source_info = renderUI({
    df = indicator_info %>%
      filter(ind_id == input$ind_id) 
    df %>%
      generate_source() %>%
      HTML() 
  })
  
  output$downloadData = downloadHandler(
    filename = function() {
      paste("indicator001", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(data(), file, row.names = FALSE)
    }
  )
  
  output$downloadPlot = downloadHandler(
    filename = function() { 
      paste("indicator001", ".png", sep = "") 
    },
    content = function(file) {
      ggsave(file, plot =  plot_obj(), device = "png")
    }
  )
  
  # Ensure select_disag works on start
  #outputOptions(output, "select_disag", suspendWhenHidden = FALSE)
  
}