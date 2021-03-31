infographicsUI = function(id, cat) {
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
                      shinyWidgets::pickerInput(
                        inputId = ns("ind_id"),
                        label = "Please select an indicator. You can type in the box to search for a key word.", #nolint
                        choices =
                          dplyr::filter(whesApp::indicator_info,
                                        .data$category == cat) %>%
                          dplyr::select(.data$name, .data$ind_id) %>%
                          tibble::deframe(),
                        choicesOpt = list(
                          style = dplyr::filter(whesApp::indicator_info, .data$category == cat) %>%
                            dplyr::pull(.data$style)
                        ),
                        options = list(
                          `live-search` = TRUE),
                        width = "90%"
                      )
        ), # End: column
        shiny::column(6,
                      shiny::selectInput(ns("disag"),
                                         label = "Please select a grouping",
                                         choices = c("None" = "None",
                                                     "Gender" = "Gender",
                                                     "Age" = "Age",
                                                     "Deprivation" = "Deprivation",
                                                     "Education level" = "Education"),
                                         selected = "None")
        ) # End: column
      ), # End: fluid row,

      shiny::fluidRow(
        shiny::plotOutput(ns("infographic")),
        shiny::uiOutput(ns("download_plot_button"))
      ) # End: fluid row
    )
  )
}

infographics = function(input, output, session, lang, cat) {

  ind_df = shiny::reactive({
    whesApp::indicator_data %>%
      dplyr::filter(.data$ind_id == input$ind_id) %>%
      filter_disag(input$disag)
  })

  ind_type = shiny::reactive({
    whesApp::indicator_info %>%
      dplyr::filter(.data$ind_id == input$ind_id) %>%
      dplyr::pull(.data$type)
  })

  infographic = shiny::reactive({
    if (ind_type() == "percent") {
      shinyjs::show("disag")
      title =
        whesApp::indicator_info %>%
        dplyr::filter(.data$ind_id == input$ind_id) %>%
        dplyr::pull(.data$name)

      ind_df() %>%
        tr_table(whesApp::translate_db, lang()) %>%
        prep_waffle(input$disag) %>%
        cook_waffle(input$disag,
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
                    legend_labels = tr_pull(whesApp::translate_db,
                                            key = "waffle_legend_label",
                                            lang = lang()),
                    plot_width = plot_width(),
                    lang = lang())
    } else {
      shinyjs::hide("disag")
      ind_df() %>%
        dplyr::mutate(label = tr_pull(whesApp::translate_db, key = ind_df()$ind_id, lang = lang(), search = TRUE)) %>%
        dplyr::mutate(label = wrapper(.data$label, 50)) %>%
        dplyr::mutate(icon = "fa-bar-chart") %>%
        dplyr::mutate(value = format(round(.data$value, 2), big.mark = ",")) %>%
        dplyr::mutate(value = ifelse(stringr::str_detect(.data$label, "\U00A3"),
                                     glue::glue("\U00A3{value}"), .data$value)) %>%
        create_valuebox(caption = glue::glue(tr_pull(whesApp::translate_db,
                                                     key = "caption",
                                                     lang = lang()),
                                             "\n",
                                             tr_pull(whesApp::translate_db,
                                                     key = caption_source(
                                                       ind = input$ind_id),
                                                     lang = lang())))
    }
  })

  shiny::observeEvent(lang(), {
    shinyWidgets::updatePickerInput(
      session,
      inputId = "ind_id",
      label = tr_pull(whesApp::translate_db, "select_ind_label", lang()),
      choices = tr_deframe_inds(whesApp::translate_db,
                                key_group = cat,
                                lang = lang(),
                                indicator_info = whesApp::indicator_info),
       choicesOpt = list(
         style = dplyr::filter(whesApp::indicator_info, .data$category == cat) %>%
           dplyr::pull(.data$style)
       )
    )
  })

plot_width = shiny::reactive({
  # Multiplier for download settings
  if (ind_type() == "percent") {
    if (input$disag == "None") {
      n = 1
    } else {
      n = ind_df() %>% dplyr::pull(input$disag) %>% length()
    }
  } else {
    n = 1.6
  }

})
toListen = shiny::reactive({
  list(lang(), input$ind_id)
})

shiny::observeEvent(toListen(),  {
  disag_choices =
    whesApp::indicator_info %>%
    dplyr::filter(.data$ind_id == input$ind_id) %>%
    dplyr::pull(.data$disag) %>%
    unlist()

  if (length(disag_choices) == 1 & disag_choices[[1]] == "None") {
    shinyjs::hide("disag")
    search_disag = "disaggregate_None"
  } else {
    names(disag_choices) = disag_choices
    search_disag = glue::glue("disaggregate_({paste(disag_choices, collapse = '|')})")
    shinyjs::show("disag")
  }

  shiny::updateSelectInput(
    session,
    inputId = "disag",
    label = tr_pull(whesApp::translate_db, "select_disag_label", lang()),
    choices = tr_deframe(whesApp::translate_db, pattern = search_disag, lang = lang()),
    selected = tr_deframe(whesApp::translate_db, pattern = "disaggregate_None", lang = lang())
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
  shiny::downloadButton(session$ns("download_plot"),
                        tr_pull(whesApp::translate_db, "download", lang()))
})

output$download_plot = shiny::downloadHandler(
  filename = function() {
    glue::glue("infographic_{input$ind_id}.png")
  },
  content = function(file) {
    ggplot2::ggsave(file, plot = infographic(), device = "png", width = plot_width() * 6, height = 6)
  }
)
}
