#' Translate reactable options
#' Translate the default levels of a reactable table
#' @param lang EN or CY
translate_reactable_options = function(lang) {
  options(reactable.language = reactable::reactableLang(
    searchPlaceholder = tr_pull("table_search", lang),
    noData = tr_pull("table_no_entries", lang),
    pageInfo = tr_pull("table_entries", lang),
    pageSizeOptions = tr_pull("table_rows", lang),
    pagePrevious = "\u276e",
    pageNext = "\u276f",
    pagePreviousLabel = tr_pull("table_previous", lang),
    pageNextLabel = tr_pull("table_next", lang)
  ))
  return(invisible(TRUE))
}
