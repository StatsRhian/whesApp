#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @noRd
app_ui = function(request) {
  shiny::tagList(
    shiny::navbarPage(
      title = shiny::textOutput("whes_title"),
      position = c("fixed-top"),
      shiny::tags$style(type = "text/css", "body {padding-top: 70px;}"),
      theme = bslib::bs_theme(
        primary = "#008586",
        secondary = "#c60158",
        success = "#c60158",
        version = 4,
        bootswatch = "flatly"
      ),
      shiny::tabPanel(shiny::uiOutput("overview_tab_title", inline = TRUE),
                      shiny::br(),
                      shiny::br(),
                      shiny::div(
                        purrr::map(
                          .x = whesApp::cat_df$catID[3:7],
                          .f = ~ shiny::img(
                            src = glue::glue("www/images/{.x}.png"),
                            height = "250px",
                            id = glue::glue("img_{.x}"),
                            style = "cursor:pointer;"
                          )
                        ),
                        style = "text-align: center;"
                      ),
                      shiny::br(),
                      shiny::uiOutput("intro_md")
      ),
      shiny::navbarMenu("Data Explorer",
                   dataUI("wellbeing"),
                   dataUI("morbidity"),
                   dataUI("health"),
                   dataUI("income"),
                   dataUI("living"),
                   dataUI("social"),
                   dataUI("employment"),
                   shiny::tabPanel(shiny::uiOutput("search_tab_title", inline = TRUE),
                                   icon = shiny::icon("search"),
                                   shiny::br(),
                                   reactable::reactableOutput("indicator_search")
                   )
                 ),
      shiny::tabPanel(shiny::uiOutput("policies", inline = TRUE),
                      shiny::br(),
                      shiny::uiOutput("policy_md")
      ),
      shiny::tabPanel("Health Economics"),
      shiny::tabPanel("International Evidence"),
      shiny::tabPanel("Un-met needs"),
      shiny::tabPanel("Solutions"),
      add_external_resources()
    )
  )
}
