#' Update database
#' @param indicator_info The indicator information
#' @param translate_db The translation database
#' @return The updated database
#' This function is only used in development when
#' there is an update to the indicators.

update_db = function(indicator_info, translate_db) {
  info_titles = indicator_info$name
  tran_titles =
    translate_db %>%
    dplyr::filter(stringr::str_detect(.data$key, "^ind_[0-9]{3}$")) %>%
    dplyr::pull(.data$EN)
  missing = which(!(info_titles %in% tran_titles))

  if (length(missing > 0)) {
    new = info_titles[missing]
    new_id = indicator_info$ind_id[missing]

    for (i in seq_along(new_id)) {
      id = new_id[i]
      trans_row = stringr::str_which(translate_db$key, glue::glue("^{id}"))
      if (length(trans_row) != 1) {
        stop("Error in updating translation db")
      }
      translate_db$EN[trans_row] = new[i]
    }
  }
  return(translate_db)
}

#' Pull translation
#' @param translate_db The translation database
#' @param key The phrase to translate
#' @param lang The language to translate into
#' @param search Whether to search for many matches or just one
#' @return Translation
tr_pull = function(key, lang, search = FALSE, translate_db = whesApp::translate_db) {
  if (search) {
    translate_db %>%
      dplyr::filter(stringr::str_detect(key, {{ key }})) %>%
      dplyr::pull({{ lang }})
  } else {
    translate_db %>%
      dplyr::filter(key == {{ key }}) %>%
      dplyr::pull({{ lang }})
  }
}

#' Translate
#' @param df The table to translate
#' @param translate_db The translation database
#' @param lang The language to translate into (EN or CY)
tr_table = function(df, lang, translate_db = whesApp::translate_db) {
  if (lang == "CY") {
    df_breakdown = which(whesApp::breakdown_vars %in% names(df))

    for (i in seq_along(df_breakdown)) {
      disag = whesApp::breakdown_vars[df_breakdown[i]]
      mini_trans =
        translate_db %>%
        dplyr::filter(stringr::str_detect(.data$key, glue::glue("^disag_{disag}")))

      disag_levels = levels(df %>% dplyr::pull({{ disag }}))
      levels_cy = mini_trans$CY[match(disag_levels, mini_trans$EN)]

      df = suppressWarnings(
        df %>%
          dplyr::left_join(mini_trans, by = stats::setNames("EN", disag)) %>%
          dplyr::select(-.data$key, -{{ disag }}) %>%
          dplyr::rename({{ disag }} := "CY") %>%
          dplyr::relocate({{ disag }}, .before = .data$value) %>%
          dplyr::mutate({{ disag }} := forcats::fct_relevel(
            .f = forcats::as_factor(!!rlang::sym(disag)),
            levels_cy
          )) # keep level order
      )
    }
  }
  return(df)
}

#' TR deframe indicators
#' @param key_group The key phrase
#' @param lang The language to translate into
#' @param translate_db The translation database
#' @param indicator_info The indicator information
#' @return The translation
tr_deframe_inds = function(key_group, lang,
                           translate_db = whesApp::translate_db,
                           indicator_info = whesApp::indicator_info) {
  available_inds =
    indicator_info %>%
    dplyr::filter(.data$category == key_group) %>%
    dplyr::pull(.data$ind_id)

  pattern = glue::glue("^({paste(available_inds, collapse = '|')})$")

  translate_db %>%
    dplyr::filter(stringr::str_detect(.data$key, pattern)) %>%
    dplyr::select({{ lang }}, .data$key) %>%
    tibble::deframe()
}

#' Translation deframe
#' @param translate_db The translation database
#' @param pattern The pattern to search for
#' @param lang The language to translate into
# indented for the search filters
# The key is stripped of everything before the _first underscore_
# E.g Searching "disaggregate" returns "None", "Sex" (not "disaggregate_None")

tr_deframe = function(pattern, lang, translate_db = whesApp::translate_db) {
  translate_db %>%
    dplyr::filter(stringr::str_detect(.data$key, pattern)) %>%
    dplyr::mutate(
      key = stringr::str_extract(.data$key, "_.*"),
      key = stringr::str_remove(.data$key, "_")
    ) %>%
    dplyr::select({{ lang }}, .data$key) %>%
    tibble::deframe()
}
