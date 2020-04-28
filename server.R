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
    
    
    plot_obj = reactive({
        if (is.null(input$disag)) {
            g = ind1_dis() %>%
                ggplot(aes(x = "All", y = Percent)) + 
                geom_col(fill = "#1B9E77")
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
            #geom_text(aes(label = percent(Percent, accuracy = 1)),
            #position = position_dodge(width = 0.9), vjust = -0.25) + 
            labs(y = input$plot_y_axis,
                 x = input$plot_x_axis,
                 title = input$plot_title,
                 caption = input$plot_caption) +
            scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
            coord_cartesian(ylim = c(0, 0.5)) +
            theme_minimal() +
            scale_fill_brewer(palette = "Dark2")
    })
    
    output$ind1_plot = renderPlot({
        plot_obj()
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
    
    output$downloadPlot = downloadHandler(
        filename = function() { 
            paste("indicator001", ".png", sep = "") 
        },
        content = function(file) {
            ggsave(file, plot =  plot_obj(), device = "png")
        }
    )
    
    
    
    
    
    
    
    output$waffle =   renderPlot({ 
        health_percent =
            tibble(
                parts = factor(c("Yes (32%)", "No (68%)")),
                vals = c(32, 68),
                col = c("red", "grey")) 
        
        health_percent %>%
            ggplot(aes(label = parts, values = vals, col = parts)) +
            geom_pictogram(
                n_rows = 10, size = 9.5, 
                flip = TRUE,
                family = "Font Awesome 5 Free Solid"
            ) +
            scale_color_manual(
                name = NULL,
                values = c("grey", "firebrick"),
                labels = c("No (68%)", "Yes (32%)")
            ) +
            scale_label_pictogram(
                name = NULL,
                values = c("user", "user"),
                labels = c("No (68%)", "Yes (32%)")
            ) +
            coord_equal(xlim = c(1, 10),
                        ylim = c(1, 10)) +
            theme_ipsum_rc(grid = "",
                           plot_title_size = 14) +
            theme_enhance_waffle() +
            labs(title = "Percentage of adults reporting fair,\nbad or very bad health",
                 caption = "Welsh Health Equity Status 2020")
    })
    
    ############## WAFFLE FACET
    
    output$age_waffle = renderPlot({
        ind1 %>%
            mutate(WIMD = as_factor(WIMD)) %>%
            mutate(Educat = fct_relevel(Educat, "Low", "Medium", "High")) %>%
            mutate(Age = fct_relevel(Age, "Child", "Young Adult",
                                     "Working Age Adult", "Retirement Age Adult")) %>%
            group_by(Age) %>%
            summarise(Percent = sum(n_yes)/sum(n)) %>%
            rename(Yes = Percent) %>%
            mutate(No = 1 - Yes) %>%
            pivot_longer(cols = -Age, names_to = "Response", values_to = "Percent") %>%
            mutate(Response = as_factor(Response)) %>%
            mutate(Percent = round(Percent * 100, 0)) %>%
            ggplot(aes(values = Percent, label = Response, colour = Response)) +
            geom_pictogram(
                n_rows = 10, size = 4, 
                flip = TRUE,
                family = "Font Awesome 5 Free Solid"
            ) +
            scale_colour_manual(
                name = NULL,
                values = c("firebrick", "grey"),
                labels = c("Yes", "No")
            ) +
            scale_label_pictogram(
                name = NULL,
                values = c("user", "user"),
                labels = c("Yes", "No")
            ) +
            facet_wrap(~Age, nrow = 1) +
            scale_x_discrete(expand = c(0, 0)) +
            scale_y_discrete(expand = c(0, 0)) +
            coord_equal() +
            labs(
                title = "Percentage of adults reporting fair,\nbad or very bad health",
                caption = "Welsh Health Equity Status 2020"
            ) +
            theme_ipsum_rc(grid = "") +
            theme_enhance_waffle()
    })
    
    
})




