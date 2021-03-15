policiesUI = function(id, cat) {
  ns = shiny::NS(id)

shiny::fluidPage(
  shiny::fluidRow(
    shiny::column(12,
           shiny::tags$br(),
           shiny::uiOutput(ns("policy_md"))
    )
  ) # End: fluid row
) # End: fluid page
}

policies = function(input, output, session, lang, cat) {

  output$policy_md = shiny::reactive({
    filename = app_sys(glue::glue("app/www/content/{lang()}/policies/policy-{cat}.md"))
      shiny::includeMarkdown(filename)
  })
}
