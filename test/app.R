require(shiny)
require(shinyjs)


ui <- fluidPage(
    img(id="my_img",src="image.png",style="cursor:pointer;"),
    useShinyjs(),
    tabsetPanel(id="navbar",
                tabPanel("tab1", p("This is tab 1")),
                tabPanel("tab2", p("This is tab 2"))
    )
)



server <- function(input, output,session){
    
    shinyjs::onclick("my_img",  updateTabsetPanel(session, inputId="navbar", selected="tab2"))
    
}

shinyApp(ui,server)