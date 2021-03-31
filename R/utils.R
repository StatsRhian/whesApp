#' Access files in the current app
#' @param ... character vectors, specifying subdirectory and file(s)
#' within your package. The default, none, returns the root of the app.
#' @noRd

app_sys = function(...) {
  system.file(..., package = "whesApp")
}

#' On-click
#' @param category The indicator category
#' @param session the shiny session
#' Function to create on-click event for images
onclick_tabset = function(category, session) {
  shinyjs::onclick(glue::glue("img_{category}"),
                   shiny::updateNavlistPanel(session,
                                             inputId = "tab_categories",
                                             selected = category))
}
