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
                                key = "waffle_caption",
                                lang = lang()),
                legend_labels = tr_pull(translate_db, 
                                        key = "waffle_legend_label",
                                        lang = lang()))
  })


observeEvent(lang(), {
  
  ## translate indicators
  updateSelectInput(
    session,
    inputId = "ind_id",
    label = tr_pull(translate_db, "select_ind_label", lang()),
    choices = tr_deframe(translate_db, key_group = cat, lang = lang())
  )
  
  ## translate disags
  updateSelectInput(
    session,
    inputId = "disag",
    label = tr_pull(translate_db, "select_disag_label", lang()),
    choices = tr_deframe(translate_db, key_group = "disaggregate", lang = lang())
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