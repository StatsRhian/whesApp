shinyServer(function(input, output) {

# Call modules for infographics page
callModule(module = catSimpleSummary, id = "simple-wellbeing")
callModule(module = catSimpleSummary, id = "simple-morbidity")
callModule(module = catSimpleSummary, id = "simple-health")
callModule(module = catSimpleSummary, id = "simple-income")
callModule(module = catSimpleSummary, id = "simple-living")
callModule(module = catSimpleSummary, id = "simple-social")
callModule(module = catSimpleSummary, id = "simple-employment")

# Call modules for detail page
callModule(module = catDetail, id = "detail-wellbeing")
callModule(module = catDetail, id = "detail-morbidity")
callModule(module = catDetail, id = "detail-health")
callModule(module = catDetail, id = "detail-income")
callModule(module = catDetail, id = "detail-living")
callModule(module = catDetail, id = "detail-social")
callModule(module = catDetail, id = "detail-employment")

output$test_lang = renderText(input$lang)
    
})




