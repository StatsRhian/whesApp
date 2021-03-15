dataExplorerUI = function(id, cat) {
  ns = shiny::NS(id)
  shiny::tagList(
    shiny::fluidPage(
      shiny::fluidRow(
        shiny::column(12,
               shiny::br(),
               shiny::uiOutput(ns("tab_heading")),
               shiny::br()
        )
      ), # End: fluid row

      shiny::fluidRow(
        shiny::column(6,
                      shiny::selectInput(ns("ind_id"),
                                         label = "Please select an indicator",
                                         choices =
                                           dplyr::filter(whesApp::indicator_info,
                                                         .data$category == cat) %>%
                                           dplyr::select(.data$name, .data$ind_id) %>%
                                           tibble::deframe(),
                                         selectize = TRUE,
                                         width = "90%"
               )
        ), # End: column
        shiny::column(3,
                      shiny::selectInput(ns("disag1"),
                                         label = "Please select a grouping",
                                         choices = c("Gender" = "Gender",
                                                     "Age" = "Age",
                                                     "Deprivation" = "Deprivation",
                                                     "Education level" = "Education"),
                                         selected = "Gender")
        ), # End: column
        shiny::column(3,
                      shiny::selectInput(ns("disag2"),
                                         label = "Please select a grouping",
                                         choices = c("Gender" = "Gender",
                                                     "Age" = "Age",
                                                     "Deprivation" = "Deprivation",
                                                     "Education level" = "Education"),
                                         selected = "Age")
        ) # End: column
      ), # End: fluid row

      shiny::fluidRow(
        shiny::column(6,
                      shiny::wellPanel(
                        shiny::fluidRow(shiny::column(12,
                                                      shiny::plotOutput(ns("bar_plot")),
                                                      shiny::br()
                        )),
                        shiny::fluidRow(
                          shiny::column(3, shiny::uiOutput(ns("download_plot_button"))),
                          shiny::column(9, shiny::uiOutput(ns("ci_button")))
                 )
               )
        ), # End: column
        shiny::column(6,
                      shiny::wellPanel(
                        shiny::fluidRow(shiny::column(12,
                                                      reactable::reactableOutput(ns("detailed_table")),
                                                      shiny::br()
                 )),
                 shiny::fluidRow(
                   shiny::column(3,
                                 shiny::uiOutput(ns("download_data_button"))
                   ),
                   shiny::column(9,
                                 shiny::textOutput(ns("small_numbers"))))
               )
        ) # End: column
      ), # End: fluid row
      shiny::fluidRow(
        shiny::column(12,
                      shiny::tags$br(),
                      shiny::uiOutput(ns("indicator_md"))
        )
      ) # End: fluid row
    )
  )
}


dataExplorer = function(input, output, session, lang, cat) {
  # Translate page title ----------------------
  output$tab_heading = shiny::renderUI({
    tr_pull(whesApp::translate_db, glue::glue("category_{cat}"), lang()) %>%
      shiny::h2()
  })

  # Update data -------------------------------
  data = shiny::reactive({
    whesApp::indicator_data %>%
      dplyr::filter(.data$ind_id == input$ind_id) %>%
      filter_disag(c(input$disag1, input$disag2))
  })

  # Update possible groupings -----------------
  disag_choices = shiny::reactive({
    whesApp::indicator_info %>%
      dplyr::filter(.data$ind_id == input$ind_id) %>%
      dplyr::pull(.data$disag) %>%
      unlist()
  })

  # Update if multiple groupings ---------------
  multiple_disag = shiny::reactive({
    if (length(disag_choices()) > 3) {
      disags = disag_choices()[disag_choices() != "None"]
      filtered_df = whesApp::indicator_data %>%
        dplyr::filter(.data$ind_id == input$ind_id) %>%
        filter_disag(c(disags[[1]], disags[[2]]))
      out = nrow(filtered_df != 0)
    } else{
      out = TRUE
    }
    out
  })

  # Translate indicator drop down -------------
  shiny::observeEvent(lang(), {
    shiny::updateSelectInput(
      session,
      inputId = "ind_id",
      label = tr_pull(whesApp::translate_db, "select_ind_label", lang()),
      choices = tr_deframe_inds(whesApp::translate_db,
                                key_group = cat,
                                lang = lang(),
                                indicator_info = whesApp::indicator_info)
    )
  })


  # Translate grouping dropdown ---------------
  toListen <- shiny::reactive({
    list(lang(), input$ind_id)
  })

  shiny::observeEvent(toListen(),  {
    if (length(disag_choices()) == 1 & disag_choices()[[1]] == "None") {
      shiny::updateSelectInput(
        session,
        inputId = "disag1",
        label = tr_pull(whesApp::translate_db, "select_disag_label", lang()),
        choices = tr_deframe(whesApp::translate_db, pattern = "disaggregate_None", lang = lang())
      )
    } else {
      disag1 = disag_choices()
      names(disag1) = disag1
      search_disag = glue::glue("disaggregate_({paste(disag1, collapse = '|')})")
      shiny::updateSelectInput(
        session,
        inputId = "disag1",
        label = tr_pull(whesApp::translate_db, "select_disag_label", lang()),
        choices = tr_deframe(whesApp::translate_db, pattern = search_disag, lang = lang())
      )
      if (input$disag1 != "None") {
        disag2 = disag_choices()[disag_choices() != input$disag1]
      } else {
        disag2 = disag_choices()
      }
      names(disag2) = disag2
      search_disag2 = glue::glue("disaggregate_({paste(disag2, collapse = '|')})")
      shiny::updateSelectInput(
        session,
        inputId = "disag2",
        label = tr_pull(whesApp::translate_db, "select_disag_label", lang()),
        choices = tr_deframe(whesApp::translate_db, pattern = search_disag2, lang = lang()),
        selected = "None"
      )
    }


    # Update grp2 based on grp1 -----------------
    shiny::observeEvent(input$disag1,  {
      if (input$disag1 == "None" | multiple_disag() == FALSE) {
        shiny::updateSelectInput(
          session,
          inputId = "disag2",
          label = tr_pull(whesApp::translate_db, "select_disag_label", lang()),
          choices = tr_deframe(whesApp::translate_db, pattern = "disaggregate_None", lang = lang())
        )
      } else {
        disag2 = disag_choices()[disag_choices() != input$disag1]
        names(disag2) = disag2
        search_disag2 = glue::glue("disaggregate_({paste(disag2, collapse = '|')})")
        shiny::updateSelectInput(
          session,
          inputId = "disag2",
          label = tr_pull(whesApp::translate_db, "select_disag_label", lang()),
          choices = tr_deframe(whesApp::translate_db, pattern = search_disag2, lang = lang()),
          selected = "None"
        )
      }
    })

    # Table -------------------------------------
    output$detailed_table =
      reactable::renderReactable({
        data() %>%
          tr_table(whesApp::translate_db, lang = lang()) %>%
          create_reactable(lang = lang())
      })


    # Small numbers text ------------------------

    output$small_numbers = shiny::renderText({
      tr_pull(whesApp::translate_db, "small_numbers", lang())
    })

    # Confidence Intervals Button ----------------------
    no_ci =
      whesApp::indicator_data %>%
      dplyr::filter(.data$ind_id == input$ind_id) %>%
      dplyr::pull(.data$ci_lower) %>%
      is.na() %>%
      all()

    if (no_ci) {
      shinyjs::hide("ci_button")
    } else {
      shinyjs::show("ci_button")
    }
  })

  output$ci_button = shiny::renderUI({
    shiny::checkboxInput(session$ns("show_ci"),
                         label = tr_pull(whesApp::translate_db, "show_ci", lang()), value = TRUE)
  })

  # Indicator Information ---------------------
  output$indicator_md = shiny::reactive({
    filename = app_sys(glue::glue("app/www/content/{lang()}/indicators/{input$ind_id}.md"))
    if (file.exists(filename)) {
      shiny::includeMarkdown(filename)
    } else {
      shiny::includeMarkdown(app_sys(glue::glue("app/www/content/{lang()}/indicators/missing.md")))
    }
  })

  # Bar chart ---------------------------------
  plot_obj = shiny::reactive({
    create_barchart(df = data(),
                    disag1 = input$disag1,
                    disag2 = input$disag2,
                    ci = input$show_ci,
                    title = tr_pull(whesApp::translate_db,
                                    key = input$ind_id,
                                    lang = lang(),
                                    search = TRUE),
                    caption = glue::glue(tr_pull(whesApp::translate_db,
                                                 key = "caption",
                                                 lang = lang()),
                                         "\n",
                                         tr_pull(whesApp::translate_db,
                                                 key = caption_source(
                                                   ind = input$ind_id),
                                                 lang = lang())),
                    lang = lang(),
                    labels = translate_labels(whesApp::translate_db))
  })

  output$bar_plot = shiny::renderPlot({
    plot_obj()
  })

  # Download buttons --------------------------
  output$download_data_button = shiny::renderUI({
    shiny::downloadButton(session$ns("download_data"), tr_pull(whesApp::translate_db, "download", lang()))
  })

  output$download_data = shiny::downloadHandler(
    filename = function() {
      glue::glue("data_{input$ind_id}.csv")
    },
    content = function(file) {
      utils::write.csv(data(), file, row.names = FALSE)
    }
  )

  output$download_plot_button = shiny::renderUI({
    shiny::downloadButton(session$ns("download_plot"),
                          tr_pull(whesApp::translate_db, "download", lang()))
  })

  output$download_plot = shiny::downloadHandler(
    filename = glue::glue("barchart_{input$ind_id}.png"),
    content = function(file) {
      ggplot2::ggsave(file, plot = plot_obj(), device = "png", width = 20, height = 10)
    }
  )
}
