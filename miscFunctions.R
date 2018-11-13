# MISCFUNCTIONS.R

tidur = function(date1, date2) {
  # tidur calculates number of years between 2 dates, 30/360
  
  p1 = as.POSIXlt(date1)
  p2 = as.POSIXlt(date2)
  
  years = p2[1][[6]] - p1[1][[6]]
  months = p2[1][[5]] - p1[1][[5]]
  days = min(p2[1][[4]],30) - min(p1[1][[4]],30)
  
  y = years + months/12 + days/360.0
}


zDate = function(birth.date, z) {
  posix.date = as.POSIXlt(birth.date)
  posix.date$year = posix.date$year + z
  
  #day = '01'
  posix.date[1][[4]] <- 1
  z.date = as.Date(posix.date)
}


terminAterbaring = function(utbetalning, vPrim, progReserv) {
  #Terminsaterbaring
  tab = floor(utbetalning*(vPrim/progReserv - 1))
}