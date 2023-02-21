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
          shiny::titlePanel(
            shiny::textOutput("translated_title", inline = TRUE),
            windowTitle = "Welsh Health Equity Solutions Platform"
          )
        ),
        shiny::tags$div(
          class = "col-lg-4 col-sm-12 order-1",
          shiny::img(src = "www/logos/who-euro-white.png", alt = "") # FIXME: Alt text needed
        ),
        shiny::tags$div(
          class = "col-lg-2 col-sm-7 order-3",
          shiny::img(src = "www/logos/phw.png", alt = "") # FIXME: Alt text needed
        ),
        shiny::tags$div(
          class = "col-lg-1 col-sm-5 order-4",
          shiny::img(src = "www/logos/welsh-gov.png", alt = "") # FIXME: Alt text needed
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
      title = NULL,
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
            shiny::tags$h1(shiny::textOutput("data_explorer_title"))
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
          shiny::column(
            3,
            shiny::radioButtons(
              inputId = "output_type",
              label = tr_pull("select_output_type", "EN"),
              choices = c(
                "Infographic" = "infographic",
                "Bar chart" = "barchart",
                "Table" = "table"
              ),
              width = "100%"
            ),

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
          shiny::column(
            9,
            shiny::wellPanel(
              shiny::fluidRow(shiny::column(
                12,
                style = "height:400px;",
                shiny::plotOutput("plot_window"),
                reactable::reactableOutput("detailed_table", height = "400px")
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
            shiny::textOutput("small_numbers")
          )
        ), # End: fluid row

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
