
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyServer(function(input, output) {
   
  data  <- reactive({
    x    <- runif(input$u)
    lambda <- input$lambda
    (1/lambda)*log(1/(1-x))  
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
