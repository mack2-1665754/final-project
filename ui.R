# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(leaflet)

# Read in Data
police_killings <- read.csv("data/police_killings.csv", stringsAsFactors = F)


# Page one: Intro Page
page_3 <- shinyUI(navbarPage(
  "Police Killings",
  tabPanel("Overview",
           titlePanel("Overview of Police Killings in 2015"),
  
  tags$head(
    tags$style(HTML("
                    h1 {
                    color: #191970;
                    text-align: center;
                    font-style: bold;
                    font-family: georgia;
                    }
                    h2 {
                    color: #191970;
                    text-align: center;
                    font-size: 20px;
                    font-style: italic;
                    font-family: georgia;
                    }
                    p {
                    color:#191970;
                    text-align: center;
                    font-size: 18px;
                    padding-right: 50px;
                    padding-left: 50px;
                    font-family: georgia;
                    }
                    img {
                    height: 500px;
                    width: 600px;
                    padding-bottom: 20px;
                    display: block;
                    margin-left: auto;
                    margin-right: auto;
                    
                    }
                    
                    "))
    ),
  
  
  # A first-level header (`h1()`) with the content "First Shiny Website"
  h1("Police Killing Americans in 2015"),
  h2("Data from the Github database FiveThirtyEight"),
  
  # An image (`img()`) with no content but the `src` attribute of the url:
  img("", src = "https://dailygazette.com/sites/default/files/styles/gallery_image/public/2017-06/ms12prb_0.jpg?itok=ODRf8lW1"),
  
  
  
  p("As we explore the data, we seek to answer questions about the story where
    the police have killed Americans in 2015. The questions we seek are", 
    strong("who"), "are the victims of police killings in regards to their 
    location, race, and gender, as well as their cause of death?", strong("Which"), "states 
    have the highest cause of death and were the victims killed in 
    stone cold murder or in self-defense as a result of armed?", strong("Which"),
    "social class has the most death by police? Lastly,", strong("which"), 
    "race has the largest percentage of their population killed by cops?")
  ),
#Page 3: Ali's Page

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
tabPanel("Deaths in Each Economic Class",
titlePanel("Deaths by Economic Class"),
sidebarLayout(
  sidebarPanel(
    selectInput("class",
                "Which economic class?",
                choices = c(
                  "All",
                  "Poverished Class [$0-30,000)" = "poor",
                  "Lower-Middle Class [$30,000-50,000)" = "low",
                  "Middle Class [$50,000-100,000)" = "middle",
                  "Upper-Middle Class [$100,000-350,000)" = "upper"
                ),
                selected = "All"
    ),
    p("Note: There were no police killings within the Upper Class ($350,000 & more)")
  ),
  mainPanel(
    leafletOutput("classplot")
  )
)
),

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
      textOutput("message"),
      h5("In 2015, there were 467 deaths that were caused by a police officer. 
     On the side, you can analyze the incidents that happened in each state. 
        You will also be able to see if the victim was armed during the incident and what they were armed with.")
    ),
    mainPanel(
      plotlyOutput("death_cause"))
  ))))

