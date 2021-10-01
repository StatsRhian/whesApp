#' Prep Waffle
#' Prepare the waffle plot
#' @param df The selected data
#' @param disag The grouping to disaggregate (can be None)
#' @return Prepped data, ready for plotting
prep_waffle = function(df, disag) {

  df =
    df %>%
    dplyr::rename(Yes = .data$value) %>%
    dplyr::mutate(No = 1 - .data$Yes)  %>%
    dplyr::select(-.data$type, -.data$ci_lower, -.data$ci_upper, -.data$ind_id) %>%
    purrr::when(
      (disag == "None") ~ tidyr::pivot_longer(.,
                                              cols = tidyselect::everything(),
                                              names_to = "Response",
                                              values_to = "Percent"),
      ~  tidyr::pivot_longer(.,
                             cols = -!!rlang::sym(disag),
                             names_to = "Response",
                             values_to = "Percent")
    ) %>%
    dplyr::mutate(Response = forcats::as_factor(.data$Response)) %>%
    dplyr::mutate(Percent = round(.data$Percent * 100, 0))

  # For facetted - add Yes percent to factor
  if (disag != "None") {
    levels = df %>% dplyr::pull({{disag}}) %>% unique() %>% as.character()

    names(levels) =
      df %>%
      dplyr::filter(.data$Response == "Yes") %>%
      dplyr::mutate(!!rlang::sym(disag) := paste0(!!rlang::sym(disag),
                                                  " (", .data$Percent, "%", ")")) %>%
      dplyr::pull({{disag}}) %>%
      unique()

    df = df %>%
      dplyr::mutate(!!rlang::sym(disag) := forcats::fct_recode(!!rlang::sym(disag), !!!levels))
  }
  return(df)
}

#' Create waffle
#' Create waffle plot on selected data
#' @param df The data to plot
#' @param disag The grouping to disaggregate (can be None)
#' @param title The title for the plot
#' @param caption The caption for the plot
#' @param legend_labels The legend labels
#' @param plot_width The width of the plot
#' @param lang The langauge to translate into
create_waffle = function(df, disag,
                         title = "",
                         caption = "Welsh Health Equity Status 2020",
                         legend_labels = c("Yes", "No"),
                         plot_width = 1.6,
                         lang = "EN") {

  if (disag == "None") {
    legend_labels = glue::glue("{legend_labels} ({df$Percent}%)")
  }

  waffle =
    df %>%
    ggplot2::ggplot(ggplot2::aes(values = .data$Percent,
                                 label = .data$Response,
                                 col = .data$Response)) +
    waffle::geom_pictogram(
      n_rows = 10, size = 9.5,
      flip = TRUE,
      family = "Font Awesome 5 Free Solid"
    ) +
    ggplot2::scale_color_manual(
      name = NULL,
      values = c("#c60158", "grey"),
      labels = legend_labels
    ) +
    waffle::scale_label_pictogram(
      name = NULL,
      values = c("user", "user"),
      labels = legend_labels
    ) +
    ggplot2::labs(
      title = wrapper(title, width = 50 * plot_width),
      caption = caption
    ) +
    hrbrthemes::theme_ipsum(grid = "", base_size = 14) +
    waffle::theme_enhance_waffle() +
    ggplot2::theme(plot.title = ggplot2::element_text(size = 16,
                                                      hjust = 0,
                                                      vjust = 0))

  # DISAG
  if (disag == "None") {
    waffle =
      waffle +
      ggplot2::coord_equal(xlim = c(1, 10),
                           ylim = c(1, 10))
  } else {
    waffle =
      waffle +
      ggplot2::facet_grid(cols = dplyr::vars(!!rlang::sym(disag))) +
      ggplot2::scale_x_discrete(expand = c(0, 0)) +
      ggplot2::scale_y_discrete(expand = c(0, 0)) +
      ggplot2::coord_equal()
  }
  return(waffle)
}

