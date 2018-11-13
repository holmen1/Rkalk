# KOMMUTATIONSFUNKTIONER.R


DxKvot = function(x, nu,t,makeA,makeB,makeC, Rate, deltaKorr, rKorr) { 
  # D-kvot D(x+t)/D(x)  
  # Correction with nu when kalkyldatum > deltaFromDate
  
  Disc(nu,t,Rate,rKorr,deltaKorr) * lKvot(x,t-nu,makeA,makeB,makeC)
}


lKvot = function(x,t,a,b,c) {
  # l(x+t)/l(x)
  # Makeham: my(x) = a + b*exp(cx)
  exp(-a*t + b/c*(exp(c*x) - exp(c*(x+t)))) 
}

