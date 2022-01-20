#' Markdown Tab
#' This module is used to add markdown based pages as a tabpanel to an existing dropdown
#' ID should match the name of the `.md` file
#' @param id ID for shiny module namespacing
markdownTabUI = function(id) {
  ns = shiny::NS(id)
  shiny::tabPanel(shiny::uiOutput(ns("tab_heading"), inline = TRUE),
    value = id,
    shiny::tagList(
      shiny::fluidPage(
        shiny::fluidRow(
          shiny::column(
            12,
            shiny::uiOutput(ns("insert_markdown"))
          )
        )
      )
    )
  )
}

markdownTabServer = function(id, lang) {
  shiny::moduleServer(id, function(input, output, session) {
    output$tab_heading = shiny::renderUI({
      tr_pull(glue::glue("title_{id}"), lang())
    })

    output$insert_markdown = shiny::renderUI({
      filename = app_sys(glue::glue("app/www/content/{lang()}/pages/{id}.md"))
      if (file.exists(filename)) {
        shiny::includeMarkdown(filename)
      } else {
        shiny::includeMarkdown(app_sys(glue::glue("app/www/content/{lang()}/pages/missing.md")))
      }
    })
  })
}
