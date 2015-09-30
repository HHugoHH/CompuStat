
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
require(plyr)
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
  
  
  mC.imporance <-function(N){
    results.list <- lapply(N,function(nsim){
      #Usamos el metodo de la funcion inversa
      nsim = 10000
      U <- runif(nsim,0,2)
      #EXP lmbda = 1 truncada a [0,2]
      fun <- function(x) -log(1-(1-exp(-2))*x)
      
      phi <- function(x) 2 *exp(-x)
      #la densidad de la exponencial truncada
      phiX <- function(x) phi(x) / fun(x)
      estim2 <- mean(phiX(U))
      return (data.frame(N=nsim,Estimate = estim2))
      #S2 <- var(phiX)  #Estimar la varianza de phi(X_i)
      #quant <- qnorm(alpha/2,lower.tail = FALSE) #cuantil derecho para alpha/2
      #int.upper <- estim2 + sqrt(S2/nsim)*quant #intervalo de confianza de arriba
      #int.lower <- estim2 - sqrt(S2/nsim)*quant #intervalo de confianza de abajo
      #error <- 1-exp(-2) - estim2
      #return (data.frame(N=nsim, LI = int.lower,Estimate = estim2,UI = int.upper,Error = error))
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
    N <- seq(from =1000, to= sim,by=1000)
    Phi <- function (x) 2* exp(-x)
    mc.intervals(Phi = Phi,N=N,sample = sample)
  }) 
  
  data2 <- reactive({
    sim <- input$n
    M <- seq(from =1000, to= sim,by=1000)
    mC.imporance(M)
  })
  
  output$plot1 <- renderPlot({
    #ERROR MONTERCARLO CRUDO SEGUN MAX SIMULACIONES
    plot(data()$N,data()$Error,type = "line",xlab = "Número máximo de simulaciones", ylab="Error")
    abline(h =0, untf = FALSE, col ="red")
  })
  output$plot2 <- renderPlot({
    #ERROR MONTECARLO CON IMPORTANCE SAMPLING
    #plot(data2()$N,data()$Error,type = "line",xlab = "Simulaciones", ylab="Error")
    #abline(h =0, untf = FALSE, col ="red")
  })
  
  output$table <- renderTable({
    data()
  })
  output$table2 <- renderTable({
    data2()
  })
  
})
