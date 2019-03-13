library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {
  output$poverty_vs_police_brutality <- renderPlot({
    shootings_data <- read.csv("data/police_killings.csv", stringsAsFactors = FALSE)
    
    #PERCENT DEATHS OF A CHOSEN RACE, PER STATE
    victim_race <- shootings_data %>% 
      filter(raceethnicity == input$victim_race) %>% 
      group_by(state) %>% 
      count()
    names(victim_race)[2] <- "num_race_victims"
    deaths_by_state <- shootings_data %>% 
      group_by(state) %>% 
      count()
    names(deaths_by_state)[2] <- "num_state_deaths"
    
    deaths_race_and_state <- left_join(victim_race, deaths_by_state)
    deaths_race_and_state <- deaths_race_and_state %>% 
      mutate(percent_race_deaths = num_race_victims / num_state_deaths * 100)
    
    #SHARE POPULATION BY STATE
    state_share_race <- shootings_data %>%
      group_by(state) %>% 
      summarise(
        mean_pop_share = mean(as.numeric(input$chosen_share), na.rm = TRUE),
        mean_pov = mean(as.numeric(pov), na.rm = TRUE)
      )
    
    #COMBINE THE TWO FINAL TABLES
    chosen_data <- left_join(deaths_race_and_state, state_share_race)
    
    #CREATE
    plot <- ggplot(data = chosen_data) +
      geom_point(mapping = aes(x = percent_race_deaths, y = mean_pop_share, color = mean_pov))
    plot
  })
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
  })
})
