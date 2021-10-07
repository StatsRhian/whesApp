#' Calculate disaggregates
#' Calculate which disaggregates are available for all indicators
#' @param id The selected indicator
#' @return The available disaggregates
calc_disag_vars = Vectorize(function(id) {
  disags =
    indicator_data %>%
    dplyr::filter(ind_id == id) %>%
    dplyr::summarise(dplyr::across(
      tidyselect::all_of(whesApp::breakdown_vars),
      dplyr::n_distinct
    )) %>%
    tidyr::pivot_longer(cols = tidyselect::everything()) %>%
    dplyr::filter(value > 1) %>%
    dplyr::pull(name)

  if (identical(disags, character(0))) {
    disags = "None"
  } else {
    disags = c("None", disags)
  }
  return(list(disags))
},
USE.NAMES = FALSE
)
