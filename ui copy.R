library("shiny")

ui <- fluidPage(
  
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
                    font-size: 15px;
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
    strong("who"), "are the victims to police killings in regards to their 
    location, ethnicity, gender as well as their cause of death?", strong("Which"), "states 
    have the highest cause of deaths and whether the victims were killed in 
    stone cold murder or in self-defense as a result of whether or not they were
    armed.", strong("Which"), "social class has the most deaths by cops. 
    Lastly,", strong("which"), "race has the largest percentage of their population
    killed by cops.")
  
  )
shinyUI(ui)

