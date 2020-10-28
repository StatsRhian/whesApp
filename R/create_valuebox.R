make_valuebox = function(df, caption = caption){
  g = 
    ggplot(df, aes(10, 10, height = 5, width = 8, label = ind_id)) +
    geom_tile(fill = primary, linejoin = "round") +
    geom_text(x = 6.3, y = 11, hjust = 0,
              color = "white", fontface = "bold", size = 20,
              aes(label = value), family = font_family ) +
    geom_text(x = 6.3, y = 9, hjust = 0, 
              color = "white", size = 6, 
              aes(label = label), family = font_family) +
    geom_text(x = 11, y = 11.1, hjust = 0,
              size = 50, aes(label = emojifont::fontawesome(icon)),
              family = "Font Awesome 5 Free Solid",
              alpha = 1, color = secondary) +
    geom_text(x = 6.3, y = 7.8, hjust = 0,
              color = "white", size = 4,
              label = caption, family = font_family) +
    theme_void() +
    coord_fixed()
  return(g)
}

