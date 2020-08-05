generate_source = function(df){
text = glue::glue('This indicator has been acquired from the
                  {tags$a(href = df$source_link, df$source, target = "_blank")}
                  for the period <i>{df$year}</i>.')
  return(text)
}

