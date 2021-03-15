#' caption_source
#'
#' \code{caption_source} aids in the captioning of infographics. It takes an
#' indicator ID (located within a filtered version of
#' \code{\link{indicator_data}}) and returns the corresponding source ID
#' (located within \code{\link{indicator_info}}). The resulting value is used
#' within \code{\link{tr_pull}} to obtain the full description of the source ID
#' in English or Cymraeg.
#'
#' @param ind The indicator ID (from a filtered version of
#' \code{\link{indicator_data}}).
#' @param info Lookup dataset containing the source ID. Defaults to
#' \code{\link{indicator_info}}.
caption_source = function(ind, info = whesApp::indicator_info) {
  ind %>%
    tibble::enframe(name = NULL, value = "ind_id") %>%
    dplyr::left_join(dplyr::select(info, .data$ind_id, .data$source_id),
                     by = "ind_id") %>%
    dplyr::pull(.data$source_id)
}
