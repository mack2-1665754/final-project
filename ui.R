library(shiny)
library(dplyr)
library(ggplot2)
shootings_data <- read.csv("data/police_killings.csv")
# Page one: Intro Page

#Page 3: Ali's Page
page_one <- tabPanel(
  "Does Police Brutality Have to do With Poverty Rates?",
  titlePanel("Racial Distribution by State"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "chosen_share",
        label = "Select A share",
        choices = c(
          "share_white",
          "share_black",
          "share_hispanic"
        )
      ),
      selectInput (
        inputId = "victim_race",
        label = "Race of Victim",
        choices = distinct(shootings_data, raceethnicity, .keep_all = FALSE)
      )
    ),
    mainPanel(
      plotOutput(outputId = "poverty_vs_police_brutality")
    )
  )
)
#Page 2: Ken's Page

#Page 4: Nick's Page

#Page 5: Cass's Page