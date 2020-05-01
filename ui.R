bs_theme_set("simplex")
#bs_theme_set("sketchy")

navbarPage("Welsh Health Equity Status",
           tabPanel("Indicators", 
                    navlistPanel(
                      tabPanel("Overview", 
                               icon = icon("home"), 
                               h2("Fabulous home page")
                      ),
                      "Inequalities in Health",
                      widths = c(2, 10),
                      well = TRUE,
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
           )
)
