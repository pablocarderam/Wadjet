#CONSTRUYE BASE DE DATOS DE DATOS EPIDEMIOLOGICOS DE ARCHIVO .CSV FORMATO Epi$DEPTOS

print("Please wait. Lotta epidemiology info coming in.")
Epi=read.csv("Data/Epidemiologia/AccidentesOfidicos.csv");
print("Epidemiology data loaded.")
source("Scripts/weeks2Months.r")

weeks=seq(1,53,by=1) #stores vector with week numbers
months = ceiling(weeks/4.41) # creates a vector with month number for every week
months[months=="13"]=12 # sets all weeks in month 13 to month 12

convertToMonths = function(yr) { # Accepts year dataframe, returns snakebite dataframe by monthsZ
	
	yr=rbind(yr,months) # adds vector with month numbers to year dataframe
	row.names(yr)=c("CASOS", "MES") # adds row names
	
	yr=as.data.frame(t(yr)) # transposes dataframe
	yrWithMonths=aggregate(CASOS ~ MES, yr, sum) # aggregates data by month
	return(yrWithMonths)
}



keepCasos = function(yr) {
	yr=subset(yr, select=-c(ANYO, DEPTO)) # Removes first two columns
	names(yr)=weeks;
	#yr=as.numeric(yr)
	return(yr)
}

timeSeries = function(depto) {
	depto=lapply(depto, FUN=function(yr) keepCasos(yr) )
	depto=do.call(cbind, depto)
	depto=depto[!is.na(depto)]; # ALERT: will remove all NA's since not all years have 53 weeks. Will therefore not work if data epidemiology is missing for some years.
	return(depto)
}

Epi=split(Epi, Epi[,"DEPTO"])# Split into deptos
print("Split into deptos")

Epi=lapply(Epi, FUN=function(dept) split(dept,dept[,"ANYO"]) ) # Split variables in deptos into years
print("Split into yrs")

Epi=lapply(Epi, FUN=function(dept) timeSeries(dept) ) # Convert to time series
print("Converted to time series")

Epi=lapply(Epi, FUN=function(dept) weeks2Months(as.numeric(dept), 31, 12, 2006, T)) # convert data from weeks to months
print("Converted to months")

print("Epidemiology data ready to rumble. Call 'Epi'.")