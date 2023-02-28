#' Radio buttons for changing output type
#'
#' The radio buttons will have three options: Infographic, bar chart and table.
#' @return div element containing radio buttons for changing output type.
output_radio_buttons = function() {
  shiny::tags$div(
    id = "output_type",
    class = "shiny-input-container shiny-input-radiogroup form-group",
    role = "radiogroup",
    `aria-labelledby` = "output_type_grouplabel",
    shiny::tags$div(
      tr_pull("select_output_type", "EN"),
      id = "output_type_grouplabel"
    ),
    shiny::tags$div(
      class = "form-check",
      shiny::tags$input(
        type = "radio",
        name = "output_type",
        value = "infographic",
        id = "output_type_infographic",
        class ="form-check-input",
        checked = "checked"
      ),
      shiny::tags$label(
        "Infographic",
        class = "form-check-label",
        `for` = "output_type_infographic"
      )
    ),
    shiny::tags$div(
      class = "form-check",
      shiny::tags$input(
        type = "radio",
        name = "output_type",
        value = "barchart",
        id = "output_type_barchart",
        class ="form-check-input"
      ),
      shiny::tags$label(
        "Bar chart",
        class = "form-check-label",
        `for` = "output_type_barchart"
      )
    ),
    shiny::tags$div(
      class = "form-check",
      shiny::tags$input(
        type = "radio",
        name = "output_type",
        value = "table",
        id = "output_type_table",
        class ="form-check-input"
      ),
      shiny::tags$label(
        "Table",
        class = "form-check-label",
        `for` = "output_type_table"
      )
    )
  )
}
