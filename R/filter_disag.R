#' Filter disaggregate
#' @param df The data to filter
#' @param disag The disaggregation
filter_disag = function(df, disag) {
  keep_vars = whesApp::breakdown_vars[(whesApp::breakdown_vars %in% disag)]
  remove_vars = whesApp::breakdown_vars[!(whesApp::breakdown_vars %in% disag)]

  # Set none disagregates to All
  for (i in seq_along(remove_vars)) {
    df = dplyr::filter(df, !!rlang::sym(remove_vars[[i]]) == "All")
  }

  # Remove "All" case for disagregate
  if (length(keep_vars) > 0) {
    for (i in seq_along(keep_vars)) {
      df = dplyr::filter(df, !!rlang::sym(keep_vars[[i]]) != "All")
    }
  }
  # Remove unneccersary columns
  df = dplyr::select(df, -tidyselect::any_of(remove_vars))
  return(df)
}
