infographicsUI = function(id, cat) {
  ns = shiny::NS(id)
  shiny::tagList(
    shiny::fluidPage(
      shiny::fluidRow(
        shiny::column(
          12,
          shiny::br(),
          shiny::uiOutput(ns("tab_heading")),
          shiny::br()
        )
      ), # End: fluid row

      shiny::fluidRow(
        shiny::column(
          6,
          shinyWidgets::pickerInput(
            inputId = ns("ind_id"),
            label = "Please select an indicator. You can type in the box to search for a key word.", # nolint
            choices =
              dplyr::filter(
                whesApp::indicator_info,
                .data$category == cat
              ) %>%
                dplyr::select(.data$name, .data$ind_id) %>%
                tibble::deframe(),
            options = list(
              `live-search` = TRUE
            ),
            width = "90%"
          )
        ), # End: column
        shiny::column(
          6,
          shiny::selectInput(ns("disag"),
            label = "Please select a grouping",
            choices = c(
              "None" = "None",
              "Gender" = "Gender",
              "Age" = "Age",
              "Deprivation" = "Deprivation",
              "Education level" = "Education"
            ),
            selected = "None"
          )
        ) # End: column
      ), # End: fluid row,

      shiny::fluidRow(
        shiny::plotOutput(ns("infographic")),
        shiny::uiOutput(ns("download_plot_button"))
      ) # End: fluid row
    )
  )
}

infographicsServer = function(id, lang, cat) {
  shiny::moduleServer(id, function(input, output, session) {
    ind_df = shiny::reactive({
      whesApp::indicator_data %>%
        dplyr::filter(.data$ind_id == input$ind_id) %>%
        filter_disag(input$disag)
    })

    shiny::observeEvent(lang(), {
      shinyWidgets::updatePickerInput(
        session,
        inputId = "ind_id",
        label = tr_pull(whesApp::translate_db, "select_ind_label", lang()),
        choices = tr_deframe_inds(whesApp::translate_db,
          key_group = cat,
          lang = lang(),
          indicator_info = whesApp::indicator_info
        )
      )
    })

    toListen = shiny::reactive({
      list(lang(), input$ind_id)
    })

    shiny::observeEvent(toListen(), {
      update_disag(selected_ind_id = input$ind_id, lang = lang())
    })

    infographic = shiny::reactive({
      create_infographic(ind_df(),
        id = input$ind_id,
        input$disag, lang()
      )
    })

    output$infographic = shiny::renderPlot({
      infographic()
    })

    output$tab_heading = shiny::renderUI({
      tr_pull(whesApp::translate_db, glue::glue("category_{cat}"), lang()) %>%
        shiny::h2()
    })


    output$download_plot_button = shiny::renderUI({
      shiny::downloadButton(
        session$ns("download_plot"),
        tr_pull(whesApp::translate_db, "download", lang())
      )
    })

    output$download_plot = shiny::downloadHandler(
      filename = function() {
        glue::glue("infographic_{input$ind_id}.png")
      },
      content = function(file) {
        ggplot2::ggsave(file,
          plot = infographic(),
          device = ragg::agg_png, bg = "white",
          width = get_plot_width(ind_df(), input$ind_id, input$disag) * 6, height = 6
        )
      }
    )
  })
}
