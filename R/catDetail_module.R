catDetailUI = function(id, cat){
  ns = NS(id)
  category_name = cat_df$name[cat_df$catID == cat]
  tagList(
    fluidPage(
      fluidRow(
        br(),
        h2(category_name), 
        br()
      ), # End: fluid row
      
      fluidRow(
        column(6,
               selectInput(ns("indicator"),
                           label = "Please select an indicator",
                           choices = filter(indicators,
                                            category == cat) %>%
                             pull(indicator),
                           selectize = TRUE, 
                           width = "90%"
               )
        ), # End: column
        column(6,
               selectInput(ns("disag"),
                           label = "Please select a disaggregate",
                           choices = c("Gender" = "Gender",
                                       "Age" = "Age",
                                       "Welsh Index" = "WIMD", 
                                       "Education level" = "Educat"),
                           selected = "Gender", 
                           multiple = TRUE)
        ) # End: column
      ), # End: fluid row
      
      fluidRow(
        p("Year: 2019"),
        br(),
        p("Source: ", a(href = "https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=8591",
                        "National Survey for Wales 2019",
                        .noWS = "outside", 
                        target = "_blank"),
          .noWS = c("after-begin", "before-end"))
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
                 dataTableOutput(ns("detailed_table")), 
                 downloadButton(ns("downloadData"), "Download")
               )
        ) # End: column
      ), # End: fluid row
      fluidRow(
        includeMarkdown("www/content/ind001.md")    
      ) # End: fluid row
    )
    
  )
}


catDetail = function(input, output, session){
  
  data = 
    reactive({
      ind001_df %>%
        when(
          is.null(input$disag) ~ .,
          ~ group_by(., !!!syms(input$disag))
        ) %>%
        summarise(Percent = sum(n_yes)/sum(n))
    })
  
  # Plot
  plot_obj = reactive({
    if (is.null(input$disag)) {
      g = data() %>%
        ggplot(aes(x = "All", y = Percent)) + 
        geom_col(fill = "#1B9E77")
    } else if (length(input$disag) == 1) {
      g = data() %>%
        ggplot(aes(x = !!sym(input$disag), y = Percent)) + 
        geom_col(aes(fill = !!sym(input$disag))) 
    } else if (length(input$disag) == 2) {
      g = data() %>%
        ggplot(aes(x = !!syms(input$disag)[[2]], y = Percent)) + 
        geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") 
    }  else if (length(input$disag) == 3) {
      g = data() %>%
        ggplot(aes(x = !!syms(input$disag)[[2]], y = Percent)) + 
        geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") + 
        facet_wrap(vars(!!!syms(input$disag)[[3]]))
    } else if (length(input$disag) == 4) {
      g = data() %>%
        ggplot(aes(x = !!syms(input$disag)[[2]], y = Percent)) + 
        geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") + 
        facet_grid(rows = vars(!!!syms(input$disag)[[3]]), 
                   cols = vars(!!!syms(input$disag)[[4]]))
    }
    
    g + 
      labs(title = input$plot_title,
           caption = input$plot_caption) +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
      coord_cartesian(ylim = c(0, 0.5)) +
      theme_minimal() +
      scale_fill_brewer(palette = "Dark2")
  })
  
  output$bar_plot = renderPlot({
    plot_obj()
  })
  
  output$detailed_table = 
    DT::renderDataTable({
      data() %>%
        DT::datatable(rownames = FALSE) %>%
        formatPercentage("Percent")
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
  
}