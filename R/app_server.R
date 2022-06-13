#' The application server-side
#' @param input,output,session Internal parameters for {shiny}.
#' @noRd
app_server = function(input, output, session) {
  lang = shiny::reactive({
    input$lan
  })

  # Call module for data pages
  purrr::map(whesApp::essential_conditions,
             ~ shiny::observeEvent(
               input$page == .x, {
                 dataServer(.x, lang = lang)},
               ignoreInit = TRUE,
               once = TRUE))

  # Call modules for additional pages navbars
  pages = c("policy", "economics", "evidence", "needs", "solutions")
  purrr::map(pages, ~ navbarPagesServer(.x, lang = lang))

  # Call module for translating titles
  titles = whesApp::translate_db %>%
    dplyr::pull(.data$key) %>%
    stringr::str_subset("^title_") %>%
    stringr::str_remove("^title_")
  purrr::map(titles, ~ translateTitleServer(.x, lang = lang))

  # Click-able images on home page
  purrr::map(whesApp::essential_conditions[3:7], onclick_tabset)

  # Indicator search table
  output$indicator_search = reactable::renderReactable({
    create_contents_table(lang = lang())
  })

  # Text on homepage
  output$intro_md = shiny::reactive({
    filename = app_sys(glue::glue("app/www/content/{lang()}/intro.md"))
    shiny::includeMarkdown(filename)
  })

  # Update browser tab title and reactable defaults
  shiny::observeEvent(lang(), {
    title = tr_pull("title_whes_platform", lang())
    session$sendCustomMessage("changetitle", title)

    translate_reactable_options(lang()) # Translate options for all reactable tables
  })

  # Reporting page
  # Intro text on app page
  output$report_md = shiny::reactive({
    filename = app_sys(glue::glue("app/www/content/{lang()}/reporting_page_intro.md"))
    shiny::includeMarkdown(filename)
  })

  # Download button
  output$generate_report_button = shiny::renderUI({
    shinyjs::disabled(shiny::downloadButton(
      "report",
      label = tr_pull("generate", lang())
    ))
  })

  shiny::observe({
    shinyjs::toggleState(
      id = "report",
      condition = (!is.null(input$report_conditions) & !is.null(input$report_info))
    )
  })

  # Generate report
  output$report = shiny::downloadHandler(
    filename = "report.pdf",
    content = function(file) {
      # make temp dir
      tmp_dir = tempdir()

      # define files
      tempReport = file.path(tmp_dir, "rmarkdown/templates/report/skeleton/skeleton.Rmd")

      #copy files
      file.copy(app_sys("rmarkdown"),
                tmp_dir,
                recursive = TRUE,
                overwrite = TRUE)

      #report params
      report_params = list(title = tr_pull("title_whes_platform", lang()),
                           lang = lang(),
                           author = "",
                           date = format(Sys.Date(), format = "%B %d %Y"),
                           conditions = input$report_conditions,
                           info = input$report_info)
      # render report
      rmarkdown::render(
        tempReport,
        output_file = file,
        envir = new.env(parent = globalenv()),
        params = report_params
      )
    }
  )

  # add footer
  output$insert_footer = shiny::renderUI({
    filename = app_sys(glue::glue("app/www/content/{lang()}/footer.md"))
    shiny::hr()
    shiny::includeMarkdown(filename)
  })
}
