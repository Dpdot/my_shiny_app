#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Kalkulator odfermentowania"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
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
        ,
          submitButton("Oblicz", icon("beer-mug-empty"))
    ),

        # Show a plot of the generated distribution
        mainPanel(
          htmlOutput("text")
        )
    )
)

# Define server logic required to draw a histogram
count_blg <- function(x,y,z) {
  gest_pocz <- 1/(1-(y/266))
  gest_kon <- 1/(1-(z/266))
  real_gest <- 1/(1-(x/266))
  
  ml_etan <- (y - x)*0.6479762
  
  proc_etan <- ml_etan/(100+ml_etan)
  
  proc_roztr <- 1 - proc_etan
  
  kontrolny <- proc_roztr * real_gest + proc_etan * 0.7892
  wynikowy <- kontrolny - gest_kon
  zwrot <- c(wynikowy,proc_etan)
  return(zwrot)
}

wynik <- function(blg_start,blg_end) {
  real_blg <- blg_end + (blg_start - blg_end)/2
  
  
  zwrot <- count_blg(real_blg,blg_start,blg_end)
  wynikowy <- zwrot[1]
  
  gor <- blg_start
  dol <- blg_end 
  
    while(round(wynikowy,12) != 0) {
      if(wynikowy < 0){
        dol <- real_blg
        real_blg <- real_blg + (gor - real_blg)/2
      } else {
        gor <- real_blg
        real_blg <- real_blg - (real_blg - dol)/2
      }
      
      zwrot <- count_blg(real_blg,blg_start,blg_end)
      wynikowy <- zwrot[1]
      
    }
  zwrot2 <- c(real_blg,zwrot[2])
  return(zwrot2)

}

server <- function(input, output) {

  
  
    output$text <- renderUI({
      re <- reactive({wynik(input$blg_start,input$blg_end)})
      str1 <- paste0("Zawartość alkoholu: ", round(re()[2]*100,2), "%")
      str2 <- paste0("BLG realne: ", round(re()[1],2))
      HTML(paste(str1, str2, sep = '<br/>'))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
