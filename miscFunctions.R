# MISCFUNCTIONS.R

tidur = function(date1, date2) {
  # tidur calculates number of years between 2 dates, 30/360
  days = as.numeric(difftime(date2, date1,units='days'))
  
  y = days/360.0
}


zDate = function(birth.date, z) {
  posix.date = as.POSIXlt(birth.date)
  posix.date$year = posix.date$year + z
  
  #day = '01'
  posix.date$mday <- 1
  z.date = as.Date(posix.date)
}


terminAterbaring = function(utbetalning, vPrim, progReserv) {
  #Terminsaterbaring
  tab = floor(utbetalning*(vPrim/progReserv - 1))
}