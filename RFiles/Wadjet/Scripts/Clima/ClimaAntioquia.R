#Carga solo datos climaticos de antioquia
source("Scripts/Clima/LoadDB.R")# load db

d10[d10=="**"]=NA
d10[d10=="*"]=NA
d10[d10==""]=NA

d10=split(d10, d10[,"DEPTO"])# Split into deptos
d10=lapply(d10, function (dept) split(dept, dept[,"VARIABLE"]) # Split each depto into variables
d10=lapply(d10, function (dept) lapply(dept, function (var) names(var)[1] = "Temp")) # Change names of variables
d10=lapply(d10, function (dept) lapply(dept, function (var) names(var)[2] = "Precip")) # Change names of variables
d10=lapply(d10,function (dept) lapply(dept, function (var) split(var,var[,"ANYO"]))) # Split variables in deptos into years
d10=lapply(d10,function (dept) lapply(dept, function (var) lapply(var, lapply(var, function(yr) yr=yr[c(20:31)])))) # Keep only months

d10=lapply(d10,function (dept) lapply(dept, function (var) lapply(var, lapply(var, function(yr) apply(yr, function (month) month=mean(month,na.rm=T)))))) # Find average of each month

#ARCHITECTURE: d10$DEPTO$VARIABLE$ANYO