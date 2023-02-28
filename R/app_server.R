#' The application server-side
#' @param input,output,session Internal parameters for {shiny}.
#' @noRd
app_server = function(input, output, session) {

  # Page title ------------------------
  output$translated_title = shiny::renderText({
    new_title = tr_pull(key = "title_whes_platform", lang())
    session$sendCustomMessage("changetitle", new_title)
    return(new_title)
  })

  # Data explorer heading ----------------------
  output$data_explorer_title = shiny::renderText({
    tr_pull(key = "title_data", lang())
  })

  # Update language ------------------------
  lang = shiny::reactive({
    session$sendCustomMessage("setLanguage", format_language_code(input$lan))
    input$lan
  })

  # Clear warning of imminent timeout ------------------------
  shiny::observe(session$sendCustomMessage("timeoutExtend", TRUE)) %>%
    shiny::bindEvent(input$timeout_extend)

  # Update active selected data ------------------------
  ind_df = shiny::reactive({
    whesApp::indicator_data %>%
      dplyr::filter(.data$ind_id == input$ind_id) %>%
      filter_disag(input$disag)
  })

  # Translate category select ------------------------
  shiny::observeEvent(lang(), {
    shiny::updateSelectInput(
      session,
      inputId = "category",
      label = tr_pull("select_category", lang()),
      choices = tr_deframe("^category", lang())
    )
  })

  # Update "Select indicator" on language or category ------------------------
  update_indicators = shiny::reactive({
    list(lang(), input$category)
  })
  shiny::observeEvent(update_indicators(), {
    shiny::updateSelectInput(
      session,
      inputId = "ind_id",
      label = tr_pull("select_ind_label", lang()),
      choices = tr_deframe_inds(key_group = input$category, lang = lang())
    )
  })

  # Update data for bar plot  -------------------------------
  data = shiny::reactive({
    whesApp::indicator_data %>%
      dplyr::filter(.data$ind_id == input$ind_id) %>%
      filter_disag(c(input$disag, input$disag2))
  })

  disag_choices = shiny::reactive(get_disag_choices(input$ind_id))

  disag_count = shiny::reactive({
    count_available_disag(
      disag_choices = disag_choices(),
      selected_ind_id = input$ind_id,
      selected_disag = input$disag
    )
  })

  shiny::observeEvent(c(input$output_type, input$ind_id, lang()), {
    update_disag1_input(
      selected_ind_id = input$ind_id,
      disag_choices = disag_choices(),
      disag_count = disag_count(),
      selected_output_type = input$output_type,
      selected_disag = input$disag,
      lang = lang()
    )
  })

  shiny::observe({
    shiny::freezeReactiveValue(input, "disag2")
    update_disag2_input(
      disag_choices = disag_choices(),
      disag_count = disag_count(),
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
      shiny::checkboxInput(
        inputId = session$ns("show_ci"),
        label = tr_pull("show_ci", lang()),
        value = TRUE
      )
    )
  })

  # Make plot ----------------------
  plot_obj = shiny::reactive({
    if (input$output_type == "infographic") {
      create_infographic(ind_df(),
                         ind_id = input$ind_id,
                         id = input$category,
                         input$disag,
                         lang()
      )
    } else if (input$output_type == "barchart") {
      create_barchart(
        df = data(),
        disag1 = input$disag,
        disag2 = input$disag2,
        ci = input$show_ci,
        title = get_plot_title(input$ind_id, lang()),
        caption = get_caption(input$ind_id, lang()),
        lang = lang(),
        labels = translate_labels()
      )
    }
  })

  # Make table ------------------------
  output$detailed_table =
    reactable::renderReactable({
      if (shiny::req(input$output_type) == "table") {
        data() %>%
          tr_table(lang = lang()) %>%
          create_reactable(ci = input$show_ci, lang = lang())
      }
    })

  # Display window ------------------------
  output$plot_window = shiny::renderPlot({
    plot_obj()
  })

  shiny::observeEvent(input$output_type, {
    shiny::req(input$output_type)
    if (input$output_type %in% c("infographic", "barchart")) {
      shinyjs::hide("detailed_table")
      shinyjs::hide("small_numbers")
      shinyjs::show("plot_window")
    } else {
      shinyjs::hide("plot_window")
      shinyjs::show("detailed_table")
      shinyjs::show("small_numbers")
    }
  })

  # Small numbers text ------------------------
  output$small_numbers = shiny::renderText({
    # if data has nan
    has_Nan = any(is.nan(data()$value))
    if (has_Nan) {
      tr_pull("small_numbers", lang())
    } else {
      ""
    }
  })

  # Download button ------------------------
  output$download_plot_button = shiny::renderUI({
    shiny::downloadButton(
      session$ns("download_plot"),
      label = shiny::tagList(
        shiny::tags$i(class = "fas fa-download", role = "presentation"), " ",
        tr_pull(paste("download", input$output_type, sep = "_"), lang())
      ),
      class = "btn-primary",
      icon = NULL
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
                      width = 800,
                      unit = "px",
                      dpi = 72
      )
    }
  )

  output$download_data_button = shiny::renderUI({
    shiny::downloadButton(
      outputId = session$ns("download_data"),
      label = shiny::tagList(
        shiny::tags$i(class = "fas fa-download", role = "presentation"),
        tr_pull("download_table", lang())
      ),
      class = "btn-primary",
      icon = NULL
    )
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

  # Source text ------------------------
  output$indicator_md =  shiny::renderUI(get_source_text(input$ind_id, lang()))

  # Add footer ------------------------
  output$insert_footer = shiny::renderUI({
    filename = app_sys(glue::glue("app/www/content/{lang()}/footer.md"))
    shiny::hr()
    shiny::includeMarkdown(filename)
  })

}
