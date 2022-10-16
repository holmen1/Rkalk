# PARAMETERS.R
# 
# allParameters(kalkyldatum, grund, sex, birth,typ='TJP1')
#   
# delta(t, Rate, skatt, epsDelta)
#   
# nssRate(t, Rate, omega = 100)
#   
# Disc(nu, t, Rate, skatt, epsDelta)
#  


initConstants <- function() {
  # maxAge = initConstants()
  maxAge <- 115
}

allParameters <- function(kalkyldatum, grund, sex, birth, typ='TJP1') {
  # mu = a + b*exp(cx)
  # grund in ['PRES', ...]
  # sex in ['m', 'f']
  # typ in ['TJP1', ...]
  # tax in ['K', 'P']

  a <- 0
  b <- 0
  c <- 0
  make <- list("a"=a, "b"=b, "c"=c*log(10))

  data <- read.csv('Data/SE_Cash_Return_FTA_2022-06-30.csv')
  Rate <- data$Aktsam_Trad
  Rate <- rep(0.02, 901)

  skatt <- 0.0
  epsKostnad <- 0.00 #Intensitet
  
  rate <- list("Rate"=Rate, "skatt"=skatt, "epsKostnad"=epsKostnad)
  
  list("rate"=rate,"Make"=make)
}

  
# Rate intensity, cost and tax added
delta <- function(t, Rate, skatt, epsDelta) {
  
  grossRate <- log(1 + Rate[t + 1])
  
  # Correction of intensity
  grossRate*(1-skatt) - epsDelta
}


Disc <- function(nu, t, Rate, skatt, epsDelta) {
  exp(nu*delta(nu, Rate, skatt, epsDelta) - t*delta(t, Rate, skatt, epsDelta))
}


