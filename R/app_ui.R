#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @noRd
app_ui = function(request) {
  shiny::tagList(
    shiny::div(
      style = "text-align: center; color: #fff; background-color: #008586; padding: 5px; margin: 0",
      shiny::titlePanel(
        title = shiny::span(
          shiny::img(src = "www/logos/who-euro-white.png", width = "25%"),
          shiny::HTML("&emsp;"),
          translateTitleUI("whes_platform"),
          shiny::HTML("&emsp;"),
          shiny::img(src = "www/logos/phw.png", width = "13%"),
          shiny::HTML("&emsp;"),
          shiny::img(src = "www/logos/welsh-gov.png", width = "5%")
        ),
        windowTitle = "Welsh Health Equity Solutions Platform"
      )
    ),
    shiny::navbarPage(
      title = "",
      id = "page",
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
            .x = whesApp::essential_conditions[3:7],
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
      ),
      # reporting page
      shiny::tabPanel(
        translateTitleUI("report"),
        shiny::br(),
        shiny::br(),
        shiny::fluidPage(
          shiny::h2("Generate Report"),
          shiny::br(),
          shiny::fluidRow(
            shiny::column(
              6,
              shiny::uiOutput("report_md"),
              shiny::br(),
              shiny::uiOutput("generate_report_button")
            ),
            shiny::column(
              6,
              shiny::wellPanel(
                shiny::fluidRow(
                  shiny::column(
                    12,
                    shiny::checkboxGroupInput(
                      "report_conditions",
                      "Please select the essential condition(s) to include in report:",
                      c(
                        "Health Services" = "health",
                        "Income Security and Social Protection" = "income",
                        "Living Conditions" = "living",
                        "Social and Human Capital" = "social",
                        "Employment and Working Conditions" = "employment"
                      )
                    ),
                    shiny::br(),
                    shiny::checkboxGroupInput(
                      "report_info",
                      "Please select the type(s) of information to include in report:",
                      c(
                        "Health Economics" = "economics",
                        "Policies" = "policy",
                        "International Evidence" = "evidence",
                        "Un-met Needs" = "needs",
                        "Solutions" = "solutions"
                      )
                    )
                  ) # end column
                ) # end fluidrow
              ), # end wellpanel
            ) # end column
          )
        ) # end fluidpage
      ),
      # additional tabs
      navbarPagesUI("economics"),
      navbarPagesUI("policy"),
      navbarPagesUI("evidence"),
      navbarPagesUI("needs"),
      navbarPagesUI("solutions")
    )
  )
}
