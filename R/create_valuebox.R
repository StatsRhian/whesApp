#' Prep Value Box
#' @param df The data to visualise
#' @param lang Language
#' @param id Essential condition
prep_valuebox = function(df, id, lang = "EN") {
  df %>%
    dplyr::mutate(label = tr_pull(key = unique(df$ind_id), lang = lang)) %>%
    dplyr::mutate(label = wrapper(.data$label, 50)) %>%
    dplyr::mutate(icon = app_sys(glue::glue("app/www/images/bw/{id}.png"))) %>%
    dplyr::mutate(value = format(round(.data$value, 2), big.mark = ",")) %>%
    dplyr::mutate(value = ifelse(stringr::str_detect(.data$label, "\U00A3"),
      glue::glue("\U00A3{value}"), .data$value
    ))
}

#' Create Value Box
#' @param df The data to visualise
#' @inheritParams create_barchart
#' @return The visualisation
create_valuebox = function(df, title = "", caption = caption, lang = lang) {
  g =
    ggplot2::ggplot(df,
                    ggplot2::aes(10, 10, height = 5, width = 8, label = .data$ind_id)) +
    ggplot2::geom_tile(
      fill = phw_grey,
      colour = phw_grey,
      linejoin = "round") +
    # add value
    ggplot2::geom_text(
      x = 6.3, y = 11.3, hjust = 0,
      color = phw_blue, fontface = "bold", size = 26,
      ggplot2::aes(label = .data$value), family = "sans"
    ) +
    # add text description underneath
    ggplot2::geom_text(
      x = 6.3, y = 9, hjust = 0,
      size = 5.5,
      ggplot2::aes(label = .data$label), family = "sans"
    ) +
    # add condition logo
    ggplot2::annotation_custom(
      grid::rasterGrob(png::readPNG(df$icon), interpolate = TRUE),
      xmin = 12, xmax = 14, ymin = 10.1, ymax = 12.5
    ) +
    # add caption
    ggplot2::labs(caption = caption,
                  alt = paste(tr_pull("alt_infographic", lang), title, sep = ": ")) +
    # edit theme
    ggplot2::coord_cartesian(expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.caption = ggplot2::element_text(face = "italic", hjust = 1, size = 10),
      plot.margin = ggplot2::unit(c(0.5, 0.5, 0.5, 0.5), "cm"),
      plot.background = ggplot2::element_rect(fill = phw_grey, colour = NA),
      panel.background = ggplot2::element_rect(fill = phw_grey, colour = NA)
    )
  return(g)
}
