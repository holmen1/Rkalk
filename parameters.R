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


initConstants = function() {
  # maxAge = initConstants()
  maxAge = 115
}

allParameters = function(kalkyldatum, grund, sex, birth,typ='TJP1') {
  # mu = a + b*exp(cx)
  # grund in ['PRES', ...]
  # sex in ['m', 'f']
  # typ in ['TJP1', ...]
  # tax in ['K', 'P']
 
# DODLIGHETER # och drikostnadsbelastning 
  sql_grunder = paste0(
    "DECLARE @kalkyldatum DATE = '",kalkyldatum,
    "' DECLARE @grund CHAR(4) = '",grund,
    "' DECLARE @sex CHAR(1) = '",sex,
    "' DECLARE @birth DATE = '",birth,
    "' SELECT CASE WHEN @sex = 'm' THEN AMyMan ELSE AMyKv END a,
    CASE WHEN @sex = 'm' THEN BMyMan ELSE BMyKv END b,
    CASE WHEN @sex = 'm' THEN CMyMan ELSE CMyKv END c,
    Delta,
    EpsDelta
    FROM Grunder
    WHERE Grunder = @grund
    AND Miljo = 'P'
    AND Gren = 'SL'
    AND FodelseDatumFrom <= @birth
    AND FodelseDatumTill >= @birth
    AND FromDate = (
    SELECT MAX(FromDate)
    FROM Grunder
    WHERE Grunder = @grund
    AND Miljo = 'P'
    AND FromDate <= @kalkyldatum)"
  )
  sql_grunder = strwrap(sql_grunder,width=10000, simplify=TRUE)

#### RANTEPARAMETRAR ####
  sql_nss = paste0(
    "DECLARE @kalkyldatum DATE = '",kalkyldatum,
    "' DECLARE @grund CHAR(4) = '",grund,
    "' DECLARE @kurva CHAR(4) = '",typ,
    "'SELECT FromDate,betha0,betha1,betha2,betha3,tao0,tao1,RelativeTax 
    FROM NSSParametrar
    WHERE KurvNamn = @kurva
    AND Grunder = @grund
    AND FromDate = (
    SELECT MAX(FromDate) FROM NSSParametrar WHERE KurvNamn = @kurva AND FromDate <= @kalkyldatum)")
    sql_nss = strwrap(sql_nss,width=10000, simplify=TRUE)
  
  
  channel <- odbcConnect('aktuarie03')
    res_grunder = sqlQuery(channel, sql_grunder)
    res_nss = sqlQuery(channel, sql_nss)
  close(channel)
  
  make = list("a"=res_grunder$a,"b"=res_grunder$b,"c"=res_grunder$c*log(10))
  Rate = list("b0"=res_nss$betha0, "b1"=res_nss$betha1, "b2"=res_nss$betha2, "b3"=res_nss$betha3, "tau0"=res_nss$tao0, "tau1"=res_nss$tao1)
  
  FromDate = res_nss$FromDate
  skatt = res_nss$RelativeTax
  epsKostnad = res_grunder$EpsDelta #Intensitet
  nu = tidur(FromDate,kalkyldatum)
  
  rate = list("Rate"=Rate,"skatt"=skatt,"epsKostnad"=epsKostnad,"nu"=nu)
  
  list("rate"=rate,"Make"=make)
}


  
# Rate intensity, cost and tax added
delta = function(t, Rate, skatt, epsDelta) {
  
  grossRate = nssRate(t,Rate)
  
  # Correction of intensity
  grossRate*(1-skatt) - epsDelta
}

nssRate = function(t, Rate, omega = 100) {
  # Nelson-Siegel-Svensson
  # For constant rate put
  # b0 = const, b1,b2,b3 = 0, tau0,tau1 = 1, omega = 100;
  
  if (t==0)
    rate = Rate$b0 + Rate$b1
  else if (t < omega)
    rate = Rate$b0 +
          (Rate$b1 + Rate$b2)*(1 - exp(-t/Rate$tau0))/(t/Rate$tau0) -
          Rate$b2*exp(-t/Rate$tau0) +
          Rate$b3*(1 - exp(-t/Rate$tau1))/(t/Rate$tau1) -
          Rate$b3*exp(-t/Rate$tau1)
  else # Constant
    rate = Rate$b0 +
          (Rate$b1 + Rate$b2)*(1 - exp(-omega/Rate$tau0))/(omega/Rate$tau0) -
          Rate$b2*exp(-omega/Rate$tau0) +
          Rate$b3*(1 - exp(-omega/Rate$tau1))/(omega/Rate$tau1) -
          Rate$b3*exp(-omega/Rate$tau1)
}

Disc = function(nu, t, Rate, skatt, epsDelta) {
  exp(nu*delta(nu, Rate, skatt, epsDelta) - t*delta(t, Rate, skatt, epsDelta))
}


