library(shiny)
library(tidyverse)

shinyServer(function(input, output) {

    
    output$ind1 = renderPlot({
        ind1 %>%
            mutate(WIMD = as_factor(WIMD)) %>%
            mutate(Educat = fct_relevel(Educat, "Low", "Medium", "High")) %>%
            mutate(Age = fct_relevel(Age, "Child", "Young Adult",
                                     "Working Age Adult", "Retired Age Adult")) %>%
            group_by(!!sym(input$disag)) %>%
            summarise(percent = sum(n_yes)/sum(n) * 100) %>%
            ggplot(aes(x = !!sym(input$disag), y = percent)) + 
            geom_col(aes(fill = !!sym(input$disag))) +
            ylim(0, 100) +
            labs(y = "Percent responding 'Yes'") +
            theme_minimal()
    })

})



    
    