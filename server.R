function(input, output){
  
  # render leaflet map
  output$okcmap <- renderLeaflet(
    leaflet(okc_map) %>% 
      addTiles() %>% 
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
  # render demographics plot 1
  output$dem_plot_1 <- renderPlot({
    if(input$dem_options != input$dem_options_2) {
      okc_dt %>%
        group_by(.data[[input$dem_options]], .data[[input$dem_options_2]]) %>%
        summarise(num = n()) %>%
        ggplot(aes(x = .data[[input$dem_options]], y = num, fill = .data[[input$dem_options_2]])) + 
        geom_col(position = 'dodge')
    } else { 
      okc_dt %>%
        group_by(.data[[input$dem_options]]) %>%
        summarise(num = n()) %>%
        ggplot(aes(x = .data[[input$dem_options]], y = num)) + 
        geom_bar(stat = 'identity', fill = 'deeppink', alpha = 0.75)
    }
  })
  
  
  # render demographics plot 2
  output$dem_plot_2 <- renderPlot({
    if(input$dem_options != input$dem_options_2) {
      okc_dt %>%
        group_by(.data[[input$dem_options]], .data[[input$dem_options_2]]) %>%
        summarise(num = n()) %>%
        ggplot(aes(x = .data[[input$dem_options]], y = num, fill = .data[[input$dem_options_2]])) + 
        geom_col(position = 'fill') + coord_flip()
    } else { 
      okc_dt %>%
        group_by(.data[[input$dem_options]]) %>%
        summarise(num = n()) %>%
        ggplot(aes(x = .data[[input$dem_options]], y = num)) + 
        geom_bar(position = 'fill', stat = 'identity', fill = 'deeppink', alpha = 0.75) + coord_flip()
    }
  })
  
  # render demographics plot titles
  output$dem_title_1 <- renderText({
    if(input$dem_options != input$dem_options_2) {
      print(paste('User Count by', str_to_title(input$dem_options),'&', str_to_title(input$dem_options_2)))
    } else {
      print(paste('User Count by', str_to_title(input$dem_options)))
    }
  })
  
  output$dem_title_2 <- renderText({
    if(input$dem_options_2 != input$dem_options) {
      print(paste('User', str_to_title(input$dem_options_2), 'Proportions by', str_to_title(input$dem_options)))
    } else {
      print(paste('User', str_to_title(input$dem_options_2), 'Proportions'))
    }
  })
  
  output$dem_title_1 <- renderText({
    print(paste('User Count by', str_to_title(input$dem_options),'&', str_to_title(input$dem_options)))
  })
  
  # render activeness plot
  output$active_1 <- renderPlot({
    okc_dt %>%
      group_by(activeness) %>%
      summarise(num = n()) %>%
      ggplot(aes(x = reorder(activeness, desc(num)), y = num)) + 
      geom_col(fill = 'deeppink', alpha = 0.75) + xlab('Activeness')
  })
  
  # render activeness plot
  output$active_2 <- renderPlot({
    okc_dt %>%
      group_by(activeness, .data[[input$dem_options_3]]) %>%
      summarise(num = n()) %>%
      ggplot(aes(x = reorder(activeness, desc(num)), y = num, fill = .data[[input$dem_options_3]])) + 
      geom_col(position = 'fill', alpha = 0.75) + coord_flip() + xlab('Activesness') + ylab('percent')
  })
  
  # render activeness chi-squre test (will work on this later...)
# okc_dt %>%
#   group_by(activeness,age) %>%
#   summarise(num = n()) %>% 
#   pivot_wider(names_from = age, values_from = num) %>%

  # render profile completion plot
  output$prof_compl_1 <- renderPlot({
    okc_ques_compl %>%
      ggplot(aes(x = reorder(question, desc(percentage)), y = percentage)) + 
      geom_col(fill = 'deeppink', alpha = 0.75) + xlab('Question')
  })
  
  # render profile completion plot
  output$prof_compl_2 <- renderPlot({
    okc_dt %>%
      group_by(.data[[input$dem_options_4]]) %>%
      summarise(avg_n_q = mean(total_answs)) %>%
      ggplot(aes(x = .data[[input$dem_options_4]], y = avg_n_q)) + 
      geom_col(fill = 'deeppink', alpha = 0.75) + coord_flip() + ylab('Average # of questions answered')
  })
}