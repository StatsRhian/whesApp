bs_theme_set("minty")
bs_theme_accent_colors(primary = "#1A5D7E", secondary = "#c60158")
navbarPage(title = textOutput("whes_title"),
           
           tags$head(
             tags$script(type = "text/javascript", src = "logo.js"),
             bootstrap(),
             useShinyjs(),
               tags$link(rel = "stylesheet", type = "text/css", href = "phw-style.css")
           ),
           
           navlistPanel(
             id = "tab_categories",
             tabPanel(uiOutput("overview_tab_title", inline = TRUE), 
                      icon = icon("home"), 
                      #h2(textOutput("whes_title")),
                      br(),
                      div(img(src = "icons/health-services.png",
                              height = "250px",
                              id = "img_health",
                              style = "cursor:pointer;"), 
                          img(src = "icons/income-social-protection.png",
                              height = "250px",
                              id = "img_income",
                              style = "cursor:pointer;"),  
                          img(src = "icons/living-conditions.png",
                              height = "250px",
                              id = "img_living",
                              style = "cursor:pointer;"), 
                          img(src = "icons/social-human-capital.png",
                              height = "250px",
                              id = "img_social",
                              style = "cursor:pointer;"), 
                          img(src = "icons/employment-working-conditions.png",
                              height = "250px",
                              id = "img_employment",
                              style = "cursor:pointer;"), 
                          style = "text-align: center;"), 
                      br(),
                      p("The overall aim of the WHESRi is to inform, enable and support policy solutions,innovation and sustainable investment towards healthy, prosperous lives for all,
                                 increasing equity in health and leaving no one behind in Wales and beyond. The project supports the Building A Healthier Wales and the Welsh Government Transformation
                                 Programme, facilitating, monitoring and accelerating joint action across sectors, governance levels and key stakeholders to help achieve a Healthier, a More Equal, a
                                 Prosperous and a Globally Responsible Wales for the present and future generations.
                                 You can also explore the Health Equity Status for Europe in ", a(href = 'https://whoeurope.shinyapps.io/health_equity_dataset/', 'The Health Equity Dataset', .noWS = 'outside'), ".", .noWS = c("after-begin", "before-end")),
                      p("Search the table below for a specific indicator, to discover which category they are listed under. Or simply select a category on the left to start exploring."), 
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

