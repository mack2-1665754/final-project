# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(devtools)
library(stringr)
library(leaflet)

police_killings <- read.csv("police_killings.csv", stringsAsFactors = F)

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
  })
})



