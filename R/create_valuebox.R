#' Create Value Box
#' @param df The data to visualise
#' @param caption The caption of the infographic
#' @return The visualisation

create_valuebox = function(df, caption = caption) {
  g =
    ggplot2::ggplot(df, ggplot2::aes(10, 10, height = 5, width = 8, label = .data$ind_id)) +
    ggplot2::geom_tile(fill = "#1A5D7E", linejoin = "round") +
    ggplot2::geom_text(x = 6.3, y = 11, hjust = 0,
                       color = "white", fontface = "bold", size = 20,
                       ggplot2::aes(label = .data$value), family = "Helvetica Neue") +
    ggplot2::geom_text(x = 6.3, y = 9, hjust = 0,
                       color = "white", size = 6,
                       ggplot2::aes(label = .data$label), family = "Helvetica Neue") +
    ggplot2::geom_text(x = 11, y = 11.1, hjust = 0,
                       size = 50, ggplot2::aes(label = emojifont::fontawesome(.data$icon)),
                       family = "Font Awesome 5 Free Solid",
                       alpha = 1, color = "#c60158") +
    ggplot2::geom_text(x = 6.3, y = 7.8, hjust = 0,
                       color = "white", size = 4,
                       label = caption, family = "Helvetica Neue") +
    ggplot2::theme_void() +
    ggplot2::coord_fixed()
  return(g)
}
