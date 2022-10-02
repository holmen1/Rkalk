source('./parameters.R')
source('./kommutationsFunktioner.R')
source('./miscFunctions.R')
source('./managFunctions.R')


#
  kalkyldatum <- as.Date('2017-07-31', '%Y-%m-%d')
  birth.ff <- as.Date('1967-07-31', '%Y-%m-%d')
  sex.ff <- 'm'
  pensions.alder <- 65
  gb <- 100.0
  utb.tid <- 5
  gar.tid <- 5
  produkt <- 'SAFLO'
  tabell <- 'APG'
  grund <- 'PRES'
  
  PREM <- aterkopsVarde(kalkyldatum, birth.ff, sex.ff, pensions.alder, gb, utb.tid, gar.tid, produkt, tabell, grund)
  sprintf("PREM = %f",PREM)
  

  
  
  


  