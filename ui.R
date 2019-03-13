# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# Read in Data
police_killings <- read.csv("police_killings.csv", stringsAsFactors = F)


# Page one: Intro Page


#Page 3: Ali's Page
page_3 <- shinyUI(navbarPage(
  "Police Killings",
  tabPanel("Map of Police Killings in 2015",
  titlePanel("Map of Police Killings in 2015"),
  h5("This map shows victims of police killings in 2015. Below, you can colorize the data through either gender, 
     race/ethnicity or cause of death. Hovering over data points on the map will display the victims name, ethnicity, gender,
     age and cause of death."),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "analysis",
        label = "Select a unit of analysis",
        choices = c("gender", "race" = "raceethnicity", "cause")
      )
    ),
    mainPanel(
      leafletOutput(outputId = "police_map"),
      tableOutput((outputId = "police_table")))
  )
    ),




#Page 2: Ken's Page

#Page 4: Nick's Page

#Page 5: Cass's Page
  tabPanel(
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
      h5("In 2015, there were 467 deaths that were caused by a police officer. 
     On the side, you can analyze the incidents that happened in each state. 
        You will also be able to see if the victim was armed during the incident and what they were armed with.")
    ),
    mainPanel(
      plotlyOutput("death_cause"))
  ))))

