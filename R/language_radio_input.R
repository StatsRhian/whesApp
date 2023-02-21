#' Add radio button inputs for language selection
#'
#' The language selection is written in full because the labels for each option
#' need their own language specification, and the label for the radio group
#' needs to be specified as aria-label.
#'
#' @return A pair of inline radio buttons providing a choice between English and
#' Cymraeg.
add_language_selection <- function() {
  shiny::tags$div(
    id = "lan",
    class = "form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline shinyjs-resettable shiny-bound-input", # nolint: line_length_linter
    role = "radiogroup",
    `aria-label` = "Change the language for this page", # FIXME: Translation needed.
    shiny::tags$div(
      class = "form-check form-check-inline",
      shiny::tags$input(
        type = "radio",
        name = "lan",
        value = "EN",
        checked = "checked",
        class = "form-check-input",
        id = "lang-en"
      ),
      shiny::tags$label(
        "English",
        lang = "en",
        class = "form-check-label",
        `for` = "lang-en"
      )
    ),
    shiny::tags$div(
      class = "form-check form-check-inline",
      shiny::tags$input(
        type = "radio",
        name = "lan",
        value = "CY",
        class = "form-check-input",
        id = "lang-cy"
      ),
      shiny::tags$label(
        "Cymraeg",
        lang = "cy",
        class = "form-check-label",
        `for` = "lang-cy"
      )
    )
  )
}
