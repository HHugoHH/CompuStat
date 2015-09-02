
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyServer(function(input, output) {
  
 
  
  data  <- reactive({
    divisiones<-input$p
    dimens <- input$nDim
    f <-function(x){
      v <- (1/(2*pi)^(dimens/2))*exp((-1/2)*x^2)
    }
    
    
    trapecio <- function(xi,xi1){
      b<-f(xi)
      B<-f(xi1)
      trap <- (B+b)*h/2
    }
    
    i<-0
    h<-4/divisiones
    areaTotal <-0
    while (i <dimens) {
      j<--2
      while(j<=2){
        areaTotal <- areaTotal + trapecio(j,j+h)
        j<-j+h
      }
      i<-i+1
    }
    monte <- function(){
      x <- rnorm(divisiones)
      k<-0
      fi<-0
      while(k<divisiones){
        fi<-fi+f(x[k])
      }
      st <- (1/divisiones)*fi
      st
    }
    print(areaTotal)
     
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
