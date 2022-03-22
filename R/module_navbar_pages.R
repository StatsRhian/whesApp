navbarPagesUI = function(id) {
  ns = shiny::NS(id)
  shiny::navbarMenu(
    translateTitleUI(id),
    markdownTabUI(ns(glue::glue("{id}_overview"))),
    markdownTabUI(ns(glue::glue("{id}_health"))),
    markdownTabUI(ns(glue::glue("{id}_income"))),
    markdownTabUI(ns(glue::glue("{id}_living"))),
    markdownTabUI(ns(glue::glue("{id}_social"))),
    markdownTabUI(ns(glue::glue("{id}_employment")))
  )
}

navbarPagesServer = function(id, lang) {
  shiny::moduleServer(id, function(input, output, session) {
    sub_pages = c("overview", whesApp::essential_conditions[3:7])
    markdown_pages = glue::glue("{id}_{sub_pages}")
    purrr::map(markdown_pages, ~ markdownTabServer(.x, lang = lang))
  })
}
