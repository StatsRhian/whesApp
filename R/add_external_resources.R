#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
add_external_resources = function() {
  shiny::addResourcePath(
    "www", app_sys("app/www")
  )
  shiny::singleton(
    shiny::tags$head(
      fontawesome::fa_html_dependency(),
      shinyjs::useShinyjs(),
      shiny::tags$script(type = "text/javascript", src = "www/whesApp.js"),
      shiny::tags$link(rel = "stylesheet", type = "text/css", href = "www/phw-style.css"),
      shiny::tags$style(
        type = "text/css",
        ".shiny-output-error { visibility: hidden; }",
        ".shiny-output-error:before { visibility: hidden; }"
      )
    )
  )
}
