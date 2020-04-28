library(shiny)
library(tidyverse)
library(DT)
library(bootstraplib)
library(shinyBS)
library(scales)
library(RColorBrewer)
library(waffle)
library(hrbrthemes)


bs_theme_set("simplex")
#bs_theme_set("sketchy")

navbarPage("Welsh Health Equity Status",
           tabPanel("Indicators", 
                    navlistPanel(
                      "Inequalities in Health",
                      widths = c(4, 8),
                      tabPanel("Wellbeing", 
                               icon = icon("smile-beam"),
                               tabsetPanel(
                                 tabPanel("Summary",
                                          fluidPage(
                                            br(), 
                                            h2("Indicators for wellbeing"),
                                            br(),
                                            fluidRow(
                                              column(6,
                                                     selectInput("wellbeing",
                                                                 label = "Indicator",
                                                                 width = "90%",
                                                                 choices = filter(indicators,
                                                                                  category == "Wellbeing") %>%
                                                                   pull(indicator))
                                              ),
                                              column(6,
                                                     selectInput("disag",
                                                                 label = "Disaggregate",
                                                                 choices = c("Gender" = "Gender",
                                                                             "Age" = "Age",
                                                                             "Welsh Index" = "WIMD", 
                                                                             "Education level" = "Educat"),
                                                                 selected = "Age",
                                                                 selectize = TRUE, 
                                                                 multiple = TRUE)
                                              )
                                            ), 
                                            br(),
                                            p("The percentage of adults reporting fair; bad or very bad health is 16% for Young Adults, 27% for Working Age Adults and 44% for Retirement Age Adults."),
                                            p("Year: 2019"),
                                            p("Source: ", a(href = "https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=8591",
                                                            "National Survey for Wales 2019",
                                                            .noWS = "outside", 
                                                            target = "_blank"),
                                              .noWS = c("after-begin", "before-end")), 
                                            fluidRow(
                                              column(8,
                                                     wellPanel(
                                                       h2("Plot"),
                                                       plotOutput("ind1_plot"), 
                                                       actionButton("edit_plot", "Edit", icon = icon("pencil")),
                                                       downloadButton("downloadPlot", "Download"),
                                                       bsModal("editPlotModal",
                                                               title = "",
                                                               trigger = "edit_plot",
                                                               size = "large",
                                                               textInput("plot_title",
                                                                         label = "Plot title"
                                                               ),
                                                               textInput("plot_x_axis",
                                                                         label = "X axis"
                                                               ),
                                                               textInput("plot_y_axis",
                                                                         label = "Y axis"
                                                               ),
                                                               textInput("plot_caption",
                                                                         label = "Caption",
                                                                         value = "Welsh Health Equity Status 2020"
                                                               )
                                                       )
                                                     )       
                                              ),
                                              column(4,
                                                     wellPanel(
                                                       h2("Table"),
                                                       dataTableOutput("ind1_df"), 
                                                       downloadButton("downloadData", "Download")
                                                     )
                                              )
                                            )
                                          ) # End Fluid page
                                 ), 
                                 tabPanel("Infographics",
                                          fluidPage(
                                            fluidRow(
                                              column(6, 
                                                     plotOutput("waffle")
                                              ),
                                              column(6, 
                                                     plotOutput("age_waffle")
                                              )
                                            )
                                          )
                                          
                                 ) # End Tab panel
                                 
                               )
                      ), # End Wellbeing Tab
                      tabPanel("Mortality",
                               icon = icon("procedures"),
                               h2("Indicators for mortality"),
                               br(),
                               selectInput("wellbeing",
                                           label = "Indicator",
                                           width = "60%",
                                           choices = filter(indicators,
                                                            category == "Mortality") %>%
                                             pull(indicator))
                      ),
                      "Five essential conditions",
                      tabPanel("Health Services",
                               icon = icon("medkit"),
                               img(src = "icons/health-services.png",
                                   align = "right", 
                                   width = "15%"),
                               h2("Indicators for health services"),
                               br(),
                               selectInput("health",
                                           label = "Please select an indicator",
                                           width = "60%",
                                           choices = filter(indicators,
                                                            category == "Health services") %>%
                                             pull(indicator))
                      ), 
                      tabPanel("Income and Social Protection",
                               icon = icon("pound-sign"),
                               img(src = "icons/income-social-protection.png",
                                   align = "right", 
                                   width = "15%"),
                               h2("Indicators for income and social protection"),
                               br(),
                               selectInput("social",
                                           label = "Please select an indicator",
                                           width = "60%",
                                           choices = filter(indicators,
                                                            category == "Income security and social protection") %>%
                                             pull(indicator))
                      ),
                      tabPanel("Living environment",
                               icon = icon("tree"),
                               img(src = "icons/living-conditions.png",
                                   align = "right", 
                                   width = "15%"),
                               h2("Indicators for living environment"),
                               br(),
                               selectInput("living",
                                           label = "Please select an indicator",
                                           width = "60%",
                                           choices = filter(indicators,
                                                            category == "Living environment") %>%
                                             pull(indicator)),
                      ),
                      tabPanel("Social and human captial",
                               icon = icon("users"),
                               img(src = "icons/social-human-capital.png",
                                   align = "right", 
                                   width = "15%"),
                               h2("Indicators for social and human captial"),
                               br(),
                               selectInput("living",
                                           label = "Please select an indicator",
                                           width = "60%",
                                           choices = filter(indicators,
                                                            category == "Social and human capital")
                                           %>% pull(indicator))
                      ),
                      tabPanel("Employment and working conditions",
                               icon = icon("wrench"),
                               img(src = "icons/employment-working-conditions.png",
                                   align = "right", 
                                   width = "15%"),
                               h2("Indicators for employment and working conditions"),
                               br(),
                               selectInput("living",
                                           label = "Please select an indicator",
                                           width = "60%",
                                           choices = filter(indicators,
                                                            category == "Employment and working conditions") %>% 
                                             pull(indicator))
                      )
                    )
           ),
           tabPanel("Policy Explorer", 
                    includeMarkdown("www/content/policy-explorer.md")
           ),
           ############ META DATA
           tabPanel("Metadata", 
                    navlistPanel(
                      "Inequalities in Health",
                      widths = c(4, 8),
                      tabPanel("Wellbeing", 
                               icon = icon("smile-beam"), 
                               includeMarkdown("www/content/ind001.md")    
                      ),
                      tabPanel("Mortality",
                               icon = icon("procedures")
                      ),
                      "Five essential conditions",
                      tabPanel("Health Services",
                               icon = icon("medkit")
                      ), 
                      tabPanel("Income and Social Protection",
                               icon = icon("pound-sign")
                      ),
                      tabPanel("Living environment",
                               icon = icon("tree")
                      ),
                      tabPanel("Social and human captial",
                               icon = icon("users")
                      ),
                      tabPanel("Employment and working conditions",
                               icon = icon("wrench")
                      )
                    )
           ), 
           navbarMenu("About",
                      tabPanel("About the project", 
                               includeMarkdown("www/content/about_project.md")
                      ),
                      tabPanel("About this app", 
                               includeMarkdown("www/content/about_app.md")
                      )
           ),
           tags$script(
             HTML(
               paste(
                 "$(document).ready(function() {",
                 "$('.navbar-nav').append(",
                 "$('<form class=\"navbar-form navbar-right\">",
                 gsub(
                   "\n", "",
                   selectInput(
                     inputId = "lang", 
                     label = NULL, 
                     choices = c(
                       "EN" = "english",
                       "CY" = "cymraeg"
                     ),
                     selectize = FALSE, 
                     width = "auto"
                   )
                 ),
                 "</form>')",
                 ");",
                 "});"
               )
             )
           ),
           tags$head(
             bootstrap()
             #shinythemes::themeSelector()
           )
)
