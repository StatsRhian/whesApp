categoryPanelUI = function(id){
  ns = NS(id)
  tabPanel(uiOutput(glue("{id}_tab_title"), inline = TRUE), 
           icon = icon(cat_df$icon[cat_df$catID == id]),
           tabsetPanel(
             tabPanel("Infographics",
                      value = "infographics",
                      catSimpleSummaryUI(ns("simple"), id)
             ),
             tabPanel("Detail",
                      value = "detail",
                      catDetailUI(ns("detailed"), id)
             ),
             tabPanel("Policies",
                      value = "policy",
                      fluidPage(
                        fluidRow(
                          column(12,
                                 tags$br(),
                                 includeMarkdown(glue::glue("www/content/policy-{id}.md"))  
                          )
                        ) # End: fluid row 
                      ) # End: fluid page
             ) # End policy tab panel
           ) # End tabset panel
  )
}

categoryPanel = function(input, output, session, lang, cat){
  callModule(catSimpleSummary, "simple", lang = lang, cat = cat)
  callModule(catDetail, "detailed", lang = lang, cat = cat)
}
