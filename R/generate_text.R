generate_text = function(df, disag, statement){
  if (disag == "None") {
    percent = 
      df %>%
      pull(value) %>%
      scales::percent() # Only for percent indicators
    text_out = glue::glue("The {first_to_lower(statement)} is <b>{percent}</b>.")
  } else {
    
    
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
