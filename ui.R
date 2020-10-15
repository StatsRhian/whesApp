bs_theme_set("minty")
bs_theme_accent_colors(primary = "#1A5D7E", secondary = "#c60158")
navbarPage(title = textOutput("whes_title"),
           
           tags$head(
             bootstrap(),
             useShinyjs(),
             tags$script(type = "text/javascript", src = "logo.js"),
             tags$script(HTML('Shiny.addCustomMessageHandler("changetitle", function(x) {document.title=x});')),
             tags$link(rel = "stylesheet", type = "text/css", href = "phw-style.css"),
             tags$style(type = "text/css",
                        ".shiny-output-error { visibility: hidden; }",
                        ".shiny-output-error:before { visibility: hidden; }"
             )),
           navlistPanel(
             id = "tab_categories",
             tabPanel(uiOutput("overview_tab_title", inline = TRUE), 
                      icon = icon("home") ,
                      br(),
                      div(img(src = "icons/health-services.png",
                              height = "200px",
                              id = "img_health",
                              style = "cursor:pointer;"), 
                          img(src = "icons/income-social-protection.png",
                              height = "200px",
                              id = "img_income",
                              style = "cursor:pointer;"),  
                          img(src = "icons/living-conditions.png",
                              height = "200px",
                              id = "img_living",
                              style = "cursor:pointer;"), 
                          img(src = "icons/social-human-capital.png",
                              height = "200px",
                              id = "img_social",
                              style = "cursor:pointer;"), 
                          img(src = "icons/employment-working-conditions.png",
                              height = "200px",
                              id = "img_employment",
                              style = "cursor:pointer;"), 
                          style = "text-align: center;"), 
                      br(),
                      uiOutput("intro_md"),
                      reactableOutput("indicator_search")
             ),
             "Inequities in Health",
             widths = c(2, 10),
             categoryPanelUI("wellbeing"),
             categoryPanelUI("morbidity"),
             "Five essential conditions",
             categoryPanelUI("health"),
             categoryPanelUI("income"),
             categoryPanelUI("living"),
             categoryPanelUI("social"),
             categoryPanelUI("employment")
           )
)

