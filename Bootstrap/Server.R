
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
require(plyr)
require(ggplot2)
library(boot)
shinyServer(function(input, output) {
  
  
  # Bootstrap 95% CI for regression coefficients 

  # function to obtain regression weights 
  bs <- function(formula, data, indices) {
    d <- data[indices,] # allows boot to select sample 
    fit <- lm(formula, data=d)
    return(coef(fit)) 
  } 
  
  output$plots <- renderUI({
    plot_output_list <- lapply(1:3, function(i) {
      plotname <- paste("plot", i, sep="")
      plotOutput(plotname)
    })
    
    # Convert the list to a tagList - this is necessary for the list of items
    # to display properly.
    do.call(tagList, plot_output_list)
  })##End
  
  data  <- reactive({
    # bootstrapping with 1000 replications 
    results <- boot(data=mtcars, statistic=bs, 
                    R=1000, formula=mpg~wt+disp)
    results
  }) 
  
  output$plot1 <- renderPlot({
      plot(data(), index=1)
  })
  output$plot2 <- renderPlot({
    plot(data(), index=2)
  })
  output$plot3 <- renderPlot({
    plot(data(), index=3)
  })
  
  
  output$summary <- renderPrint({
    boot.ci(data(), type="perc", index=1) # intercept 
  })
  
  output$summary2 <- renderPrint({
    boot.ci(data(), type="perc", index=2) # wt 
  })
  
  output$summary3 <- renderPrint({
    boot.ci(data(), type="perc", index=3) # disp
  })
  
})
