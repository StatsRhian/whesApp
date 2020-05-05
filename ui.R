bs_theme_set("simplex")
#bs_theme_set("sketchy")

navbarPage("Welsh Health Equity Status",
           tabPanel("Indicators", 
                    navlistPanel(
                      id = "tab_categories",
                      tabPanel("Overview", 
                               icon = icon("home"), 
                               h2("Welsh Health Equity Status"), 
                               br(),
                               div(img(src = "icons/health-services.png",
                                   height = "150px",
                                   id = "img_health",
                                   style = "cursor:pointer;"), 
                               img(src = "icons/income-social-protection.png",
                                   height = "150px",
                                   id = "img_income",
                                   style = "cursor:pointer;"),  
                               img(src = "icons/living-conditions.png",
                                   height = "150px",
                                   id = "img_living",
                                   style = "cursor:pointer;"), 
                               img(src = "icons/social-human-capital.png",
                                   height = "150px",
                                   id = "img_social",
                                   style = "cursor:pointer;"), 
                               img(src = "icons/employment-working-conditions.png",
                                   height = "150px",
                                   id = "img_employment",
                                   style = "cursor:pointer;"), 
                               style = "text-align: center;"), 
                               br(),
                               textOutput("test_lang"),
                               p("The overall aim of the WHESRi is to inform, enable and support policy solutions,innovation and sustainable investment towards healthy, prosperous lives for all,
                                 increasing equity in health and leaving no one behind in Wales and beyond. The project supports the Building A Healthier Wales and the Welsh Government Transformation
                                 Programme, facilitating, monitoring and accelerating joint action across sectors,governance levels and key stakeholders to help achieve a Healthier, a More Equal, a
                                 Prosperous and a Globally Responsible Wales for the present and future generations.")
                      ),
                      "Inequalities in Health",
                      widths = c(2, 10),
                      tabPanel(cat_df$name[cat_df$catID == "wellbeing"],
                               icon = icon(cat_df$icon[cat_df$catID == "wellbeing"]),
                               tabsetPanel(
                                 tabPanel("Infographics",
                                          catSimpleSummaryUI("simple-wellbeing", "wellbeing")
                                 ),
                                 tabPanel("Detail",
                                         catDetailUI("detail-wellbeing", "wellbeing")
                                          )
                               )
                      ), 
                      
                      tabPanel(cat_df$name[cat_df$catID == "morbidity"], 
                               icon = icon(cat_df$icon[cat_df$catID == "morbidity"]),
                               tabsetPanel(
                                 tabPanel("Infographics",
                                          catSimpleSummaryUI("simple-morbidity", "morbidity")
                                 ),
                                 tabPanel("Detail",
                                          catDetailUI("detail-morbidity", "morbidity")
                                 )
                               )
                      ),
                      
                      "Five essential conditions",
                      
                      tabPanel(cat_df$name[cat_df$catID == "health"], 
                               icon = icon(cat_df$icon[cat_df$catID == "health"]),
                               tabsetPanel(
                                 tabPanel("Infographics",
                                          catSimpleSummaryUI("simple-health", "health")
                                 ),
                                 tabPanel("Detail",
                                          catDetailUI("detail-health", "health")
                                 )
                               )
                      ),
                      
                      tabPanel(cat_df$name[cat_df$catID == "income"], 
                               icon = icon(cat_df$icon[cat_df$catID == "income"]),
                               tabsetPanel(
                                 tabPanel("Infographics",
                                          catSimpleSummaryUI("simple-income", "income")
                                 ),
                                 tabPanel("Detail",
                                          catDetailUI("detail-income", "income")
                                 )
                               )
                      ),
                      
                      tabPanel(cat_df$name[cat_df$catID == "living"], 
                               icon = icon(cat_df$icon[cat_df$catID == "living"]),
                               tabsetPanel(
                                 tabPanel("Infographics",
                                          catSimpleSummaryUI("simple-living", "living")
                                 ),
                                 tabPanel("Detail",
                                          catDetailUI("detail-living", "living")
                                 )
                               )
                      ),
                      
                      tabPanel(cat_df$name[cat_df$catID == "social"], 
                               icon = icon(cat_df$icon[cat_df$catID == "social"]),
                               tabsetPanel(
                                 tabPanel("Infographics",
                                          catSimpleSummaryUI("simple-social", "social")
                                 ),
                                 tabPanel("Detail",
                                          catDetailUI("detail-social", "social")
                                 )
                               )
                      ),
                      
                      tabPanel(cat_df$name[cat_df$catID == "employment"], 
                               icon = icon(cat_df$icon[cat_df$catID == "employment"]),
                               tabsetPanel(
                                 tabPanel("Infographics",
                                          catSimpleSummaryUI("simple-employment", "employment")
                                 ),
                                 tabPanel("Detail",
                                          catDetailUI("detail-employment", "employment")
                                 )
                               )
                      )
                    )
           ),
           tags$head(
             tags$script(type = "text/javascript", src = "logo.js"),
             bootstrap(),
             useShinyjs()
           )
)
