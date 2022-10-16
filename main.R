source('./parameters.R')
source('./kommutationsFunktioner.R')
source('./miscFunctions.R')
source('./managFunctions.R')


#
  kalkyldatum <- as.Date('2022-06-30', '%Y-%m-%d')
  birth.ff <- as.Date('1983-11-30', '%Y-%m-%d')
  sex.ff <- 'm'
  pensions.alder <- 65
  gb <- 77.9
  utb.tid <- 18
  gar.tid <- 18
  produkt <- 'SAFLO'
  tabell <- 'APG'
  grund <- 'PRES'
  
  PREM <- aterkopsVarde(kalkyldatum, birth.ff, sex.ff, pensions.alder, gb, utb.tid, gar.tid, produkt, tabell, grund)
  sprintf("PREM = %f",PREM)
  #5839.058
  

  
  
  


  