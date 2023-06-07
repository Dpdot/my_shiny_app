#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
## app.R ##
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItemOutput("menuitem1"),
      menuItemOutput("menuitem2")
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "menu",
              fluidRow(
                box(plotOutput("plot1", height = 250)),
                
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "widgets",
              h2("Widgets tab content")
      )
    )
  )
)

server <- function(input, output) {
  
  output$menuitem1 <- renderMenu({
    menuItem("Menu item", tabName= "menu", icon = icon("calendar"),
             div(style="display: inline-block;vertical-align:top; width: 100px;",
                 actionButton("go", "Predict!")),
             div(style="display: inline-block;vertical-align:top; width: 100px;",
                 actionButton("reset", "Clear", style='padding:6px;width:80px')))
  })
  output$menuitem2 <- renderMenu({
    menuItem("Widgets", tabName = "widgets", icon = icon("th"))
  })
  
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)
