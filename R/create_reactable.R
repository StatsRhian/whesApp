#' Create reactable table
#' @param df The data to visualise
#' @param lang The selected language
#' @return A reactable object

create_reactable = function(df, lang) {
  type = unique(df$type)

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
    dplyr::select(where(not_all_na))  %>%
    dplyr::select(-.data$ind_id, -type)

  # Format confidence intervals
  if ("ci_lower" %in% names(df)) {
    if (type == "percent") {
      df = dplyr::mutate(df, dplyr::across(
        c(.data$ci_upper, .data$ci_lower),
        ~ scales::percent(round(., 2))
      ))
    } else {
      df = dplyr::mutate(df, dplyr::across(
        c(.data$ci_upper, .data$ci_lower),
        ~ round(., 0)
      ))
    }
    df =
      df %>%
      tidyr::unite(col = "confidence", .data$ci_lower:.data$ci_upper, sep = " - ") %>%
      dplyr::relocate(.data$confidence, .after = .data$value) %>%
      dplyr::rename_with(~ tr_pull("col_confidence", lang), "confidence")
  }

  if (type == "percent") {
    table_out =
      df %>%
      reactable::reactable(
        pagination = FALSE,
        columns = list(
          value = reactable::colDef(
            name = tr_pull("col_value", lang),
            format = reactable::colFormat(percent = TRUE, digits = 1),
            na = "*"
          )
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
            format = reactable::colFormat(digits = 2),
            na = "*"
          )
        )
      )
  }
  return(table_out)
}
