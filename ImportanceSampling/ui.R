
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Muestreo Prioritario"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    sliderInput("n",
                "Number of max simulaciones:",
                min = 100,
                max = 20000,
                value = 7000,
                step = 100),
    sliderInput("lambda",
                "Number of lambda:",
                min = 0,
                max = 5,
                value = 0.5,
                step = 0.1)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Grafica",uiOutput("plots")),#plotOutput("distPlot")),
                tabPanel("Tabla",tableOutput("table"),tableOutput("table2"))
               )
  )
))
