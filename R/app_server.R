#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server = function(input, output, session) {
  # Call modules for tabs
  purrr::map(whesApp::cat_df$catID, ~callModule(module = categoryPanel,
                                       id = .x,
                                       lang = lang,
                                       cat = .x))
  lang = shiny::reactive({
    input$lan
  })

  shiny::observeEvent(lang(), {
    options(reactable.language = reactable::reactableLang(
      searchPlaceholder = tr_pull(whesApp::translate_db, "table_search", lang()),
      noData =  tr_pull(whesApp::translate_db, "table_no_entries", lang()),
      pageInfo = tr_pull(whesApp::translate_db, "table_entries", lang()),
      pageSizeOptions = tr_pull(whesApp::translate_db, "table_rows", lang()),
      pagePrevious = "\u276e",
      pageNext = "\u276f",
      pagePreviousLabel = tr_pull(whesApp::translate_db, "table_previous", lang()),
      pageNextLabel = tr_pull(whesApp::translate_db, "table_next", lang())
    ))
  })

  output$indicator_search = reactable::renderReactable({
    whesApp::indicator_info %>%
      dplyr::mutate(name = purrr::map2_chr(.data$ind_id,
                                           .data$category,
                                           ~tr_pull(whesApp::translate_db, glue::glue("{.y}_{.x}"), lang()))) %>%
      dplyr::mutate(category = purrr::map_chr(.data$category,
                                              ~tr_pull(whesApp::translate_db, glue::glue("category_{.x}"), lang()))) %>%
      dplyr::select(.data$name, .data$category) %>%
      reactable::reactable(
        defaultPageSize = 10,
        compact = TRUE,
        searchable = TRUE,
        showPageSizeOptions = TRUE,
        columns = list(
          name = reactable::colDef(name = tr_pull(whesApp::translate_db, "table_indicator", lang())),
          category = reactable::colDef(name = tr_pull(whesApp::translate_db, "table_category", lang()))
        ),
        defaultColDef = reactable::colDef(
          align = "left",
          headerStyle = list(background = "#f7f7f8")
        )
      )
  })

  ### Function to create onclick event for images
  onclick_tabset = function(category) {
    shinyjs::onclick(glue::glue("img_{category}"),
                     shiny::updateNavlistPanel(session,
                                               inputId = "tab_categories",
                                               selected = category))
  }

  ### Apply above function to each category
  purrr::map(c("health", "income", "living", "social", "employment"),
             onclick_tabset)

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

  ## Fix tab title
  shiny::observeEvent(lang(), {
    title =  tr_pull(whesApp::translate_db, "whes_title", lang())
    session$sendCustomMessage("changetitle", title)
  })
}
