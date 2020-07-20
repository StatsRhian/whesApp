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
               selectInput(ns("ind_id"),
                           label = "Please select an indicator",
                           choices = 
                             filter(indicator_info, category == cat) %>%
                             select(name, ind_id) %>%
                             deframe(),
                           selected = "",
                           width = "90%"
               )
        ), # End: column
        column(6, uiOutput(ns("select_disag"))
        ) # End: column
      ), # End: fluid row
      
      fluidRow(
        htmlOutput(ns("simple_summary"))
      ), # End: fluid row
      
      fluidRow(
        plotOutput(ns("infographic")),
        downloadButton(ns("downloadPlot"), "Download")
      ) # End: fluid row
    )
  )
}

catSimpleSummary = function(input, output, session) {
  
output$select_disag = renderUI({
  choices =
    indicator_info %>%
    filter(ind_id == input$ind_id) %>%
    pull(disag) %>%
    unlist()
  names(choices) = choices
selectInput(session$ns("disag"),
                          label = "Please select a disaggregate",
                          choices = c("None", choices),
                          selected = "None")
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
    cook_waffle(input$disag, title = title)
  })

output$simple_summary = renderUI({
  statement = indicator_info$name[which(indicator_info$ind_id == input$ind_id)]
  indicator_data %>%
    filter(ind_id == input$ind_id) %>%
    filter_disag(input$disag) %>%
    generate_text(input$disag, statement) %>%
    #add_style() %>%
    HTML()
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