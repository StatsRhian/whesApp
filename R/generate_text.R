generate_text = function(df, statement, disag, type){
  if (disag == "None") {
    if (type == "percent") {
      value = df %>%
        pull(value) %>%
        scales::percent(accuracy = 1) # Only for percent indicators
    } else{
      value = df %>%
        pull(value)
    }
    text_out = glue::glue("The {first_to_lower(statement)} is <b>{value}</b>.")
  } else {
   text_out = "" 
  }

  return(text_out) 
}


first_to_lower = function(text){
   new = 
     text %>%
     str_sub(1, 1) %>%
     str_to_lower
   
   str_sub(text, 1, 1) = new
   return(text)
}

style_text = function(text){
  styled = p(text,  style = "font-size: 20px")
}
