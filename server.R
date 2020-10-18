function(input, output, session){
  
  # render leaflet map
  output$okcmap <- renderLeaflet(
    leaflet(okc_map) %>% 
      addTiles()  %>% 
      setView(lat=37.7609, lng=-122.215, zoom=10) %>%
      addProviderTiles('OpenStreetMap.Mapnik') %>%
      addCircleMarkers(~Longitude, ~Latitude, 
                       fillColor = 'deeppink', fillOpacity = 0.7, color="white", radius= ~n_profiles**(6/16), stroke=FALSE,
                       label = map_tooltip, 
                       labelOptions = labelOptions(
                         style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "14px", direction = "auto")
      )
  )
  # render datatable
  output$datatable <- DT::renderDataTable(
    datatable(okc_dt, rownames=FALSE, 
              options = list(columnDefs = list(list(className = 'dt-center', targets = "_all"))
              ))
  )
  # render demographics plot
  output$dem_plot <- renderPlot({
    okc_dt %>%
      group_by(input$dem_bd_1, sex) %>%
      summarise(count = n()) %>%
      ggplot(aes(x = input$dem_bd_1, y = count, fill = sex)) + 
      geom_col(position = 'dodge') + coord_flip()
  })
  
  # render activeness plot
  output$active_1 <- renderPlot({
    
  })
  
  # render profile completion plot
  output$prof_compl_1 <- renderPlot({
    okc_ques_compl %>%
      ggplot(aes(x = reorder(question, desc(percentage)), y = percentage)) + geom_col(color = 'grey', fill = 'deeppink', alpha=0.7)
  })
}