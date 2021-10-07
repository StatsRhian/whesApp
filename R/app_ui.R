#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @noRd
app_ui = function(request) {
  shiny::tagList(
    shiny::navbarPage(
      title = shiny::textOutput("whes_title"),
      theme = bslib::bs_theme(
        primary = "#1A5D7E",
        secondary = "#c60158",
        version = 4,
        bootswatch = "minty"
      ),
      add_external_resources(),
      shiny::navlistPanel(
        id = "tab_categories",
        widths = c(2, 10),
        shiny::tabPanel(shiny::uiOutput("overview_tab_title", inline = TRUE),
          icon = shiny::icon("home"),
          shiny::br(),
          shiny::div(
            purrr::map(
              .x = whesApp::cat_df$catID[3:7],
              .f = ~ shiny::img(
                src = glue::glue("www/images/{.x}.png"),
                height = "200px",
                id = glue::glue("img_{.x}"),
                style = "cursor:pointer;"
              )
            ),
            style = "text-align: center;"
          ),
          shiny::br(),
          shiny::uiOutput("intro_md"),
          reactable::reactableOutput("indicator_search")
        ),
        shiny::tabPanel(shiny::uiOutput("policies", inline = TRUE),
          icon = shiny::icon("file-contract"),
          shiny::br(),
          shiny::uiOutput("policy_md")
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
