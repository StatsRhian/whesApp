categoryPanelUI = function(id){
  ns = NS(id)
  tabPanel(cat_df$name[cat_df$catID == id], 
           icon = icon(cat_df$icon[cat_df$catID == id]),
           tabsetPanel(
             tabPanel("Infographics",
                      catSimpleSummaryUI(ns("simple"), id)
             ),
             tabPanel("Detail",
                      catDetailUI(ns("detailed"), id)
             ),
             tabPanel("Policies",
                      h2(glue::glue("Policies related to {cat_df$name[cat_df$catID == id]}")),
                      p("Page to allow users to explore various policies implemented by Welsh Governement.
                                 Might link to the welsh gov website website. 
                                 Could have an interactive tables and graphs to explore policy information.")
             )
           )
  )
}

categoryPanel = function(input, output, session){
  callModule(catSimpleSummary, "simple")
  callModule(catDetail, "detailed")
}