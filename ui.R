library(shiny)
library(dplyr)
library(ggplot2)
shootings_data <- read.csv("data/police_killings.csv")
# Page one: Intro Page
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

#Page 3: Ali's Page

#Page 2: Ken's Page

#Page 4: Nick's Page

#Page 5: Cass's Page
page_two <- shinyUI(fluidPage(
  "Cause of Death",
  titlePanel("Relationship Between Cause of Death and Arming of the Victim in 2015"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "select_state",
        label = "Select Your State",
        choices = c("Alabama" = "AL",
                    "Alaska" = "AK",
                    "Arizona" = "AZ",
                    "Arkansas" = "AR",
                    "California" = "CA",
                    "Colorado" = "CO",
                    "Connecticut" = "CT",
                    "Delware" = "DE",
                    "Washington D.C" = "DC",
                    "Florida" = "FL",
                    "Georgia" = "GA",
                    "Hawaii" = "HI",
                    "Idaho" = "ID",
                    "Illinois" = "IL",
                    "Indiana" = "IN",
                    "Iowa" = "IA",
                    "Kansas" = "KS",
                    "Kentucky" = 'KY',
                    "Louisiana" = "LA",
                    "Maine" = "ME",
                    "Mchigan" = "MI",
                    "Minnesota" = "MN",
                    "Mississippi" = "MS",
                    "Missouri" = "MO",
                    "Montana" = "MT",
                    "Nebraska" = "NE",
                    "Nevada" = "NV",
                    "New Hampshire" = "NH",
                    "New Jersey" = "NJ",
                    "New Mexico" = "NM",
                    "New York" = "NY",
                    "North Carolina" = "NC",
                    "Ohio" = "OH",
                    "Oklahoma" = "OK",
                    "Oregon" = "OR",
                    "Pennsylvania" = "PA",
                    "South Carolina" = "SC",
                    "Tennessee" = "TN",
                    "Texas" = "TX",
                    "Utah" = "UT",
                    "Virginia" = "VA",
                    "Washington" = "WA",
                    "West Virgina" = "WV",
                    "Wisconsin" = "WI")),
      textOutput("message"),
      h5("In 2015, there were 467 deaths that were caused by a police officer. 
     On the side, you can analyze the incidents that happened in each state. 
        You will also be able to see if the victim was armed during the incident and what they were armed with.")
    ),
    mainPanel(
      plotlyOutput("death_cause"))
  )))
