#' Make content table of indicators
#' @param lang EN or CY
create_contents_table = function(lang) {
  whesApp::indicator_info %>%
    dplyr::mutate(name = purrr::map_chr(
      .data$ind_id,
      ~ tr_pull(.x, lang)
    )) %>%
    dplyr::select(.data$name, .data$category) %>%
    reactable::reactable(
      defaultPageSize = 50,
      compact = TRUE,
      searchable = TRUE,
      showPageSizeOptions = TRUE,
      columns = list(
        name = reactable::colDef(name = tr_pull("table_indicator", lang)),
        category = reactable::colDef(
          name = tr_pull("table_category", lang),
          cell = function(value) {
            class = glue::glue("tag ess-cond-{tolower(value)}")
            shiny::div(
              class = class,
              tr_pull(
                glue::glue("title_data_{value}"),
                lang
              )
            )
          }
        )
      )
    )
}
