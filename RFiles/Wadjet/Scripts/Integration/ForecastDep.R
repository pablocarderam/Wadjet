setwd("/Users/Palo/Documents/Eclipse/Wadjet/RFiles/Wadjet") #This has to be set to Wadjet directory
source("Scripts/Integration/Analisis.R")# load db

param = names(read.csv("Data/Param/param.csv", check.names=FALSE));
Dep = param[1];
sY = as.numeric(param[2]);
sM = as.numeric(param[3]);
PeriodInMonths = as.numeric(param[4]);
Certainty = 1-2*(1-as.numeric(param[5]));
StartDateVector = c(sY, sM);

forecastDep(Dep, StartDateVector, PeriodInMonths, Certainty);