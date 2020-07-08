catSimpleSummaryUI = function(id, cat){
  ns = NS(id)
  print(cat)
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
               uiOutput(ns("ind_id_ui"))
               # selectInput(ns("ind_id"),
               #             label = "Please select an indicator",
               #             choices = 
               #               filter(indicator_info, category == cat) %>%
               #               select(EN, ind_id) %>%
               #               deframe(),
               #             selectize = TRUE, 
               #             width = "90%"
               # )
        ), # End: column
        column(6,
               selectInput(ns("disag"),
                           label = "Please select a disaggregate",
                           choices = c("None" = "None",
                                       "Gender" = "Gender",
                                       "Age" = "Age",
                                       "Welsh Index" = "WIMD", 
                                       "Education level" = "Education"),
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

catSimpleSummary = function(input, output, session, lang, cat) {
  
waffle_plot = reactive({
  title = 
    indicator_info %>%
    filter(ind_id == input$ind_id) %>%
    pull(EN)
  
  indicator_data %>%
    filter(ind_id == input$ind_id) %>%
    filter_disag(input$disag) %>%
    prep_waffle(input$disag) %>%
    cook_waffle(input$disag, title = title)
  })

output$ind_id_ui = renderUI({
  selectInput(session$ns("ind_id"),
              label = "Please select an indicator",
              choices =
                filter(indicator_info, category == cat) %>%
                select(lang(), ind_id) %>%
                deframe(),
              selectize = TRUE,
              width = "90%"
  )
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