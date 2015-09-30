
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
require(plyr)
require(ggplot2)
shinyServer(function(input, output) {
  
  output$plots <- renderUI({
    plot_output_list <- lapply(1:2, function(i) {
      plotname <- paste("plot", i, sep="")
      plotOutput(plotname)
    })
    
    # Convert the list to a tagList - this is necessary for the list of items
    # to display properly.
    do.call(tagList, plot_output_list)
  })##End
  
  
  mC.imporance <-function(N,l){
    results.list <- lapply(N,function(nsim){
      #Usamos el metodo de la funcion inversa
      alpha=0.05
      lambda =l
      U <- runif(nsim,0,1)
      ##Xep <- runif(nsim,0,1)
      #EXP lmbda = 1 truncada a [0,2]
      Y <-  (-1/lambda)*log(1-U*(1-exp(-2*lambda)))

      
      phi <- function(x) 2 *exp(-2*x)
      #la densidad de la exponencial truncada
      fun <- function(x) dexp(x)/(1-exp(-2))
      phiX <- function(x) phi(x) / fun(x)
        
        
      estim2 <- mean(phiX(Y))
      #return (data.frame(N=nsim,Estimate = estim2))
      S2 <- var(phiX(Y))  #Estimar la varianza de phi(X_i)
      quant <- qnorm(alpha/2,lower.tail = FALSE) #cuantil derecho para alpha/2
      int.upper <- estim2 + sqrt(S2/nsim)*quant #intervalo de confianza de arriba
      int.lower <- estim2 - sqrt(S2/nsim)*quant #intervalo de confianza de abajo
      error <- 1-exp(-2) - estim2
      return (data.frame(N=nsim, LI = int.lower,Estimate = estim2,UI = int.upper,Error = error))
    })
    results.table = ldply(results.list)
    return (results.table)
  } 
 

  mc.intervals <- function(Phi,N, sample = runif, alpha = 0.05 ) {
    results.list <- lapply(N, function(nsim){
      #Montecarlo step
      X <- sapply(FUN = sample,nsim) #N samples of the density of X
      PhiX <- sapply(X,Phi) #Evaluate phi at each X_i
      estim <- mean(PhiX) #Estimate int_a^b \phi(x)f(x)df = E[phi(X_i)]
      S2 <- var(PhiX)  #Estimar la varianza de phi(X_i)
      quant <- qnorm(alpha/2,lower.tail = FALSE) #cuantil derecho para alpha/2
      int.upper <- estim + sqrt(S2/nsim)*quant #intervalo de confianza de arriba
      int.lower <- estim - sqrt(S2/nsim)*quant #intervalo de confianza de abajo
      error <- 1-exp(-2) - estim
      return (data.frame(N=nsim, LI = int.lower,Estimate = estim,UI = int.upper,Error = error))
    })
    
    results.table = ldply(results.list)
    return (results.table)
  }
  
  data  <- reactive({
    sim <- input$n
    sample <- function (nsim) runif(nsim,0,2)
    N <- seq(from =100, to= sim,by=100)
    Phi <- function (x) 2* exp(-x)
    mc.intervals(Phi = Phi,N=N,sample = sample)
  }) 
  
  data2 <- reactive({
    sim <- input$n
    l <- input$lambda
    M <- seq(from =100, to= sim,by=100)
    mC.imporance(M,l)
  })
  
  output$plot1 <- renderPlot({
    # MONTERCARLO CRUDO SEGUN MAX SIMULACIONES
    plot(data()$N,data()$Estimate,xlab = "Número máximo de simulaciones", ylab="estimador", main = "Montecarlo crudo")
    abline(h =1-exp(-2), untf = FALSE, col ="red")
    lines(data2()$N,data2()$LI,col="green")
    lines(data2()$N,data2()$UI,col="blue")
  })
  output$plot2 <- renderPlot({
    # MONTECARLO CON IMPORTANCE SAMPLING
    plot(data2()$N,data2()$Estimate,xlab = "Simulaciones", ylab="estimador", main = "Montecarlo Importance")
    lines(data2()$N,data2()$LI,col="green")
    lines(data2()$N,data2()$UI,col="blue")
    abline(h=1-exp(-2), untf = FALSE, col ="red")
  })
  
  output$table <- renderTable({
    data()
  })
  output$table2 <- renderTable({
    data2()
  })
  
})
