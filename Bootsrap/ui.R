
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Aproximacion del calculo de integra en N dimensiones, por montecarlo y el metodo del trapecio"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    #radioButtons("method","Metodo: ",c("Montecarlo"="m","Trapecio"="T")),
    sliderInput("p",
                "Número de Particiones:",
                min = 1,
                max = 1000,
                value = 100),
    numericInput("nDim","Dimensiones","1")
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
