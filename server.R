shinyServer(function(input, output) {
    
    
    ind1_dis = 
        reactive({
            ind1_dis = 
                ind1 %>%
                mutate(WIMD = as_factor(WIMD)) %>%
                mutate(Educat = fct_relevel(Educat, "Low", "Medium", "High")) %>%
                mutate(Age = fct_relevel(Age, "Child", "Young Adult",
                                         "Working Age Adult", "Retirement Age Adult")) %>%
                when(
                    is.null(input$disag) ~ .,
                    ~ group_by(., !!!syms(input$disag))
                ) %>%
                summarise(Percent = sum(n_yes)/sum(n))
        })
    
    output$ind1_plot = renderPlot({
        if (is.null(input$disag)) {
            g = ind1_dis() %>%
                ggplot(aes(x = "All", y = Percent)) + 
                geom_col()
        } else if (length(input$disag) == 1) {
            g = ind1_dis() %>%
                ggplot(aes(x = !!sym(input$disag), y = Percent)) + 
                geom_col(aes(fill = !!sym(input$disag))) 
        } else if (length(input$disag) == 2) {
            g = ind1_dis() %>%
                ggplot(aes(x = !!syms(input$disag)[[2]], y = Percent)) + 
                geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") 
        }  else if (length(input$disag) == 3) {
            g = ind1_dis() %>%
                ggplot(aes(x = !!syms(input$disag)[[2]], y = Percent)) + 
                geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") + 
                facet_wrap(vars(!!!syms(input$disag)[[3]]))
        } else if (length(input$disag) == 4) {
            g = ind1_dis() %>%
                ggplot(aes(x = !!syms(input$disag)[[2]], y = Percent)) + 
                geom_col(aes(fill = !!syms(input$disag)[[1]]),  position = "dodge") + 
                facet_grid(rows = vars(!!!syms(input$disag)[[3]]), 
                           cols = vars(!!!syms(input$disag)[[4]]))
        }
        
        g +
            labs(y = input$plot_y_axis,
                 x = input$plot_x_axis,
                 title = input$plot_title,
                 caption = input$plot_caption) +
            scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
            coord_cartesian(ylim = c(0, 0.5)) +
            theme_minimal() 
    })
    
    output$ind1_df = 
        DT::renderDataTable({
            ind1_dis() %>%
                DT::datatable(rownames = FALSE) %>%
                formatPercentage("Percent")
        })
    
    output$downloadData = downloadHandler(
        filename = function() {
            paste("indicator001", ".csv", sep = "")
        },
        content = function(file) {
            write.csv(ind1_dis(), file, row.names = FALSE)
        }
    )
    
    output$downloadPlot <- downloadHandler(
        filename = function() { 
            paste("indicator001", ".png", sep = "") 
        },
        content = function(file) {
            ggsave(file, plot = ind1_plot(), device = "png")
        }
    )
    
})




