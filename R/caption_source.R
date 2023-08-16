#' caption_source
#'
#' `caption_source` aids in the captioning of infographics. It takes an
#' indicator ID (located within a filtered version of
#' [indicator_data]) and returns the corresponding source ID
#' (located within [indicator_info]). The resulting value is used
#' within [tr_pull()] to obtain the full description of the source ID
#' in English or Cymraeg.
#'
#' @param id The indicator ID (from a filtered version of
#' [indicator_data].
#' @param info Lookup dataset containing the source ID. Defaults to
#' [indicator_info].
caption_source = function(id, info = whesApp::indicator_info) {
  id %>%
    tibble::enframe(name = NULL, value = "ind_id") %>%
    dplyr::left_join(dplyr::select(info, .data$ind_id, .data$source_id),
                     by = "ind_id") %>%
    dplyr::mutate(source_id = glue::glue("source_{.data$source_id}")) %>%
    dplyr::pull(.data$source_id)
}

get_source_url = function(id, info = whesApp::indicator_info) {
  id %>%
    tibble::enframe(name = NULL, value = "ind_id") %>%
    dplyr::left_join(
      dplyr::select(info, .data$ind_id, .data$source_url),
      by = "ind_id"
    ) %>%
    dplyr::pull(.data$source_url)
}

#' Get source text
#' @param id indicator id
#' @param lang language
get_source_text = function(id, lang) {
  date = tr_pull(key = glue::glue("^date_{id}"), lang = lang, search = TRUE)
  source_name = tr_pull(key = caption_source(id), lang = lang)
  source_url = get_source_url(id)
  new_tab = tr_pull("open_new_tab", lang = lang)
  shiny::HTML(glue::glue("{tr_pull(key = 'section_source', lang)}: <a href={source_url} target = '_blank'>{source_name} ({new_tab})</a> ({date})")) # nolint: line_length_linter
}

#' Get caption
#' @param id indicator id
#' @param lang language
get_caption = function(id, lang) {
  glue::glue(
    tr_pull(
      key = "caption",
      lang = lang
    ),
    "\n",
    tr_pull(
      key = caption_source(
        id = id
      ),
      lang = lang
    )
  )
}
