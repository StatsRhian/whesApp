#' Translate reactable options
#' Translate the default levels of a reactable table
#' @param lang EN or CY
translate_reactable_options = function(lang) {
  options(reactable.language = reactable::reactableLang(
    searchPlaceholder = tr_pull(whesApp::translate_db, "table_search", lang),
    noData = tr_pull(whesApp::translate_db, "table_no_entries", lang),
    pageInfo = tr_pull(whesApp::translate_db, "table_entries", lang),
    pageSizeOptions = tr_pull(whesApp::translate_db, "table_rows", lang),
    pagePrevious = "\u276e",
    pageNext = "\u276f",
    pagePreviousLabel = tr_pull(whesApp::translate_db, "table_previous", lang),
    pageNextLabel = tr_pull(whesApp::translate_db, "table_next", lang)
  ))
  return(invisible(TRUE))
}
