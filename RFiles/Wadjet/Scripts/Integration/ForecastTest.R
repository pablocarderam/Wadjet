setwd("/Users/Palo/Documents/Eclipse/Wadjet/RFiles/Wadjet") #This has to be set to Wadjet directory
source("Scripts/Integration/Analisis.R")# load db

forecastDep("META", c(2012,1), 12, 0.8);