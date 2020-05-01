catSimpleSummaryUI = function(id, cat){
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
                           choices = c("None" = "None",
                                       "Gender" = "Gender",
                                       "Age" = "Age",
                                       "Welsh Index" = "WIMD", 
                                       "Education level" = "Educat"),
                           selected = "None")
        ) # End: column
      ), # End: fluid row
      
      fluidRow(
        p("The percentage of adults reporting fair; 
          bad or very bad health is 16% for Young Adults, 27% for
          Working Age Adults and 44% for Retirement Age Adults.", 
          style = "font-size:20px")
      ), # End: fluid row
      
      fluidRow(
        plotOutput(ns("infographic")),
        downloadButton(ns("downloadPlot"), "Download")
      ) # End: fluid row
    )
  )
}

catSimpleSummary = function(input, output, session) {
  
waffle_plot = reactive({
    waffle_data = 
      ind001_df %>%
      when(
        (input$disag == "None") ~ .,
        ~ group_by(., !!!syms(input$disag))
      ) %>%
      summarise(Percent = sum(n_yes) / sum(n)) %>%
      rename(Yes = Percent) %>%
      mutate(No = 1 - Yes) %>%
      when(
        (input$disag == "None") ~ pivot_longer(., cols = everything(),
                                              names_to = "Response",
                                              values_to = "Percent") ,
        ~  pivot_longer(., cols = -!!sym(input$disag),
                        names_to = "Response",
                        values_to = "Percent") 
      ) %>%
      mutate(Response = as_factor(Response)) %>%
      mutate(Percent = round(Percent * 100, 0))
    
    
    ### Theming
    waffle = 
      waffle_data %>%
      ggplot(aes(values = Percent, label = Response, col = Response)) +
      geom_pictogram(
        n_rows = 10, size = 9.5, 
        flip = TRUE,
        family = "Font Awesome 5 Free Solid"
      ) +
      scale_color_manual(
        name = NULL,
        values = c("firebrick", "grey"),
        labels = c("Yes", "No")
      ) +
      scale_label_pictogram(
        name = NULL,
        values = c("user", "user"),
        labels = c("Yes", "No")
      ) +
      labs(
        title = "Percentage of adults reporting fair,\nbad or very bad health",
        caption = "Welsh Health Equity Status 2020"
      ) +
      theme_ipsum_rc(grid = "") +
      theme_enhance_waffle()
    
    # DISAG
    if(input$disag == "None"){
      waffle = 
        waffle +
        coord_equal(xlim = c(1, 10),
                    ylim = c(1, 10))
    } else {
      waffle = 
        waffle +
        facet_grid(cols = vars(!!sym(input$disag))) +
        scale_x_discrete(expand = c(0, 0)) +
        scale_y_discrete(expand = c(0, 0)) +
        coord_equal()
    }
    waffle
  })

output$infographic = renderPlot({
  waffle_plot()
})
  
  output$downloadPlot = downloadHandler(
    filename = function() { 
      paste("waffle_indicator001", ".png", sep = "") 
    },
    content = function(file) {
      ggsave(file, plot =  waffle_plot(), device = "png")
    }
  )
  
}