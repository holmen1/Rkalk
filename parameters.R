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
  Rate <- 0.03

  skatt <- 0.0
  epsKostnad <- 0.00 #Intensitet
  
  rate <- list("Rate"=Rate, "skatt"=skatt, "epsKostnad"=epsKostnad)
  
  list("rate"=rate,"Make"=make)
}

  
# Rate intensity, cost and tax added
delta <- function(t, Rate, skatt, epsDelta) {
  
  grossRate <- Rate
  
  # Correction of intensity
  grossRate*(1-skatt) - epsDelta
}


Disc <- function(t, Rate, skatt, epsDelta) {
  exp(-t*delta(t, Rate, skatt, epsDelta))
}


