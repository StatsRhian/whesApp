#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @noRd
app_ui = function(request) {
  shiny::tagList(
    shiny::tags$a(
      id = "skiplink",
      href = "#main-content-skip",
      "Skip to Main Content"
    ),
    # header
    shiny::tags$header(
      class = "container-fluid",
      shiny::tags$div(
        class = "row align-items-center",
        shiny::tags$div(
          class = "col-lg col-sm-12 order-xs-first order-lg-2",
          shiny::tags$h1(
            shiny::textOutput("translated_title", inline = TRUE),
          )
        ),
        shiny::tags$div(
          class = "col-lg-4 col-sm-12 order-1",
          shiny::img(
            src = "www/logos/who-euro-white.png",
            id = "world-health-org-logo",
            alt = "World Health Organisation Collaborating Centre on Investment
              for Health and Well-being logo - Logo Canolfan Gydweithredol
              Sefydliad Iechyd y Byd ar Fudsoddi ar gyfer Iechyd a Llesaint"
          )
        ),
        shiny::tags$div(
          class = "col-lg-2 col-sm-7 order-3",
          shiny::img(
            src = "www/logos/phw.png",
            id = "public-health-wales-logo",
            alt = "Public Health Wales logo - Logo Iechyd Cyhoeddus Cymru"
          )
        ),
        shiny::tags$div(
          class = "col-lg-1 col-sm-5 order-4",
          shiny::img(
            src = "www/logos/welsh-gov.png",
            id = "welsh-government-logo",
            alt = "Welsh Government logo - Logo Llwodraeth Cymru"
          )
        )
      ),
      shiny::tags$div(
        class = "row",
        shiny::tags$div(
          class = "col align-self-end text-right",
          add_language_selection()
        )
      )
    ),
    shiny::fluidPage(
      title = "Welsh Health Equity Solutions Platform",
      theme = bslib::bs_theme(
        version = 4,
        bootswatch = "united",
        fg = "#000000",
        bg = "#FFFFFF",
        primary = phw_blue,
        secondary = phw_pink,
        info = phw_aqua,
        base_font = c("Verdana", "Arial", "sans-serif"),
        heading_font = c("Verdana", "Arial", "sans-serif")
      ),
      lang = "en",
      id = "page", # FIXME: Check if needed?
      add_timeout_warning(),
      add_external_resources(),

      shiny::tags$div(
        id = "main-content-skip",

        shiny::fluidRow(
          shiny::column(
            12,
            shiny::tags$h2(shiny::textOutput("data_explorer_title"))
          ),

          # Choose category ------------------------------
          shiny::column(
            12,
            shiny::selectInput(
              inputId = "category",
              label = tr_pull("select_category", "EN"),
              choices = tr_deframe("^category", "EN"),
              selectize = FALSE
            )
          ),

          # Choose indicator ------------------------------
          shiny::column(
            12,
            shiny::selectInput(
              inputId = "ind_id",
              label = tr_pull("select_ind_label", "EN"),
              choices =
                dplyr::filter(
                  whesApp::indicator_info,
                  .data$category == "outcome" # This is overwritten by updateSelectInput
                ) %>%
                dplyr::select(.data$name, .data$ind_id) %>%
                tibble::deframe(),
              width = "90%",
              selectize = FALSE
            ),
          ),
        ), # End: fluid row,

        # Choose output type ------------------------------
        shiny::fluidRow(
          shiny::tags$div(
            class = "col-lg-3",
            output_radio_buttons(),

            # Choose disag1 ------------------------------
            shiny::selectInput("disag",
                               label = "Please select a grouping",
                               choices = c(
                                 "None" = "None",
                                 "Gender" = "Gender",
                                 "Age" = "Age",
                                 "Deprivation" = "Deprivation",
                                 "Education level" = "Education"
                               ),
                               selected = "None",
                               selectize = FALSE
            ),

            # Choose disag2 ------------------------------
            shiny::selectInput("disag2",
                               label = "Please select a grouping",
                               choices = c(
                                 "Gender" = "Gender",
                                 "Age" = "Age",
                                 "Deprivation" = "Deprivation",
                                 "Education level" = "Education"
                               ),
                               selected = "Age",
                               selectize = FALSE
            ),
            # ci
            shiny::uiOutput("ci_button"),
            shiny::uiOutput("download_plot_button"),
            shiny::uiOutput("download_data_button")
          ),

          # Display plot ------------------------------
          shiny::tags$div(
            class = "col-lg-9 well output-well mt-3 mt-lg-0",
            shiny::tags$div(
              class = "horizontal-scroll-output",
              shiny::plotOutput("plot_window",
                                height = "400px",
                                width = "800px")
            ),
            reactable::reactableOutput("detailed_table"),
            shiny::textOutput("small_numbers")
          )
        ), # End: fluid row,

        # Add spacing ------------------------------
        shiny::br(),

        # Display md text ------------------------------
        shiny::fluidRow(
          shiny::column(
            12,
            shiny::tags$br(),
            shiny::uiOutput("indicator_md")
          )
        ), # End: fluid row,
        shiny::fluidRow(
          shiny::uiOutput("insert_footer")
        )
      ) # end of main-content div
    ) # End: fluid page
  )
}
