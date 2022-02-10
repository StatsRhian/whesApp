#' Access files in the current app
#' @param ... character vectors, specifying subdirectory and file(s)
#' within your package. The default, none, returns the root of the app.
#' @noRd

app_sys = function(...) {
  system.file(..., package = "whesApp")
}

not_all_na = function(x) any(!is.na(x))

#' On-click
#' @param category The indicator category
#' Function to create on-click event for images
onclick_tabset = function(category) {
  session = shiny::getDefaultReactiveDomain()
  shinyjs::onclick(
    glue::glue("img_{category}"),
    shiny::updateNavlistPanel(session,
      inputId = "tab_categories",
      selected = category
    )
  )
}

#' Get indicator type
#' @param id Indicator id
get_ind_type = function(id) {
  whesApp::indicator_info %>%
    dplyr::filter(.data$ind_id == id) %>%
    dplyr::pull(.data$type)
}

#' Calculate multiplier for plot settings
#' @param df The indicator data set
#' @param id The indicator id
#' @param disag The selected disaggregate
get_plot_width = function(df, id, disag) {
  if (get_ind_type(id) == "percent") {
    if (disag == "None") {
      n = 575
    } else {
      n = 1000
    }
  } else {
    n = 575
  }
  return(n)
}

#' Wrapper
#' @param x The string to wrap
#' @param ... Optional parameters to pass to strwrap()
#' @return Wrapped string
wrapper = function(x, ...) {
  paste(strwrap(x, ...), collapse = "\n")
}
