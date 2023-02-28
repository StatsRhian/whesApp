#' Create reactable table
#' @param df The data to visualise
#' @param ci Whether to display confidence intervals (logical)
#' @param lang The selected language
#' @return A reactable object

create_reactable = function(df, ci, lang) {
  is_percent = is_percent(unique(df$ind_id))

  # Translate any disaggregate columns
  col_id = which(names(df) %in% whesApp::breakdown_vars)
  for (i in seq_along(col_id)) {
    names(df)[col_id[i]] = tr_pull(
      key = glue::glue("disaggregate_{names(df)[col_id[i]]}"),
      lang = lang
    )
  }

  # Remove columns with NA and drop unnecessary cols
  df = df %>%
    dplyr::select(where(not_all_na)) %>%
    dplyr::select(-.data$ind_id)

  # Format confidence intervals (if CI button selected)
  if (ci) {
    if ("ci_lower" %in% names(df)) {
      if (is_percent) {
        df = dplyr::mutate(df, dplyr::across(
          c(.data$ci_lower, .data$ci_upper),
          ~ scales::percent(round(., 3), accuracy = 0.1)
        ))
      } else {
        df = dplyr::mutate(df, dplyr::across(
          c(.data$ci_lower, .data$ci_upper),
          ~ round(., 0)
        ))
      }
      df =
        df %>%
        tidyr::unite(col = "confidence", .data$ci_lower:.data$ci_upper, sep = " - ") %>%
        dplyr::relocate(.data$confidence, .after = .data$value) %>%
        dplyr::rename_with(~ tr_pull("col_confidence", lang), "confidence")
    }
  } else if ("ci_lower" %in% names(df)) {
    df = df %>%
      dplyr::select(-.data$ci_upper, -.data$ci_lower)
  }

  if (is_percent) {
    table_out =
      df %>%
      reactable::reactable(
        pagination = FALSE,
        columns = list(
          value = reactable::colDef(
            name = tr_pull("col_value", lang),
            align = "center",
            format = reactable::colFormat(percent = TRUE, digits = 1),
            na = "*",
            minWidth = 100
          )
        ),
        defaultColDef = reactable::colDef(
          minWidth = 120
        )
      )
  } else {
    table_out =
      df %>%
      reactable::reactable(
        pagination = FALSE,
        columns = list(
          value = reactable::colDef(
            name = tr_pull("col_value", lang),
            align = "center",
            format = reactable::colFormat(digits = 2),
            na = "*"
          )
        )
      )
  }
  return(table_out)
}
