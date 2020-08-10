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
        column(6, uiOutput(ns("select_disag"))
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
                                   value = "Welsh Health Equity Status 2020"
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


catDetail = function(input, output, session){
  
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
  
  output$bar_plot = renderPlot({
    plot_obj()
  })
  
  
  output$select_disag = renderUI({
    choices =
      indicator_info %>%
      filter(ind_id == input$ind_id) %>%
      pull(disag) %>%
      unlist()
    
    names(choices) = choices
    
    selectInput(session$ns("disag"),
                label = "Please select a disaggregate",
                choices = choices,
                selected = "",
                multiple = TRUE)
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
  outputOptions(output, "select_disag", suspendWhenHidden = FALSE)
  
}