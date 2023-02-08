add_timeout_warning = function() {
  shiny::singleton(
    shiny::tags$div(
      shiny::p("Your session is about to disconnect in less than 60 seconds due to inactivity."),
      shiny::tags$button(
        id = "timeout_extend",
        type = "button",
        class = "action-button",
        "Click to continue with your session"
      ),
      role = "alert",
      class = "dialog d-none",
      id = "timeout-warning"
    )
  )
}
