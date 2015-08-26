
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    sliderInput("u",
                "Number of u:",
                min = 1,
                max = 3000,
                value = 600),
    sliderInput("lambda",
                "Number of lambda:",
                min = 1,
                max = 300,
                value = 60)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot"),
    dataTableOutput("table")
  )
))
