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
    shiny::div(
      style = "text-align: center; color: #fff; background-color: #005d5d; padding: 5px; margin: 0",
      shiny::titlePanel(
        title = shiny::span(
          shiny::img(src = "www/logos/who-euro-white.png", width = "25%", alt = ""),
          shiny::HTML("&emsp;"),
          translateTitleUI("whes_platform"),
          shiny::HTML("&emsp;"),
          shiny::img(src = "www/logos/phw.png", width = "13%", alt = ""),
          shiny::HTML("&emsp;"),
          shiny::img(src = "www/logos/welsh-gov.png", width = "5%", alt = "")
        ),
        windowTitle = "Welsh Health Equity Solutions Platform"
      )
    ),
    shiny::navbarPage(
      title = "",
      id = "page",
      footer = shiny::uiOutput("insert_footer"),
      theme = bslib::bs_theme(
        primary = "#005d5d",
        secondary = "#c60158",
        info = "#669d9d",
        version = 4,
        bootswatch = "united"
      ),
      header = shiny::tagList(
        shiny::tags$div(id = "main-content-skip"),
        add_timeout_warning(),
        add_external_resources()
      ),
      lang = "en",
      shiny::navbarMenu(
        translateTitleUI("data"),
        dataUI("outcome"),
        dataUI("behaviour"),
        dataUI("health"),
        dataUI("income"),
        dataUI("living"),
        dataUI("social"),
        dataUI("employment"),
        shiny::tabPanel(translateTitleUI("data_search"),
          icon = shiny::icon("search"),
          shiny::br(),
          reactable::reactableOutput("indicator_search")
        )
      )
    )
  )
}
