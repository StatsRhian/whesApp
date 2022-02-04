#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @noRd
app_ui = function(request) {
  shiny::tagList(
    shiny::div(style = "text-align: center; color: #fff; background-color: #008586; padding: 10px; margin: 0",
               shiny::titlePanel(
                  title = shiny::span(
                    translateTitleUI("whes_platform")
                    )
              )
    ),
    shiny::navbarPage(
      title = "",
      theme = bslib::bs_theme(
        primary = "#008586",
        secondary = "#c60158",
        version = 4,
        bootswatch = "united"
      ),
      header = add_external_resources(),
      shiny::tabPanel(
        translateTitleUI("overview"),
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
      shiny::navbarMenu(
        translateTitleUI("data"),
        dataUI("wellbeing"),
        dataUI("morbidity"),
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
      ),
      navbarPagesUI("policy"),
      navbarPagesUI("economics"),
      navbarPagesUI("evidence"),
      navbarPagesUI("needs"),
      navbarPagesUI("solutions")
    )
  )
}
