
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("BoxMuller"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    sliderInput("n",
                "Number of n points:",
                min = 1,
                max = 1000,
                value = 500)
      ),
  
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Grafica",plotOutput("distPlot")),
                tabPanel("Tabla",tableOutput("table")),
                tabPanel("Resumen",verbatimTextOutput("summary"))
               )
  )
))
