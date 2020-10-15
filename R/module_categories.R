categoryPanelUI = function(id){
  ns = NS(id)
  tabPanel(uiOutput(glue("{id}_tab_title"), inline = TRUE), 
           icon = icon(cat_df$icon[cat_df$catID == id]),
           value = id,
           tabsetPanel(
             tabPanel(uiOutput(ns("infographics")),
                      value = "infographics",
                      infographicsUI(ns("simple"), id)
             ),
             tabPanel(uiOutput(ns("details")),
                      value = "detail",
                      dataExplorerUI(ns("detailed"), id)
             ),
             tabPanel(uiOutput(ns("policies")),
                      value = "policy",
                      policiesUI(ns("policy"), id)
             )
           ) # End tabsetPanel
  ) # End tabPanel
}

categoryPanel = function(input, output, session, lang, cat){
  callModule(infographics, "simple", lang = lang, cat = cat)
  callModule(dataExplorer, "detailed", lang = lang, cat = cat)
  callModule(policies, "policy", lang = lang, cat = cat)
  
  output$infographics = renderText({
    tr_pull(translate_db, key = "infographics_tab_title", lang())
  })
  
  output$details = renderText({
    tr_pull(translate_db, key = "details_tab_title", lang())
  })
  
  output$policies = renderText({
    tr_pull(translate_db, key = "policies_tab_title", lang())
  })
}
