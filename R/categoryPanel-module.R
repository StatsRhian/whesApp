categoryPanelUI = function(id){
  ns = NS(id)
  tabPanel(full_category(id), 
           icon = icon(cat_df$icon[cat_df$catID == id]),
           tabsetPanel(
             tabPanel("Infographics",
                      catSimpleSummaryUI(ns("simple"), id)
             ),
             tabPanel("Detail",
                      catDetailUI(ns("detailed"), id)
             ),
             tabPanel("Policies",
                      fluidPage(
                        fluidRow(
                          column(12,
                                 br(),
                                 h2(glue::glue("Policies related to {cat_df$name[cat_df$catID == id]}")), 
                                 br()
                          )
                        ), # End: fluid row
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

categoryPanel = function(input, output, session){
  callModule(catSimpleSummary, "simple")
  callModule(catDetail, "detailed")
}