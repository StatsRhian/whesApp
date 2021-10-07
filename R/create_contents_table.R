#' Make content table of indicators
#' @param lang EN or CY
create_contents_table = function(lang) {
  whesApp::indicator_info %>%
    dplyr::mutate(name = purrr::map2_chr(
      .data$ind_id,
      .data$category,
      ~ tr_pull(whesApp::translate_db, glue::glue("{.y}_{.x}"), lang)
    )) %>%
    dplyr::mutate(category = purrr::map_chr(
      .data$category,
      ~ tr_pull(whesApp::translate_db, glue::glue("category_{.x}"), lang)
    )) %>%
    dplyr::select(.data$name, .data$category) %>%
    reactable::reactable(
      defaultPageSize = 10,
      compact = TRUE,
      searchable = TRUE,
      showPageSizeOptions = TRUE,
      columns = list(
        name = reactable::colDef(name = tr_pull(whesApp::translate_db, "table_indicator", lang)),
        category = reactable::colDef(name = tr_pull(whesApp::translate_db, "table_category", lang))
      ),
      defaultColDef = reactable::colDef(
        align = "left",
        headerStyle = list(background = "#f7f7f8")
      )
    )
}
