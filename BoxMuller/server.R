
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyServer(function(input, output) {
   
  data  <- reactive({
    u1    <- runif((input$n)/2)
    u2 <- runif((input$n)/2)
    x <- sqrt(-2*log(u1))*cos(2*pi*u2) 
    y <- sqrt(-2*log(u1))*sin(2*pi*u2)
    c(x,y)
  }) 
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    # draw the histogram with the specified number of bins
    hist(data(), col = 'darkgreen', border = 'white')
    
  })
  
  output$summary <- renderPrint({
                    summary(data())
  })
  
  output$table <- renderTable({
    data.frame(x=data())
  })
  
})
