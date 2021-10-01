#' Create barchart
#' @param df The data to plot
#' @param disag1 The first disagregate
#' @param disag2 The second disagregate
#' @param ci Whether to display confidence intervals (logical)
#' @param title The plot title
#' @param caption The plot caption
#' @param lang The language to translate into
#' @param labels Vector of possible labels
#' @return The plot object

create_barchart = function(df,
                           disag1,
                           disag2,
                           ci,
                           title = "",
                           caption = "Welsh Health Equity Status 2020",
                           lang = "EN",
                           labels = labels) {

  df =
    df %>%
    dplyr::filter(!is.nan(.data$value))

  d = 0.9
  if (disag1 == "None" & disag2 == "None") {
    g = df %>%
      ggplot2::ggplot(ggplot2::aes(x = tr_pull(whesApp::translate_db, "all", lang),
                                   y = .data$value)) +
      ggplot2::geom_col(fill = "#1B9E77") +
      ggplot2::xlab("")
  } else if (disag1 != "None" & disag2 == "None") {
    g = df %>%
      ggplot2::ggplot(ggplot2::aes(x = !!rlang::sym(disag1),
                                   y = .data$value,
                                   fill = !!rlang::sym(disag1))) +
      ggplot2::geom_col()
    g = g %>%
      translate_x_axis(df, disag1, lang = lang, labels = labels) %>%
      translate_fill(df, disag1, lang = lang, labels = labels)
  } else if (disag1 != "None" & disag2 != "None") {
    g = df %>%
      ggplot2::ggplot(ggplot2::aes(x = !!rlang::sym(disag2),
                                   y = .data$value,
                                   fill = !!rlang::sym(disag1))) +
      ggplot2::geom_col(position = ggplot2::position_dodge(d))
    g = g %>%
      translate_x_axis(df, disag2, lang = lang, labels = labels) %>%
      translate_fill(df, disag1, lang = lang, labels = labels)
  }

  # Add captions & theme
  g = g +
    ggplot2::labs(title = wrapper(title, width = 80),
                  caption = caption) +
    ggplot2::theme_minimal(base_size = 14)

  if (!is.null(ci)) {
    if (!all(is.na(df$ci_lower)) & (ci == TRUE)) {
      g = g +
        ggplot2::geom_errorbar(ggplot2::aes(ymin = .data$ci_lower,
                                            ymax = .data$ci_upper),
                               size = 0.4,
                               width = 0.3,
                               alpha = 0.8,
                               position = ggplot2::position_dodge(d))
    }
  }

  if (unique(df$type) == "percent") {
    g = g +
      ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
      ggplot2::ylab(tr_pull(whesApp::translate_db, "percent", lang))
  } else {
    g = g + ggplot2::ylab(tr_pull(whesApp::translate_db, "value", lang))

  }
  return(g)
}
