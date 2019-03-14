# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(devtools)
library(stringr)
library(leaflet)

police_killings <- read.csv("data/police_killings.csv", stringsAsFactors = F)

# Cassidy's Code
shinyServer(function(input, output) {
  output$death_cause <- renderPlotly({
    death_data <- police_killings %>%
      select(cause, armed, state, name, age) %>%
      filter(state == input$select_state)%>%
      group_by(cause, armed, state) %>%
      count()
    title <- paste0("Cause of Death and Arming of the Victim in ", input$select_state)
    death_plot <- plot_ly(
      data = death_data,
      x = ~cause,
      y = ~n,
      color = ~armed,
      type = "bar",
      alpha = .7) %>%
      layout(
        title = title,
        xaxis = list(title = "Cause of Death"),
        yaxis = list(title = "Total Deaths"),
        legend = c("Armed"),
        showlegend = T,
        barmode = "stack"
      )
    death_plot
  })
  output$message <- renderText({
    death_sum <- death_data %>%
      filter(state == input$select_state)%>%
      group_by(state) %>%
      summarise(state_total = sum(n))
    msg <- paste("In ", input$select_state, "there were a total of ", death_sum$state_total, " deaths by a police officer.")
  }) # Ali's Code
  output$police_map <- renderLeaflet({
    palette1 <- colorFactor(
      palette = "Dark2", 
      domain = police_killings[[input$analysis]]
    )
    leaflet(data = police_killings) %>% 
      addProviderTiles("OpenStreetMap.Mapnik") %>% 
      addCircleMarkers(
        lat = ~latitude,
        lng = ~longitude,
        label = ~paste0("Victim: ", name, ". ", raceethnicity, " ", gender, " age ", age, ". ", "Cause of death: ", cause, "."),
        color = ~palette1(police_killings[[input$analysis]]),
        fillOpacity = .5,
        radius = 3,
        stroke = F
      ) %>% 
      addLegend(
        position = "bottomleft",
        title = input$analysis,
        pal = palette1,
        values = police_killings[[input$analysis]],
        opacity = 1
      )
  })
  output$police_table <- renderTable({
    table1 <- police_killings %>% 
      group_by(police_killings[[input$analysis]]) %>% 
      count()
    colnames(table1) <- c(input$analysis, "Number of Victims")
    table1
  }) #Nick's Code
  output$classplot <- renderLeaflet({
    color_palette <- colorFactor(
      palette = "RdYlBu",
      domain = police_killings$raceethnicity
    )
    
    if(input$class == "All"){
      msg <- paste0("In the United States in 2015, there were ", nrow(police_killings), " police killings")
    } else if(input$class == "poor"){
      police_killings <- police_killings %>% 
        filter(h_income < 30000)
      msg <- paste0("In the United States in 2015, there were ", nrow(police_killings), 
                    " police killings within the poverished class")
    } else if(input$class == "low"){
      police_killings <- police_killings %>% 
        filter(h_income >= 30000 & h_income < 50000)
      msg <- paste0("In the United States in 2015, there were ", nrow(police_killings), 
                    " police killings within the lower-middle class")
    } else if(input$class == "middle"){
      police_killings <- police_killings %>% 
        filter(h_income >= 50000 & h_income < 100000)
      msg <- paste0("In the United States in 2015, there were ", nrow(police_killings), 
                    " police killings within the middle class")
    } else if(input$class == "upper"){
      police_killings <- police_killings %>% 
        filter(h_income >= 100000 & h_income < 350000)
      msg <- paste0("In the United States in 2015, there were ", nrow(police_killings), 
                    " police killings within the upper-middle class")
    }
    
    leaflet(data = police_killings) %>% 
      addProviderTiles("OpenStreetMap.Mapnik") %>% 
      addCircleMarkers(
        lat = ~latitude,
        lng = ~longitude,
        label = ~paste(name, "," , age, "," , gender, "," , "House Income:", h_income),
        color = ~color_palette(police_killings$raceethnicity),
        fillOpacity = .5,
        radius = 3,
        stroke = F
      ) %>% 
      addLegend(
        position = "bottomright",
        title = "Race",
        pal = color_palette,
        values = police_killings$raceethnicity,
        opacity = 1
      )
  })
})



