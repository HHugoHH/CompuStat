setwd("C:/Users/TheCruzader/Downloads")
library(foreign)
library(mvtnorm)

table <- read.dta("datos_politicos.dta") # LEEMOS LOS DATOS DE FORMATO STATA
año <- 1986 # POR EL MOMENTO ESCOJAMOS UN SOLO AÑO PUES NO SABEMOS NADA DE DATOS PANEL
data <- table[table$year==año, ]
labels <- paste(names(data), attributes(data)$var.labels, sep=": ") # NOMBRES DE LAS VARIABLES

Y <- data$reg # INDICADORA DE SI SE ES O NO UNA DEMOCRACIA
list.depend <- c("level", "open", "g", "strikes", "govpwt", "ls", "invpwt",
                 "fertil", "lfagric", "popg", "femsec", "EnergProd") # VARIABLES ECONÓMICAS EXPLICATIVAS



X <- subset(data, select=list.depend)

for(j in 1:ncol(X)) X[, j] <- as.numeric(X[,j])   

row.names(X) <- data$name

X.comp <- X[complete.cases(X),]
nrow(X.comp)

view(X.comp)

View(round(cor(X.comp),2))

data.full <- data.frame(Y)





nrows <- nrow(X)
ncols <- ncol(X)
m = 5
tol <- 1e-3
res <-list()
imputed.sets <- list()
pred.success <- numeric(m)
#rep = 1

for (rep in 1:m){
  #BOOTSTRAP
  print(paste("Bootstrap: ", rep))
  samp <- sample (1:nrows, nrows, replace=TRUE)
  xb <- X[samp,]
  
  #inicializacion:
  
  M<- is.na(xb)
  
  Sigma <- cov(xb[complete.cases(xb),])
  sd.vec <- sqrt(diag(Sigma))
  mu <- apply(xb[complete.cases(xb),],2,mean)
  for(i in 1:nrows) for(j in 1:ncols) if(M[i,j]) xb[i,j] <- rnorm(1,mu[j],sd.vec[j])
  logv <- sum(apply(xb,1, function(row) log(dmvnorm(row,mu,Sigma))))
  #ITERACION
  iter <-1
  repeat{
    #valor actual de la verosiilitud
    #iteraciones por variables
    for(j in 1:ncol(xb)){
      int <- as.matrix(xb[,j], ncol-1)
      dep <- as.matrix(xb[,-j])
      mod <- lm(int ~ dep)
      pred <- predict(mod)
      xb[M[,j],j] <- pred[M[,j]]
    }
    Sigma <- cov(xb)
    mu <- apply(xb, 2, mean)
    logv[iter+1] <- sum(apply(xb, 1, function(row) log(dmvnorm(row,mu,Sigma))))
    #print (abs(logv[iter+1]-logv[iter])<tol)
    if(abs(logv[iter+1]-logv[iter])<tol) break
    iter <- iter +1
  }
  print(paste("    - iteraciones totales: ", iter))
  imputed.sets[[rep]]<- xb
  #GRAFICA
  plot(logv[-1], type="l", col="blue", main=paste("Bootstrap", rep))
  #MODELO
  data.full <- data.frame(Y[samp],xb)
  names(data.full)[1] <- "Y"
  res[[rep]] <- glm(Y ~ ., data=data.full, family="binomial")
  
  guess <- round(predict(res[[rep]],type="response"))
  pred.success[rep]<- sum(guess==data.full$Y)/nrows
  
  
}




