categoryPanelUI = function(id) {
  ns = shiny::NS(id)
  shiny::tabPanel(shiny::uiOutput(glue::glue("{id}_tab_title"), inline = TRUE),
                  icon = shiny::icon(whesApp::cat_df$icon[whesApp::cat_df$catID == id]),
                  value = id,
                  shiny::tabsetPanel(
                    shiny::tabPanel(shiny::uiOutput(ns("infographics")),
                                    value = "infographics",
                                    infographicsUI(ns("simple"), id)
                    ),
                    shiny::tabPanel(shiny::uiOutput(ns("details")),
                                    value = "detail",
                                    dataExplorerUI(ns("detailed"), id)
                    )
                  )
  )
}

categoryPanel = function(input, output, session, lang, cat) {
  shiny::callModule(infographics, "simple", lang = lang, cat = cat)
  shiny::callModule(dataExplorer, "detailed", lang = lang, cat = cat)
  shiny::callModule(policies, "policy", lang = lang, cat = cat)

  output$infographics = shiny::renderText({
    tr_pull(whesApp::translate_db, key = "infographics_tab_title", lang())
  })

  output$details = shiny::renderText({
    tr_pull(whesApp::translate_db, key = "details_tab_title", lang())
  })


}
