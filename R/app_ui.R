#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @noRd
app_ui = function(request) {
  shiny::fluidPage(
    title = "",
    lang = "en",
    id = "page", # FIXME: Check if needed?
    shiny::tags$a(
      id = "skiplink",
      href = "#main-content-skip",
      "Skip to Main Content"
    ),
    add_timeout_warning(),
    add_external_resources(),
    # header
    shiny::div(
      style = "text-align: center; color: #fff; background-color: #005d5d; padding: 5px; margin: 0", # FIXME: Move to CSS
      shiny::titlePanel(
        title = shiny::span(
          shiny::img(src = "www/logos/who-euro-white.png", width = "25%", alt = ""),
          shiny::HTML("&emsp;"),
          shiny::uiOutput("translated_title", inline = TRUE),
          shiny::HTML("&emsp;"),
          shiny::img(src = "www/logos/phw.png", width = "13%", alt = ""),
          shiny::HTML("&emsp;"),
          shiny::img(src = "www/logos/welsh-gov.png", width = "5%", alt = ""),
          shiny::radioButtons("lan",
                              label = "",
                              choices = c("English" = "EN", "Cymraeg" = "CY"),
                              width = "5%") # FIXME: styling, inline, alt text
        ),
        windowTitle = "Welsh Health Equity Solutions Platform"
      ),
    ),

    shiny::tags$div(
      id = "main-content-skip",

      # Add spacing ------------------------------
      shiny::br(),

      # Choose category ------------------------------
      shiny::fluidRow(
        shiny::column(
          12,
          shiny::selectInput(
            inputId = "category",
            label = tr_pull("select_category", "EN"),
            choices = tr_deframe("^category", "EN")
          ),
        ),
      ), # End: fluid row,


      # Choose indicator ------------------------------
      shiny::fluidRow(
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
              dplyr::select(name, ind_id) %>%
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
}
