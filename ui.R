# Load Packages
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(leaflet)
library(tidyr)

# Read in Data
police_killings <- read.csv("data/police_killings.csv", stringsAsFactors = F)


# Page one: Intro Page
page_3 <- shinyUI(navbarPage(
  "Police Killings",
  tabPanel(
    "Overview",
    titlePanel("Overview of Police Killings in 2015"),

    tags$head(
      tags$style(HTML("
                    h1 {
                    color: #191970;
                    text-align: center;
                    font-style: bold;
                    font-family: georgia;
                    }
                    h3 {
                    color: #191970;
                    text-align: center;
                    font-size: 20px;
                    font-style: italic;
                    font-family: georgia;
                    }
                    url {
                    text-aling: center;
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
    url <- a("See Our Data Source", href = "
https://github.com/fivethirtyeight/data/blob/master/police-killings/police_killings.csv
    "),

    # An image (`img()`) with no content but the `src` attribute of the url:
    img("", src = "https://static01.nyt.com/images/2012/08/13/nyregion/SHOOT/SHOOT-jumbo.jpg"),



    p(
    "As we explore the data, we seek to answer questions about the story where
    the police have killed Americans in 2015. The questions we seek are",
      strong("who"), "are the victims of police killings in regards to their 
    location, race, and gender, as well as their cause of death?",
    strong("Which"), "states have the highest cause of death and were the
    victims killed in stone cold murder or in self-defense as a result of
    armed?", strong("Which"), "social class has the most death by police?
    Lastly,", strong("which"), "race has the largest percentage of their
    population killed by cops?"
    )
  ),
  # Page 3: Ali's Page

  tabPanel(
    "Map of Police Killings in 2015",
    h1(strong("Map of Police Killings in 2015")),
    p("This map shows victims of police killings in 2015. Below, you can
      colorize the data through either gender, race/ethnicity or cause of
      death. Hovering over data points on the map will display the victims
      name, ethnicity, gender, age and cause of death."),
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
        tableOutput((outputId <- "police_table"))
      )
    )
  ),




  # Page 2: Mackenzie's Page
  tabPanel(
    "Percent of Each Race Killed",
    h1(strong("What Percent of Each Racial Population has Been Killed by
              the Police?")),
    h3(strong("The percentages are sorted by how the victims were armed.")),
    p("Each bar represents a percentage of the population of the race in which
      it is classified. Percentages, rather than a raw count of victims
      by race, "),
    p("allow races to be compared to one another, accounting for the fact that
      different racial populations are different sizes. 
      For example, the bar for "),
    p(strong("victims with firearms"), "in the", strong("Black"), 
      "category shows
      the percentage of the ", strong("total black population"),
      "(across the documented communities)"),
    p("that were killed by police while armed with a firearm. Based on their
      selections, the user will be presented information about which
      races are"),
    p(strong("more affected"), "than others by police killings."),
    sidebarLayout(
      sidebarPanel(
        checkboxGroupInput(
          inputId = "armed_type",
          label = strong("Select how the Victim was Armed:"),
          choices = c("Disputed", "Firearm", "Knife", "No",
                      "Non-lethal firearm",
                      "Other", "Vehicle"),
          selected = c("Disputed", "Firearm", "Knife", "No",
                       "Non-lethal firearm", 
                       "Other", "Vehicle")
        ),
        checkboxGroupInput(
          inputId = "victim_race",
          label = strong("Racial Population the Victim Belongs to:"),
          choices = c("White", "Black", "Hispanic"),
          selected = c("White", "Black", "Hispanic")
        )
      ),
      mainPanel(
        plotlyOutput(outputId = "poverty_vs_police_brutality"),
        p("Keep in mind, the percentages on the y-axis are ",
          strong("very small"), 
          ", because a very small percent of the full population is",
          em("actually", strong("killed")), strong("by police.")),
        p("The percentage measure is for the sake of the ",
          strong("impact on of police killing on racial groups"),
          "being compared,",
          strong("across races."))
      )
    )
  ),
  # Page 4: Nick's Page
  tabPanel(
    "Deaths in Each Economic Class",
    h1(strong("Deaths by Economic Class")),
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
        p("Note: There were no police killings within the Upper
          Class ($350,000 & more)")
      ),
      mainPanel(
        leafletOutput("classplot")
      )
    )
  ),

  # Page 5: Cass's Page
  tabPanel(
    "Cause of Death",
    h1(strong("Relationship Between Cause of Death and Arming of the
              Victim in 2015")),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "select_state",
          label = "Select Your State",
          choices = c(
            "Alabama" = "AL",
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
            "Kentucky" = "KY",
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
            "Wisconsin" = "WI"
          )
        ),
        h5("In 2015, there were 467 deaths that were caused by a police
            officer. On the side, you can analyze the incidents that
            happened in each state. You will also be able to see if the
          victim was armed during the incident and what they were armed with.")
      ),
      mainPanel(
        plotlyOutput("death_cause")
      )
    )
  )
))
