#' caption_source
#'
#' \code{caption_source} aids in the captioning of infographics. It takes an
#' indicator ID (located within a filtered version of
#' \code{\link{indicator_data}}) and returns the corresponding source ID
#' (located within \code{\link{indicator_info}}). The resulting value is used
#' within \code{\link{tr_pull}} to obtain the full description of the source ID
#' in English or Cymraeg.
#'
#' @param id The indicator ID (from a filtered version of
#' \code{\link{indicator_data}}).
#' @param info Lookup dataset containing the source ID. Defaults to
#' \code{\link{indicator_info}}.
caption_source = function(id, info = whesApp::indicator_info) {
  id %>%
    tibble::enframe(name = NULL, value = "ind_id") %>%
    dplyr::left_join(dplyr::select(info, .data$ind_id, .data$source_id),
      by = "ind_id"
    ) %>%
    dplyr::mutate(source_id = glue::glue("source_{.data$source_id}")) %>%
    dplyr::pull(.data$source_id)
}

#' Get caption
#' @param id indicator id
#' @param lang language
get_caption = function(id, lang) {
  glue::glue(
    tr_pull(whesApp::translate_db,
      key = "caption",
      lang = lang
    ),
    "\n",
    tr_pull(whesApp::translate_db,
      key = caption_source(
        id = id
      ),
      lang = lang
    )
  )
}
