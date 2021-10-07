#' The application server-side
#' @param input,output,session Internal parameters for {shiny}.
#' @noRd
app_server = function(input, output, session) {
  lang = shiny::reactive({
    input$lan
  })

  purrr::map(whesApp::cat_df$catID, ~ categoryPanelServer(.x, lang = lang, cat = .x))

  shiny::observeEvent(lang(), {
    translate_reactable_options(lang = lang())
  })

  output$indicator_search = reactable::renderReactable({
    create_contents_table(lang = lang())
  })

  purrr::map(whesApp::cat_df$catID[3:7], onclick_tabset)

  ### Update tabpanel titles
  output$whes_title = shiny::renderText({
    tr_pull(whesApp::translate_db, "whes_title", lang())
  })

  output$overview_tab_title = shiny::renderUI({
    tr_pull(whesApp::translate_db, "overview_tab_title", lang())
  })

  output$wellbeing_tab_title = shiny::renderUI({
    tr_pull(whesApp::translate_db, "category_wellbeing", lang())
  })

  output$morbidity_tab_title = shiny::renderUI({
    tr_pull(whesApp::translate_db, "category_morbidity", lang())
  })

  output$health_tab_title = shiny::renderUI({
    tr_pull(whesApp::translate_db, "category_health", lang())
  })

  output$income_tab_title = shiny::renderText({
    tr_pull(whesApp::translate_db, "category_income", lang())
  })

  output$living_tab_title = shiny::renderUI({
    tr_pull(whesApp::translate_db, "category_living", lang())
  })

  output$social_tab_title = shiny::renderUI({
    tr_pull(whesApp::translate_db, "category_social", lang())
  })

  output$employment_tab_title = shiny::renderUI({
    tr_pull(whesApp::translate_db, "category_employment", lang())
  })

  output$intro_md = shiny::reactive({
    filename = app_sys(glue::glue("app/www/content/{lang()}/intro.md"))
    shiny::includeMarkdown(filename)
  })

  output$policies = shiny::renderText({
    tr_pull(whesApp::translate_db, key = "policies_tab_title", lang())
  })

  output$policy_md = shiny::reactive({
    filename = app_sys(glue::glue("app/www/content/{lang()}/policies/policy.md"))
    shiny::includeMarkdown(filename)
  })

  # Fix tab title
  shiny::observeEvent(lang(), {
    title = tr_pull(whesApp::translate_db, "whes_title", lang())
    session$sendCustomMessage("changetitle", title)
  })
}
