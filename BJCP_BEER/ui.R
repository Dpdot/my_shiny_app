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
library(shinydashboard)
library(shinyjs)
library(shinycssloaders)

# lista kategori piwa
bjcp_beer_list <- read_xml("https://raw.githubusercontent.com/meanphil/bjcp-guidelines-2015/master/styleguide.xml")
kategorie <- bjcp_beer_list %>% xml_find_all("//styleguide/class") %>% xml_attr("type")

#lista tagów piwa
tagi <- bjcp_beer_list %>% xml_find_all(".//tags") %>% xml_text()

tagi_all <- c()
for(i in tagi) {
  i_split <- strsplit(i,", ")
  for(j in i_split[[1]]) {
    tagi_all <- append(tagi_all,j)
  } 
}

tagi_uni <- sort(unique(tagi_all))[-7]

    # Application title
  header <- dashboardHeader(title = "Opisy stylów piwnych")

    # Sidebar with a slider input for number of bins
  sidebar <- dashboardSidebar(
        sidebarMenu(
          id = "sidebar",
          menuItem("Wybór stylu", tabName = "style", icon = icon("wheat-awn") ),
                  div( id = "sidebar_1st",
                       conditionalPanel("input.sidebar === 'style'",
                                        selectInput("kategoria", "Wybierz kategorie", kategorie),
                                        uiOutput("grupyUI"),
                                        uiOutput("styleUI"),
                                        hr(),
                                        selectInput("jezyk", "Wybierz język", c("Angielski","Polski")),
                                        actionButton("tlumacz","Tłumacz"),
                                        hr()
                       )),

          menuItem("Wyszukiwarka", tabName = "search", icon = icon("people-robbery")),
          menuItem("Kalkulator BLG", tabName = "calc", icon = icon("calculator"))
          # ,div( id = "sidebar_2nd",
          #      conditionalPanel("input.sidebar === 'calc'",
          #                       sliderInput("blg_start",
          #                                   "BLG początkowe",
          #                                   min = 0,
          #                                   max = 30,
          #                                   value = 15,
          #                                   step = 0.1),
          #                       sliderInput("blg_end",
          #                                   "BLG końcowe",
          #                                   min = -5,
          #                                   max = 15,
          #                                   value = 5,
          #                                   step = 0.1),
          #                       submitButton("Oblicz", icon("beer-mug-empty"))
          #      )
          # )
          )
        )
        

        # Show a plot of the generated distribution
  body <- dashboardBody(
            tabItems(
                tabItem(tabName = "style",
                    h3(textOutput("name")),
                    
                    verbatimTextOutput("info"),
                    
                    h3(textOutput("nazwa1")),
                    withSpinner(textOutput("flavor"),type = getOption("spinner.type", default = 4)),
                    
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
                ),
                
                tabItem(tabName = "search",
                  h2("Wyszukiwarka stylów"),
                  checkboxGroupInput("tag", "cechy stylów",tagi_uni,inline = TRUE,width = '500px'),
                  h3("Lista stylów"),
                  tableOutput("tagi")
                ),
                
                tabItem(tabName = "calc",
                        h2("Kalkulator BLG"),
                        sliderInput("blg_start",
                                    "BLG początkowe",
                                    min = 0,
                                    max = 30,
                                    value = 15,
                                    step = 0.1)
                        ,
                        sliderInput("blg_end",
                                    "BLG końcowe",
                                    min = -5,
                                    max = 15,
                                    value = 5,
                                    step = 0.1)
                        )
            )
                
        )
 

  dashboardPage(header, 
                sidebar, 
                body
  )
