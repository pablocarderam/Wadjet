# Construye base de datos con:
# ARCHITECTURE: Clim$DEPTO$VARIABLE
# que luego contiene promedios mensuales por DEPARTAMENTO

keepMonths = function(yr) { # Accepts year dataframe, keeps only month columns
	yr=yr[c(4:15)]
	#yr=as.numeric(yr)
	return(yr)
}

timeSeries = function(var) {
	var=split(var,var[,"ANYO"])
	var=lapply(var, FUN=function(yr) keepMonths(yr) )
	var=do.call(cbind, var)
	var=ts( as.numeric(var), start=c(2007, 1), end=c(2015, 12), frequency=12 );
	return(var)
}

numAvg = function(x) { # Accepts dataframe, parses columns as numbers, sets columns in x to their averages (ignoring NA values), returns as columns
	x=sapply(x, FUN=function(y) as.numeric(y)) #parse factors as numbers
	x=as.data.frame(x); #return to dataframe
	x=sapply(x, FUN=mean, na.rm=T) #Averages columns
	return(x)
}

Clim=read.csv("Data/IDEAMClima/Clim.csv", stringsAsFactors=F);

Clim=split(Clim, Clim[,"DEPTO"])# Split into deptos
print("Split into deptos")
Clim=lapply(Clim, FUN=function(dept) split(dept, dept[,"VARIABLE"])) # Split each depto into variables
print("Split into vars")
#Clim=lapply(Clim, FUN=function(dept) lapply(dept, FUN=function(var) split(var,var[,"ANYO"]) )) # Split variables in deptos into years
#print("Split into yrs")
Clim=lapply(Clim, FUN=function(dept) lapply(dept, FUN=function(var) timeSeries(var) )) # Convert to time series
print("Converted to time series")