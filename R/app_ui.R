#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    shiny::navbarPage(title = shiny::textOutput("whes_title"),
                      theme = bslib::bs_theme(primary = "#1A5D7E",
                                              secondary = "#c60158",
                                              version = 4,
                                              bootswatch = "minty"),
                      golem_add_external_resources(),
                      shiny::navlistPanel(
                        id = "tab_categories",
                        widths = c(2, 10),
                        shiny::tabPanel(shiny::uiOutput("overview_tab_title", inline = TRUE),
                                        icon = shiny::icon("home"),
                                        shiny::br(),
                                        shiny::div(
                                          purrr::map(.x =  whesApp::cat_df$catID[3:7],
                                                     .f = ~shiny::img(src = glue::glue("www/icons/{.x}.png"),
                                                                      height = "200px",
                                                                      id = .x,
                                                                      style = "cursor:pointer;")),
                                          style = "text-align: center;"
                                        ),
                                        shiny::br(),
                                        shiny::uiOutput("intro_md"),
                                        reactable::reactableOutput("indicator_search")
                        ),
                        categoryPanelUI("wellbeing"),
                        categoryPanelUI("morbidity"),
                        categoryPanelUI("health"),
                        categoryPanelUI("income"),
                        categoryPanelUI("living"),
                        categoryPanelUI("social"),
                        categoryPanelUI("employment")
                      )
    )
  )
}
#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @noRd
golem_add_external_resources <- function() {
  golem::add_resource_path(
    "www",
    app_sys("app/www")
  )
  tags$head(
    shinyjs::useShinyjs(),
    shiny::tags$script(type = "text/javascript", src = "logo.js"),
    shiny::tags$script(shiny::HTML('Shiny.addCustomMessageHandler("changetitle", function(x) {document.title=x});')),
    shiny::tags$link(rel = "stylesheet", type = "text/css", href = "phw-style.css"),
    shiny::tags$style(type = "text/css",
                      ".shiny-output-error { visibility: hidden; }",
                      ".shiny-output-error:before { visibility: hidden; }",
    ),
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "whesApp"
    )
  )
}
