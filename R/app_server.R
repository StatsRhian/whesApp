#' The application server-side
#' @param input,output,session Internal parameters for {shiny}.
#' @noRd
app_server = function(input, output, session) {
  lang = shiny::reactive({
    session$sendCustomMessage("setLanguage", format_language_code(input$lan))
    input$lan
  })

  # Call module for data pages
  purrr::map(whesApp::essential_conditions,
             ~ shiny::observeEvent(
               input$page == .x, {
                 dataServer(.x, lang = lang)},
               ignoreInit = TRUE,
               once = TRUE))

  # Call module for translating titles
  titles = whesApp::translate_db %>%
    dplyr::pull(.data$key) %>%
    stringr::str_subset("^title_") %>%
    stringr::str_remove("^title_")
  purrr::map(titles, ~ translateTitleServer(.x, lang = lang))

  # Indicator search table
  output$indicator_search = reactable::renderReactable({
    create_contents_table(lang = lang())
  })

  # Update browser tab title and reactable defaults
  shiny::observeEvent(lang(), {
    title = tr_pull("title_whes_platform", lang())
    session$sendCustomMessage("changetitle", title)
    # Translate options for all reactable tables
    translate_reactable_options(lang())
  })

  # add footer
  output$insert_footer = shiny::renderUI({
    filename = app_sys(glue::glue("app/www/content/{lang()}/footer.md"))
    shiny::hr()
    shiny::includeMarkdown(filename)
  })
}
