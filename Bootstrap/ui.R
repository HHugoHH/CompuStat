
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
    # Application title
    headerPanel("Bootstrap Percentile Method Example by Hugo Huipet"),
    
    # Sidebar with a slider input for number of bins
    sidebarPanel(
      h2("Motor Trend Car Road Tests data"),
      p("The data was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973–74 models).")
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  #tabPanel("Graficas",uiOutput("plots")),
                  tabPanel("Intercept","Gráfica",plotOutput("plot1"),"Resumen",verbatimTextOutput("summary")),
                  tabPanel("wt","Gráfica",plotOutput("plot2"),"Resumen",verbatimTextOutput("summary2")),
                  tabPanel("disp","Gráfica",plotOutput("plot3"),"Resumen",verbatimTextOutput("summary3"))
                 # tabPanel("Resumen intercept",),
                  #tabPanel("Grafica wt",plotOutput("plot2")),
                  #tabPanel("Resumen wt",verbatimTextOutput("summary2")),
                  #tabPanel("Grafica disp",plotOutput("plot3")),
                  #tabPanel("Resumen disp",verbatimTextOutput("summary3"))
                  #tabPanel("Resumen",verbatimTextOutput("summary"),verbatimTextOutput("summary2"),verbatimTextOutput("summary3"))
      )
    )
  )
  
)
              