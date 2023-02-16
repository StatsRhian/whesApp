#' Create barchart
#' @param df The data to plot
#' @param disag1 The first disaggregate
#' @param disag2 The second disaggregate
#' @param ci Whether to display confidence intervals (logical)
#' @param title The plot title
#' @param caption The plot caption
#' @param lang The language to translate into
#' @param labels Vector of possible labels
#' @param plot_width The width of the plot
#' @return The plot object

create_barchart = function(df,
                           disag1,
                           disag2,
                           ci,
                           title = "",
                           caption = "Welsh Health Equity Status 2020",
                           lang = "EN",
                           labels = labels,
                           plot_width = 1000) {
  df =
    df %>%
    dplyr::filter(!is.nan(.data$value))

  d = 0.9
  if (disag1 == "None" && disag2 == "None") {
    g = df %>%
      ggplot2::ggplot(ggplot2::aes(
        x = tr_pull("all", lang),
        y = .data$value
      )) +
      ggplot2::geom_col(fill = phw_blue) +
      ggplot2::xlab("")
  } else if (disag1 != "None" && disag2 == "None") {
    g = df %>%
      ggplot2::ggplot(ggplot2::aes(
        x = !!rlang::sym(disag1),
        y = .data$value,
        fill = !!rlang::sym(disag1)
      )) +
      ggplot2::geom_col()
    g = g %>%
      translate_x_axis(df, disag1, lang = lang, labels = labels) %>%
      translate_fill(df, disag1, lang = lang, labels = labels)
  } else if (disag1 != "None" && disag2 != "None") {
    g = df %>%
      ggplot2::ggplot(ggplot2::aes(
        x = !!rlang::sym(disag2),
        y = .data$value,
        fill = !!rlang::sym(disag1)
      )) +
      ggplot2::geom_col(position = ggplot2::position_dodge(d))
    g = g %>%
      translate_x_axis(df, disag2, lang = lang, labels = labels) %>%
      translate_fill(df, disag1, lang = lang, labels = labels)
  }

  # Add captions & theme
  g = g +
    ggplot2::labs(
      title = stringr::str_wrap(title, width = plot_width / 12.5),
      caption = caption
    ) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        size = 16,
        hjust = 0,
        vjust = 0,
        lineheight = 1.2
      ),
      plot.caption = ggplot2::element_text(
        face = "italic",
        hjust = 1,
        size = 10,
        margin = ggplot2::margin(10, 0, 5, 0),
        lineheight = 1.2
      )
    )

  if (!is.null(ci)) {
    if (!all(is.na(df$ci_lower)) && (ci == TRUE)) {
      g = g +
        ggplot2::geom_errorbar(ggplot2::aes(
          ymin = .data$ci_lower,
          ymax = .data$ci_upper
        ),
        size = 0.4,
        width = 0.3,
        alpha = 0.8,
        position = ggplot2::position_dodge(d)
        )
    }
  }

  if (is_percent(unique(df$ind_id))) {
    g = g +
      ggplot2::scale_y_continuous(
        labels = scales::percent_format(accuracy = 1),
        limits = c(0, 1)
      ) +
      ggplot2::ylab(tr_pull("percent", lang))
  } else {
    g = g + ggplot2::scale_y_continuous(limits = c(0, max(df$ci_upper))) +
      ggplot2::ylab(tr_pull("value", lang))
  }
  return(g)
}
