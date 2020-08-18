catSimpleSummaryUI = function(id, cat){
  ns = NS(id)
  print(cat)
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
                           label = "Please select an indicator. You can type in the box to search for a key word.",
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
        htmlOutput(ns("simple_summary"))
      ), # End: fluid row
      
      fluidRow(
        plotOutput(ns("infographic")),
        downloadButton(ns("downloadPlot"), "Download")
      ) # End: fluid row
    )
  )
}

catSimpleSummary = function(input, output, session, lang, cat) {
  
output$select_disag = renderUI({
  choices =
    indicator_info %>%
    filter(ind_id == input$ind_id) %>%
    pull(disag) %>%
    unlist()

  if (is.na(choices)) {
    choices = "None"
  } else {
    choices = c("None", choices)
  }
  names(choices) = choices
  
selectInput(session$ns("disag"),
                          label = "Please select a disaggregate",
                          choices = choices,
                          selected = "None")
})

# Hide Waffle & Download if not a pecentage indicator
observeEvent(input$ind_id, {
  type = 
    indicator_info %>%
    filter(ind_id == input$ind_id) %>%
    pull(type)
  if (type != "percent") {
    hide("infographic")
    hide("downloadPlot")
  } else {
    show("infographic")
    show("downloadPlot")
    }
})
  
waffle_plot = reactive({
  title = 
    indicator_info %>%
    filter(ind_id == input$ind_id) %>%
    pull(name)
  
  print(indicator_data)
  print(input$disag)
  
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
                                        lang = lang()),
                lang = lang())
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

output$simple_summary = renderUI({
  type = indicator_info %>%
    filter(ind_id == input$ind_id) %>% 
    pull(type)
  
  statement = indicator_info %>%
    filter(ind_id == input$ind_id) %>% 
    pull(name)

  indicator_data %>%
    filter(ind_id == input$ind_id) %>%
    filter_disag(input$disag) %>%
    generate_text(statement, input$disag, type) %>%
    HTML() %>%
    style_text()
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

# Ensure select_disag works on start
outputOptions(output, "select_disag", suspendWhenHidden = FALSE)
  
}