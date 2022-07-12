#' Update disag
#' Handles all enable/disabling and updating of the dropdowns for disags
#' Updates based on indicator, output type, possible disags and language
#' @param selected_ind_id The current selected indicator
#' @param selected_output_type Is the user viewing infographic, barchart or table?
#' @param selected_disag Current value of the primary disag - "None", "Age", "Gender", "Education" or "Deprivation"
#' @param lang The language either EN or CY
update_disag = function(selected_ind_id,
                        selected_output_type,
                        selected_disag, lang) {

  # Create vector of possible disags
  disag_choices =
    whesApp::indicator_info %>%
    dplyr::filter(.data$ind_id == selected_ind_id) %>%
    dplyr::pull(.data$disag) %>%
    unlist()

  no_disag_avail = (length(disag_choices) == 1) & (disag_choices[[1]] == "None")
  second_disag_avail = is_second_allowed(selected_ind_id, selected_disag)
  single_disag_only = ((length(disag_choices) == 2) & ("None" %in% disag_choices)) | (!second_disag_avail)

  if (sum(c(no_disag_avail, second_disag_avail, single_disag_only) == TRUE) != 1) {
    "Problem with disaggregate checks."
  }

  if (selected_output_type == "infographic") {
    # Always disable disag 2 and set disag2 to None
    shinyjs::disable("disag2")
    update_disag_input("disag2", "disaggregate_None", "disaggregate_None", lang)

    if (is_percent(selected_ind_id) && !no_disag_avail) {
      # Enable disag and set to choices
      shinyjs::enable("disag")
      set_disag1_to_choices(selected_disag, disag_choices, lang)
    } else {
      # Disable disag and set to None
      shinyjs::disable("disag")
      update_disag_input("disag", "disaggregate_None", "disaggregate_None", lang)
    }
  } else {
    # Output is barchart or table

    if (no_disag_avail) {
      # Disable both disags and set both to None
      shinyjs::disable("disag")
      update_disag_input("disag", "disaggregate_None", "disaggregate_None", lang)
      shinyjs::disable("disag2")
      update_disag_input("disag2", "disaggregate_None", "disaggregate_None", lang)
    } else if (single_disag_only) {

      # Enable disag and set to choices
      shinyjs::enable("disag")
      set_disag1_to_choices(selected_disag, disag_choices, lang)

      # Disable disag2 and set to none
      shinyjs::disable("disag2")
      update_disag_input("disag2", "disaggregate_None", "disaggregate_None", lang)
    } else {
      if (selected_disag == "None") {

        # Enable disag and set to all possible
        shinyjs::enable("disag")
        set_disag1_to_choices(selected_disag, disag_choices, lang)

        # Disable disag2 and set to None
        shinyjs::disable("disag2")
        update_disag_input("disag2", "disaggregate_None", "disaggregate_None", lang)
      } else {
        # Enable disag and set to possible
        shinyjs::enable("disag")
        set_disag1_to_choices(selected_disag, disag_choices, lang)

        # Enable disag2 and set to possible minus selected_disag
        shinyjs::enable("disag2")
        set_disag2_to_choices(selected_disag, disag_choices, lang)
      }
    }
  }
}

update_disag_input = function(disag, choices, selected, lang) {
  session = shiny::getDefaultReactiveDomain()
  shiny::updateSelectInput(
    session,
    inputId = disag,
    label = tr_pull("select_disag_label", lang),
    choices = tr_deframe(pattern = choices, lang = lang),
    selected = tr_deframe(pattern = selected, lang = lang)
  )
}

set_disag1_to_choices = function(selected_disag, disag_choices, lang) {

  # Often, we want to set the selected disag to either the current disag, or "None"
  search_disag = glue::glue("disaggregate_({paste(disag_choices, collapse = '|')})")
  if (selected_disag %in% disag_choices) {
    update_disag_input("disag", search_disag, glue::glue("disaggregate_{selected_disag}"), lang)
  } else {
    update_disag_input("disag", search_disag, "disaggregate_None", lang)
  }
}

set_disag2_to_choices = function(selected_disag, disag_choices, lang) {
  disag_choices_2 = disag_choices[disag_choices != selected_disag]
  search_disag = glue::glue("disaggregate_({paste(disag_choices_2, collapse = '|')})")
  update_disag_input("disag2", search_disag, "disaggregate_None", lang)
}

is_second_allowed = function(selected_ind_id, selected_disag) {
  if (selected_disag == "None") {
    return(FALSE)
  }
  whesApp::indicator_data %>%
    dplyr::filter(.data$ind_id == selected_ind_id) %>%
    dplyr::filter(!!rlang::sym(selected_disag) != "All") %>%
    dplyr::select(!!whesApp::breakdown_vars) %>%
    dplyr::select(-!!selected_disag) %>%
    purrr::map_lgl(is_all) %>%
    all() %>%
    isFALSE()
}

is_all = function(x) {
  all(x == "All")
}
