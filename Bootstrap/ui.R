
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(
  
  mainPanel(
    tabsetPanel(type = "tabs",
                #tabPanel("Graficas",uiOutput("plots")),
                tabPanel("Grafica intercept",plotOutput("plot1")),
                tabPanel("Resumen intercept",verbatimTextOutput("summary")),
                tabPanel("Grafica wt",plotOutput("plot2")),
                tabPanel("Resumen wt",verbatimTextOutput("summary2")),
                tabPanel("Grafica disp",plotOutput("plot3")),
                tabPanel("Resumen disp",verbatimTextOutput("summary3"))
                #tabPanel("Resumen",verbatimTextOutput("summary"),verbatimTextOutput("summary2"),verbatimTextOutput("summary3"))
    )
  )
  
  
)
              