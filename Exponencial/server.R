
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- runif(input$u,0,1)
    lambda <- input$lambda
    exp  <- (1/lambda)*log(1/(1-x))
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(exp, col = 'darkgreen', border = 'white')
    
  })
  output$table <- renderDataTable({
    x    <- runif(input$u,0,1)
    lambda <- input$lambda
    exp  <- (1/lambda)*log(1/(1-x))
    data <- exp
    
    data
  })
  
})
