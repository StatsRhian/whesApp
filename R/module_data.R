dataUI = function(id) {
  ns = shiny::NS(id)
  shiny::tabPanel(translateTitleUI(glue::glue("data_{id}")),
    value = id,
    shiny::tagList(
      shiny::fluidPage(

        # Title ------------------------------
        shiny::fluidRow(
          shiny::column(
            12,
            shiny::br(),
            shiny::uiOutput(ns("tab_heading")),
            shiny::br()
          )
        ), # End: fluid row

        # Choose indicator ------------------------------
        shiny::fluidRow(
          shiny::column(
            12,
            shinyWidgets::pickerInput(
              inputId = ns("ind_id"),
              label = tr_pull("select_ind_label", "EN"),
              choices =
                dplyr::filter(
                  whesApp::indicator_info,
                  .data$category == id
                ) %>%
                  dplyr::select(.data$name, .data$ind_id) %>%
                  tibble::deframe(),
              options = shinyWidgets::pickerOptions(
                noneResultsText = tr_pull("table_no_entries", "EN"),
                liveSearch = TRUE
              ),
              width = "90%"
            )
          ),
        ), # End: fluid row,

        # Set options ------------------------------
        shiny::fluidRow(
          shiny::column(
            3,
            shinyWidgets::radioGroupButtons(
              ns("output_type"),
              label = tr_pull("select_output_type", "EN"),
              choices = c(
                "Infographic" = "infographic",
                "Bar chart" = "barchart",
                "Table" = "table"
              ),
              direction = "vertical",
              width = "100%",
              status = "primary"
            ),
            # disag1
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
            ),
            # disag2
            shiny::selectInput(ns("disag2"),
              label = "Please select a grouping",
              choices = c(
                "Gender" = "Gender",
                "Age" = "Age",
                "Deprivation" = "Deprivation",
                "Education level" = "Education"
              ),
              selected = "Age"
            ),
            # ci
            shiny::uiOutput(ns("ci_button")),
            shiny::uiOutput(ns("download_plot_button")),
            shiny::uiOutput(ns("download_data_button"))
          ),

          # Display plot ------------------------------
          shiny::column(
            9,
            shiny::wellPanel(
              shiny::fluidRow(shiny::column(
                12,
                style = "height:400px;",
                shiny::plotOutput(ns("plot_window")),
                reactable::reactableOutput(ns("detailed_table"), height = "400px")
              ))
            ),
          )
        ), # End: fluid row,

        # Add spacing ------------------------------
        shiny::br(),

        # Text warning ------------------------------
        shiny::fluidRow(
          shiny::column(
            12,
            shiny::textOutput(ns("small_numbers"))
          )
        ), # End: fluid row

        # Display md text ------------------------------
        shiny::fluidRow(
          shiny::column(
            12,
            shiny::tags$br(),
            shiny::uiOutput(ns("indicator_md"))
          )
        ) # End: fluid row
      ) # End: fluid page
    )
  )
}

#########################################################################################################
#########################################################################################################

dataServer = function(id, lang) {
  shiny::moduleServer(id, function(input, output, session) {
    ind_df = shiny::reactive({
      whesApp::indicator_data %>%
        dplyr::filter(.data$ind_id == input$ind_id) %>%
        filter_disag(input$disag)
    })

    # Translate "Select indicator"
    shiny::observeEvent(lang(), {
      shinyWidgets::updatePickerInput(
        session,
        inputId = "ind_id",
        label = tr_pull("select_ind_label", lang()),
        choices = tr_deframe_inds(key_group = id, lang = lang()),
        options = shinyWidgets::pickerOptions(
          noneResultsText = tr_pull("table_no_entries", lang()),
          liveSearch = TRUE
        )
      )
    })

    # Translate radio group buttons
    shiny::observeEvent(lang(), {
      shinyWidgets::updateRadioGroupButtons(
        session,
        inputId = "output_type",
        label = tr_pull("select_output_type", lang()),
        choices = tr_deframe(pattern = "^output", lang = lang()),
        status = "primary"
      )
    })

    # Update data for bar plot  -------------------------------
    data = shiny::reactive({
      whesApp::indicator_data %>%
        dplyr::filter(.data$ind_id == input$ind_id) %>%
        filter_disag(c(input$disag, input$disag2))
    })


    listen_disag = shiny::reactive({
      list(input$ind_id, input$output_type, input$disag, lang())
    })

    shiny::observeEvent(listen_disag(), {
      update_disag(
        selected_ind_id = input$ind_id,
        selected_output_type = input$output_type,
        selected_disag = input$disag,
        lang = lang()
      )
    })


    # Confidence Intervals Button ----------------------
    shiny::observe({
      no_ci_avail =
        whesApp::indicator_data %>%
        dplyr::filter(.data$ind_id == input$ind_id) %>%
        dplyr::pull(.data$ci_lower) %>%
        is.na() %>%
        all()

      is_info = (input$output_type == "infographic")

      no_ci = any(c(no_ci_avail, is_info))

      shinyjs::toggleState(
        id = "ci_button",
        condition = !no_ci
      )
    })

    output$ci_button = shiny::renderUI({
      shinyjs::disabled(
        shinyWidgets::awesomeCheckbox(session$ns("show_ci"),
          label = tr_pull("show_ci", lang()),
          value = TRUE,
          status = "default"
        )
      )
    })

    # Make plot ----------------------
    plot_obj = shiny::reactive({
      if (input$output_type == "infographic") {
        create_infographic(ind_df(),
          ind_id = input$ind_id,
          id = id,
          input$disag,
          lang()
        )
      } else if (input$output_type == "barchart") {
        create_barchart(
          df = data(),
          disag1 = input$disag,
          disag2 = input$disag2,
          ci = input$show_ci,
          title = tr_pull(
            key = input$ind_id,
            lang = lang(),
            search = TRUE
          ),
          caption = glue::glue(
            tr_pull(
              key = "caption",
              lang = lang()
            ),
            "\n",
            tr_pull(
              key = caption_source(
                id = input$ind_id
              ),
              lang = lang()
            )
          ),
          lang = lang(),
          labels = translate_labels()
        )
      }
    })

    # Make table ------------------------
    output$detailed_table =
      reactable::renderReactable({
        data() %>%
          tr_table(lang = lang()) %>%
          create_reactable(ci = input$show_ci, lang = lang())
      })

    # Display window ------------------------
    output$plot_window = shiny::renderPlot({
      plot_obj()
    })

    shiny::observeEvent(input$output_type, {
      shiny::req(input$output_type)
      if (input$output_type %in% c("infographic", "barchart")) {
        shinyjs::hide("detailed_table")
        shinyjs::show("plot_window")
      } else {
        shinyjs::hide("plot_window")
        shinyjs::show("detailed_table")
      }
    })

    # Small numbers text ------------------------
    output$small_numbers = shiny::renderText({
      tr_pull("small_numbers", lang())
    })

    output$tab_heading = shiny::renderUI({
      tr_pull(glue::glue("title_data_{id}"), lang()) %>%
        shiny::h2()
    })

    # Download button ------------------------
    output$download_plot_button = shiny::renderUI({
      shiny::downloadButton(
        session$ns("download_plot"),
        tr_pull("download", lang())
      )
    })

    output$download_plot = shiny::downloadHandler(
      filename = function() {
        glue::glue("{input$output_type}_{input$ind_id}.png")
      },
      content = function(file) {
        ggplot2::ggsave(file,
          plot = plot_obj(),
          device = ragg::agg_png,
          bg = "white",
          height = 400,
          width = get_plot_width(ind_df(), input$ind_id, input$disag),
          unit = "px",
          dpi = 72
        )
      }
    )

    output$download_data_button = shiny::renderUI({
      shiny::downloadButton(session$ns("download_data"), tr_pull("download", lang()))
    })

    output$download_data = shiny::downloadHandler(
      filename = function() {
        glue::glue("data_{input$ind_id}.csv")
      },
      content = function(file) {
        utils::write.csv(data(), file, row.names = FALSE)
      }
    )

    shiny::observeEvent(input$output_type, {
      shiny::req(input$output_type)
      if (input$output_type %in% c("infographic", "barchart")) {
        shinyjs::hide("download_data_button")
        shinyjs::show("download_plot_button")
      } else {
        shinyjs::hide("download_plot_button")
        shinyjs::show("download_data_button")
      }
    })

    # Indicator text ------------------------
    output$indicator_md = shiny::renderUI({
      filename = app_sys(glue::glue("app/www/content/{lang()}/indicators/{input$ind_id}.md"))
      if (file.exists(filename)) {
        shiny::includeMarkdown(filename)
      } else {
        shiny::includeMarkdown(app_sys(glue::glue("app/www/content/{lang()}/indicators/missing.md")))
      }
    })
  })
}
