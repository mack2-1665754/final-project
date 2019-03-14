# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(devtools)
library(stringr)
library(leaflet)
library(tidyr)


police_killings <- read.csv("data/police_killings.csv", stringsAsFactors = F)

# Cassidy's Code
shinyServer(function(input, output) {
  output$death_cause <- renderPlotly({
    death_data <- police_killings %>%
      select(cause, armed, state, name, age) %>%
      filter(state == input$select_state) %>%
      group_by(cause, armed, state) %>%
      count()
    title <- paste0("Cause of Death and Arming of the Victim in ",
                    input$select_state)
    death_plot <- plot_ly(
      data = death_data,
      x = ~cause,
      y = ~n,
      color = ~armed,
      type = "bar",
      alpha = .7
    ) %>%
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
        label = ~ paste0("Victim: ", name, ". ", raceethnicity, "
                         ", gender, " age ", age, ". ", "Cause of death: ",
                         cause, "."),
        color = ~ palette1(police_killings[[input$analysis]]),
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
  }) # Nick's Code
  output$classplot <- renderLeaflet({
    color_palette <- colorFactor(
      palette = "RdYlBu",
      domain = police_killings$raceethnicity
    )

    if (input$class == "All") {
      msg <- paste0("In the United States in 2015, there were ",
                    nrow(police_killings), " police killings")
    } else if (input$class == "poor") {
      police_killings <- police_killings %>%
        filter(h_income < 30000)
      msg <- paste0(
        "In the United States in 2015, there were ", nrow(police_killings),
        " police killings within the poverished class"
      )
    } else if (input$class == "low") {
      police_killings <- police_killings %>%
        filter(h_income >= 30000 & h_income < 50000)
      msg <- paste0(
        "In the United States in 2015, there were ", nrow(police_killings),
        " police killings within the lower-middle class"
      )
    } else if (input$class == "middle") {
      police_killings <- police_killings %>%
        filter(h_income >= 50000 & h_income < 100000)
      msg <- paste0(
        "In the United States in 2015, there were ", nrow(police_killings),
        " police killings within the middle class"
      )
    } else if (input$class == "upper") {
      police_killings <- police_killings %>%
        filter(h_income >= 100000 & h_income < 350000)
      msg <- paste0(
        "In the United States in 2015, there were ", nrow(police_killings),
        " police killings within the upper-middle class"
      )
    }

    leaflet(data = police_killings) %>%
      addProviderTiles("OpenStreetMap.Mapnik") %>%
      addCircleMarkers(
        lat = ~latitude,
        lng = ~longitude,
        label = ~ paste(name, ",", age, ",", gender, ",",
                        "House Income:", h_income),
        color = ~ color_palette(police_killings$raceethnicity),
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
  }) # Mackenzie's code
  output$poverty_vs_police_brutality <- renderPlotly({
    available_races <- c("White", "Black", "Hispanic/Latino")
    # Calculate the total population for each race, out of the communities
    #where police killings have occurred
    pops_by_race <- police_killings %>%
      select(pop, share_white, share_black, share_hispanic) %>%
      mutate(
        "white_pop" = as.numeric(pop) * (as.numeric(share_white) / 100),
        "hispanic_pop" = as.numeric(pop) * (as.numeric(share_black) / 100),
        "black_pop" = as.numeric(pop) * (as.numeric(share_hispanic) / 100)
      ) %>%
      summarise(
        total_white_pop = sum(white_pop, na.rm = TRUE),
        total_black_pop = sum(black_pop, na.rm = TRUE),
        total_hispanic_pop = sum(hispanic_pop, na.rm = TRUE)
      )
    # Divide the number of each subgroup by the appropriate racial
    # population, to calculate what percentage of each racial population
    # that subgroup represents.
    # For example, what perce nt of the white population is killed by the
    # police without being armed?

    # Select the races for which we have available 'population share' data
    # i.e. white, black, and hispanic, because there are
    # share_white, share_black, and share_hispanic columns
    perc_total_pop <- police_killings %>%
      filter(raceethnicity %in% available_races) %>%
      group_by(raceethnicity, armed) %>%
      count() %>%
      group_by(armed)

    # Take the races in the 'raceethnicity' column, and make them
    # columns containing the count of victims, according to each type of arming
    spread_p_total_pop <- spread(
      perc_total_pop,
      key = raceethnicity,
      value = n
    )
    # Rename the Hispanic/Latino coumn to Hispanic, so R does not think
    # we are trying to treat Hispanic and Latino as two variables, and
    # divide them by one another
    names(spread_p_total_pop)[3] <- "Hispanic"
    # Take the 'spread' version of the data, and use the population
    # totals by race to calculate the percent of each racial population
    # that was killed, according to each type of arm they had
    spread_p_total_pop <- spread_p_total_pop %>%
      mutate(
        "Black" = Black / pops_by_race$total_black_pop,
        "White" = White / pops_by_race$total_white_pop,
        "Hispanic" = Hispanic / pops_by_race$total_hispanic_pop
      ) %>%
      select(armed, White, Black, Hispanic)
    # Take the data with the percentage of populations calculated,
    # and and use gather to make a coumn for the firearm type, racial group
    # and percentage of the total population of a given race,
    # which that subgroup of victims represents.
    final_df <- gather(
      spread_p_total_pop,
      key = racial_group,
      value = perc_of_pop,
      -armed
    ) %>%
      filter(racial_group %in% input$victim_race) %>%
      filter(armed %in% input$armed_type)

    # Create a plot which visually represents this
    plot <- ggplot(final_df) +
      geom_col(mapping = aes(x = racial_group, y = perc_of_pop, fill = armed),
               position = "dodge") +
      labs(
        title = "Percent of Each Racial Population Killed by the Police",
        x = "Victim Racial group",
        y = "% of the Each Racial Population Killed by Police",
        fill = "How the Victim was Armed"
      )
    plot <- ggplotly(plot)
    plot
  })
})
