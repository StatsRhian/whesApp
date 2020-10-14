policiesUI = function(id, cat){
  ns = NS(id)

fluidPage(
  fluidRow(
    column(12,
           tags$br(),
           uiOutput(ns("policy_md"))
    )
  ) # End: fluid row 
) # End: fluid page
}

policies = function(input, output, session, lang, cat){
  
  output$policy_md = reactive({
    filename = glue("www/content/{lang()}/policies/policy-{cat}.md")
      includeMarkdown(filename)
  })
}