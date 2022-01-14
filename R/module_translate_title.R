translateTitleUI = function(id) {
  ns = shiny::NS(id)
  shiny::uiOutput(ns("translated_title"), inline = TRUE)
}

translateTitleServer = function(id, lang) {
  shiny::moduleServer(id, function(input, output, session) {
    output$translated_title = shiny::renderText({
      tr_pull(whesApp::translate_db, key = glue::glue("title_{id}"), lang())
    })
  })
}
