#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



shinyServer(function(input, output) {
  
  # word cloud
  output$population_country_cloud = renderPlot({
    year = input$year_slider
    population_of_countries_in_one_year = population_of_countries_df %>%
      select(Country, ends_with(as.character(year)))
    
    wordcloud(
      population_of_countries_in_one_year$Country,
      population_of_countries_in_one_year[, 2],
      scale = c(5, 1),
      max.words=200,
      rot.per = 0.35,
      random.order=FALSE,
      colors = brewer.pal(8, "Dark2"),
      random.color = TRUE
    )
  })
  
  # world map
  output$world_map_plot <- renderGvis({
    selected_year = input$year_slider
    population_of_countries_in_one_year = population_of_countries_df %>%
      select(Country, ends_with(as.character(selected_year)))
    
    gvisGeoChart(
      population_of_countries_in_one_year,
      locationvar = 'Country',
      colorvar = paste0("X", selected_year),
      options = list(
        width = 1000,
        height = 600,
        #backgroundColor = "black",
        colors = "['red', 'orange', 'yellow', 'green', 'blue', 'purple']"
      )
    )
  })
  
  # data table UHI
  output$population_of_one_country_data_table = DT::renderDataTable({
    year = input$year_slider
    p = population_of_countries_df %>% select(Country, ends_with(as.character(year)))
    
    p$UHI = p[, 2]/sum(p[, 2])
    p$UHI = specify_decimal(p$UHI, 4)
    
    population_of_countries_in_one_year = p
    datatable(
      population_of_countries_in_one_year,
      selection = 'single',
      options = list(pageLength = 10, searchHighlight = TRUE)
    ) %>%
      formatStyle('Country',  color = 'blue')
  })
  
  #table tobacco
  output$tobacco_table <- renderTable({
      if(input$gender_input == "Male"){
      tobaccoFilter <- subset(select(data_full,"Country","Tobacco_Year","Male" ),data_full$Tobacco_Year == input$year_input)}
    else{
      tobaccoFilter <- subset(select(data_full,"Country","Tobacco_Year","Female" ),data_full$Tobacco_Year == input$year_input)
    }
    })
  
  # histogram
  output$histogram = renderPlot({
    barplot(data_full$Overweight  ,          
            main="Overweight Children",
            xlab ="Population",
            ylab ="Region",
            names.arg = c(data_full$Country),
            col ="yellow",
            horiz =TRUE)
  })
  
  
})
  

