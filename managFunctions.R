# Innehåller funktioner:

# Aterkopsvarde
# aterkopsVarde(kalkyldatum, birth.ff, sex.ff, pensions.alder, gb, m, [s], produkt, tabell, grund)

# VARDE
# varde(tabell, birth.ff, z, maxAge, kalkyldatum, m, s, a, b, c, Rate, rKorr, deltaKorr, nu)

# Livranta
# livranta(x, nu, n,makeA,makeB,makeC, Rate, deltaKorr, rKorr)

#############################################################################################################################################################################################


# ATERKOPSVARDE, används även vid beräkning av premiereserver (grund='PRES')
aterkopsVarde = function(kalkyldatum, birth.ff, sex.ff, pensions.alder, gb, m, s = 0, produkt, tabell, grund) {
                 
  maxAge = initConstants();
  
  param = allParameters(kalkyldatum, grund, sex.ff, birth.ff)
  
  A = gb * varde(tabell, birth.ff, pensions.alder, maxAge,kalkyldatum, m, s, param$Make$a, param$Make$b, param$Make$c, param$rate$Rate, param$rate$skatt, param$rate$epsKostnad,param$rate$nu)
}

# VARDE
# varde = (tabell, birth.ff, z, maxAge, kalkyldatum, m, s, a, b, c, Rate, rKorr, deltaKorr, nu)
varde = function(tabell, birth.ff, z, maxAge, kalkyldatum, m, s, a, b, c, Rate, rKorr, deltaKorr, nu) {
  xD = tidur(birth.ff, kalkyldatum)        # Age today
  xP = tidur(birth.ff, zDate(birth.ff, z)) # Age at z
  #xS = xP + s                        # Age at z + s
  
  # xN age next payment
  if (xD > xP) {
    payments = m * 12 -  ceiling((xD - xP) * 12)
    xN = xP + (m * 12 - payments) * 1 / 12
  } else {
    payments = m * 12
    xN = xP
  }
  
  # AP Temporär uppskjuten livränta (ålderspension)
  if (tabell == 'AP') {
    if (xD < xP+m) {
      payments = m * 12 -  max(ceiling((xD - xP) * 12), 0)
      xN = xP + (m * 12 - payments) * 1 / 12
      DxKvot(xD, nu, nu + xN - xD, a, b, c, Rate, deltaKorr, rKorr) *
        livranta(xN, nu + xN - xD, payments, a, b, c, Rate, deltaKorr, rKorr)
    } else 0.0
    
  # APG Temporär uppskjuten annuitet
  } else if (tabell == 'APG') {
    if (xD < xP+s) {
      gar.payments = s * 12 -  max(ceiling((xD - xP) * 12), 0)
      xN = xP + (s * 12 - gar.payments) * 1 / 12
      Disc(nu, nu + xN - xD, Rate, rKorr, deltaKorr) * annuitet(nu + xN - xD, gar.payments, Rate, deltaKorr, rKorr)
    } else 0.0
    
  # APGU Livsvarig uppskjuten livränta med återbetalningsskydd till ålder z,
  # sedan garantibelopp till ålder z + s, därefter livsvarig ÅP.  
  } else if (tabell == 'APGU') {
    if (xD < xP) {#Uppskovstid #funkis 0927/mhoc
      Disc(nu, nu + z - xD, Rate, rKorr, deltaKorr) * annuitet(nu + z - xD, s*12, Rate, deltaKorr, rKorr) +
        Disc(nu, nu + xP - xD, Rate, rKorr, deltaKorr) * DxKvot(xP, nu + xP -xD, nu + xP + s - xD, a, b, c, Rate, deltaKorr, rKorr) *
        livranta(xP + s, nu + xP + s - xD, m * 12, a, b, c, Rate, deltaKorr, rKorr)
    } else if (xD < xS) {#funkis 0928/mhoc
      gar.payments = s * 12 -  ceiling((xD - xP) * 12)
      xN = xP + (s * 12 - gar.payments) * 1 / 12
      Disc(nu, nu + xN - xD, Rate, rKorr, deltaKorr) * annuitet(nu + xN - xD, gar.payments, Rate, deltaKorr, rKorr) +
        DxKvot(xD, nu, nu + xP + s - xD, a, b, c, Rate, deltaKorr, rKorr) *
        livranta(xP + s, nu + xP + s - xD, m * 12, a, b, c, Rate, deltaKorr, rKorr)
    } else if (xD >= xS) {#
      xN = xP+s + ceiling((xD-(xP+s))*12)/12
      DxKvot(xD, nu, nu + xN - xD, a, b, c, Rate, deltaKorr, rKorr) *
      livranta(xN, nu + xN - xD, m * 12, a, b, c, Rate, deltaKorr, rKorr)
    } else 0.0
  } else -1
}


# Livranta
livranta = function(x, nu, n,makeA,makeB,makeC, Rate, deltaKorr, rKorr) {
  # Sum DxKvot n months from nu 
  h = 1/12
  tmp = 0
  for (i in 0:(n-1)) {
    tmp = tmp + DxKvot(x, nu, nu+i*h,makeA,makeB,makeC, Rate, deltaKorr, rKorr)
  }
  tmp
}

# Annuitet
annuitet = function(nu, n, Rate, deltaKorr, rKorr) {
  # Sum Disc n months from nu 
  h = 1/12
  tmp = 0
  for (i in 0:(n-1)) {
    tmp = tmp + Disc(nu, nu+i*h, Rate, rKorr, deltaKorr)
  }
  tmp
}


# 
eLife = function(kalkyldatum, birth.ff, sex.ff, pensions.alder,grund) {
  maxAge = initConstants();
  param = allParameters(kalkyldatum, grund, sex.ff, birth.ff)
  
  # Sum DxKvot n months from nu
  n = (maxAge-pensions.alder)*12
  h = 1/12
  tmp = 0
  for (i in 0:(n-1)) {
    tmp = tmp + lKvot(pensions.alder,i*h,param$Make$a, param$Make$b, param$Make$c)
  }
  tmp
}


