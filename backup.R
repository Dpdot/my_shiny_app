#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(xml2)
library(dplyr)

# Define UI for application that draws a histogram
bjcp_beer_list <- read_xml("https://raw.githubusercontent.com/meanphil/bjcp-guidelines-2015/master/styleguide.xml")
kategorie <- bjcp_beer_list %>% xml_find_all("//styleguide/class") %>% xml_attr("type")
fluidPage(
  
  # Application title
  titlePanel("Opisy stylów piwnych"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("kategoria", "Wybierz kategorie", kategorie),
      uiOutput("grupyUI"),
      uiOutput("styleUI"),
      hr(),
      selectInput("jezyk", "Wybierz język", c("Angielski","Polski")),
      actionButton("tlumacz","Tłumacz")
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      h3(textOutput("name")),
      
      verbatimTextOutput("info"),
      
      h3(textOutput("nazwa1")),
      textOutput("flavor"),
      
      h3(textOutput("nazwa2")),
      textOutput("appearance"),
      
      h3(textOutput("nazwa3")),
      textOutput("mouthfeel"),
      
      h3(textOutput("nazwa4")),
      textOutput("impression"),
      
      h3(textOutput("nazwa5")),
      textOutput("comments"),
      
      h3(textOutput("nazwa6")),
      textOutput("history"),
      
      h3(textOutput("nazwa7")),
      textOutput("ingredients"),
      
      h3(textOutput("nazwa8")),
      textOutput("comparison"),
      
      h3(textOutput("nazwa9")),
      textOutput("examples"),
      
      h3(textOutput("nazwa10")),
      textOutput("instructions"),
    )
  )
)
