#' Replicate dataframe
#' Function to replicate data frame
#' @param x the data frame to replicate
#' @param times the number of replications
rep_df = function(x, times) {
  as.data.frame(lapply(x, rep, times = times))
}

#' Prepare the waffle plot
#' @param df The selected data
#' @param disag The grouping to disaggregate (can be None)
#' @return Prepped data, ready for plotting
prep_waffle = function(df, disag) {
  df =
    df %>%
    dplyr::rename(Yes = .data$value) %>%
    dplyr::mutate(No = 1 - .data$Yes) %>%
    dplyr::select(-.data$ci_lower, -.data$ci_upper, -.data$ind_id) %>%
    purrr::when(
      (disag == "None") ~ tidyr::pivot_longer(.,
        cols = tidyselect::everything(),
        names_to = "Response",
        values_to = "Percent"
      ),
      ~ tidyr::pivot_longer(.,
        cols = -!!rlang::sym(disag),
        names_to = "Response",
        values_to = "Percent"
      )
    ) %>%
    dplyr::mutate(Response = forcats::as_factor(.data$Response)) %>%
    dplyr::mutate(Percent = round(.data$Percent * 100, 0))

  # format data to work with waffle
  if (disag != "None") {
    levels = df %>%
      dplyr::pull({{ disag }}) %>%
      unique()
    # make data frame
    df_new = rep_df(expand.grid(x = 1:10, y = 1:10), length(levels)) %>%
      dplyr::mutate(
        label = rep("\uf007", times = 100 * length(levels)),
        disag_cat = rep(levels, each = 100),
        type = rep(df$Response, times = df$Percent)
      )
    # define labels for facets
    facet_labs = df_new %>%
      dplyr::group_by(.data$disag_cat, .data$type) %>%
      dplyr::summarise(n = dplyr::n()) %>%
      dplyr::mutate(facet_label = paste0(.data$disag_cat, " (", .data$n, "%)")) %>%
      dplyr::filter(.data$type == "Yes")
    facet_labs_f = facet_labs %>%
      dplyr::mutate(facet_label_f = factor(.data$facet_label,
        levels = .data$facet_label[order(facet_labs$disag_cat)]
      )) %>%
      dplyr::select(.data$disag_cat, .data$facet_label_f)
    # join labels
    df_new = dplyr::left_join(df_new, facet_labs_f, by = "disag_cat")
  } else {
    df_new = expand.grid(x = 1:10, y = 1:10) %>%
      dplyr::mutate(
        label = rep("\uf007", times = 100),
        type = rep(df$Response, times = df$Percent),
        Percent = rep(df$Percent, times = df$Percent)
      )
  }
  return(df_new)
}

# set key for legend
draw_key_user = function(data, params, size) {
  grid::textGrob(
    label = "\uf007",
    x = c(0.5),
    y = c(0.5),
    gp = grid::gpar(
      col = scales::alpha(data$colour, data$alpha),
      fontfamily = "fontawesome-webfont",
      fontsize = 7 * .pt
    )
  )
}

# helper function
set_draw_key = function(geom, draw_key = NULL) {
  if (is.null(draw_key)) {
    return(geom)
  }
  if (is.character(draw_key)) {
    draw_key = paste0("draw_key_", draw_key)
  }
  draw_key = match.fun(draw_key)

  ggproto("", geom, draw_key = draw_key)
}

# version of `geom_text()` with modifiable draw key
geom_user = function(mapping = NULL, data = NULL, stat = "identity",
                     position = "identity", na.rm = FALSE,
                     show.legend = NA, inherit.aes = TRUE, draw_key = NULL,
                     ...) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = set_draw_key(GeomText, draw_key),
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

#' Create waffle
#' Create waffle plot on selected data
#' @param df The data to plot
#' @param disag The grouping to disaggregate (can be None)
#' @param title The title for the plot
#' @param caption The caption for the plot
#' @param legend_labels The legend labels
#' @param plot_width The width of the plot
create_waffle = function(df, disag,
                         title = "",
                         caption = "Welsh Health Equity Status 2020",
                         legend_labels = c("Yes", "No"),
                         plot_width = 1000) {
  waffle = ggplot2::ggplot(df, ggplot2::aes(x = .data$x, y = .data$y, label = .data$label, colour = .data$type)) +
    # create plot
    geom_user(
      family = "fontawesome-webfont",
      size = c(7, 5)[(length(unique(df$disag_cat)) > 3) + 1],
      draw_key = "user"
    ) +
    ggplot2::coord_equal(
      xlim = c(1, 10),
      ylim = c(10, 1)
    ) +
    # add titles
    ggplot2::labs(
      title = stringr::str_wrap(title, width = plot_width / 12.5),
      caption = caption
    ) +
    # add themes
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        size = 16,
        hjust = 0,
        vjust = 0,
        margin = ggplot2::margin(10, 0, 10, 0),
        lineheight = 1.2
      ),
      plot.caption = ggplot2::element_text(
        face = "italic",
        hjust = 1,
        size = 10,
        lineheight = 1.2
      ),
      legend.text = ggplot2::element_text(margin = margin(t = 15, b = 15, unit = "pt"))
    )
  if (disag == "None") {
    waffle = waffle +
      ggplot2::scale_colour_manual(
        name = NULL,
        values = c(phw_pink, waffle_no),
        labels = paste(legend_labels, " (", unique(df$Percent), "%)", sep = "")
      )
    waffle
  } else {
    waffle = waffle +
      ggplot2::facet_wrap(~facet_label_f,
        nrow = 1,
        labeller = ggplot2::labeller(facet_label_f = ggplot2::label_wrap_gen(width = 20))
      ) +
      ggplot2::scale_colour_manual(
        name = NULL,
        values = c(phw_pink, waffle_no),
        labels = legend_labels
      ) +
      ggplot2::theme(
        plot.title.position = "plot",
        panel.spacing = ggplot2::unit(1.5, "lines"),
        plot.margin = ggplot2::unit(c(0.5, 0.5, 0.5, 0.5), "cm"),
        strip.text = ggplot2::element_text(
          face = "italic", hjust = 0, size = 10,
          margin = margin(15, 5, 15, 0)
        )
      )
    waffle
  }
}
