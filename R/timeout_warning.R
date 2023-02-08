add_timeout_warning = function() {
  shiny::singleton(
    shiny::tags$div(
      shiny::p("Your session is about to disconnect in less than 60 seconds due to inactivity."),
      shiny::actionButton("timeout_extend",
                          "Click to continue with your session",
                          class = "btn-primary"),
      role = "alert",
      class = "dialog d-none",
      id = "timeout-warning"
    )
  )
}
