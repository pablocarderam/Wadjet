# Diferentes metodos de analisis de pricipitacion y accidentes ofidicos para un año y depto dado. 
DOSIS_PROMEDIO = 2.5;
PRECIO_POL = 127000;
PRECIO_MIC = 127000;


setwd("/Users/Palo/Documents/Eclipse/Wadjet/RFiles/Wadjet") #This has to be set to Wadjet directory
source("Scripts/Clima/BuildClima.r")# load db
source("Scripts/Epidemiologia/BuildEpi.r")# load db
library(forecast);
library(xlsx);

print("Ready for analysis. Call maxSnakebites(), timeSeriesGraph(), linearModel(), seasonalDec(), seasonForecast(), arimaxForecast(), forecastDep(), forecastAll(). Let's do this shit.")

# Find N departamentos with greatest snakebite incidence in given time period.
maxSnakebites = function(NumDeptos, StartDateVector, EndDateVector) {
	s = lapply( Epi, FUN=function(depto) window(depto, start=StartDateVector, end=EndDateVector, extend=T) ); #select only data in window
	s = lapply(s, FUN=function(depto) sum(depto, na.rm=T)); #add up all cases in window
	s = as.data.frame(s); # parse as data frame for sorting
	s = as.data.frame(t(s)); # transpose for sorting
	d = row.names(s)[ order(-s[,1]) ]; # order names of departamentos based on incidence
	c = s[ order(-s[,1]), ]; # assign each departamento its incidence by joining columns
	s = cbind(d,c);
	s = as.data.frame(s); # parse as dataframe. again.
	s = s[1:NumDeptos,]; #select only certain deptos
	names(s) = c("Depto", "Casos")
	return(s);
}

# Grafica incidencia y una variable climatica dada en un intervalo de tiempo dado
timeSeriesGraph = function(Depto,VAR,StartDateVector,EndDateVector) {
	var=Clim[[Depto]][[VAR]]
	snakebite=Epi[[Depto]]
	
	var=window(var, start=StartDateVector, end=EndDateVector, extend=T)
	snakebite=window(snakebite, start=StartDateVector, end=EndDateVector, extend=T)
	
	par(mar=c(4,4,4,4), oma=c(1,1,1,1))
	plot(snakebite,type="l",col=1, ylab="", xlab="Mes", main=paste("Incidencia mensual de accidentes ofídicos y",VAR,", ", Depto) )
	axis(2)
	mtext("Accidentes ofídicos (casos)",side=2, line=3)
	par(new=T, mar=c(4,4,4,4))
	plot(var,type="l",col=2,xaxt="n",yaxt="n",xlab="",ylab="")
	axis(4)
	if (VAR == "PRECIP") {
		mtext("Precipitación total (mm de lluvia)",side=4, line=3)
	}
	else if (VAR == "TEMP") {
		mtext("Temperatura media (Cº)",side=4, line=3)
	}
	
	#axis(side=1, at=seq(0,(12*yrs-1), by=6), labels=seq(0,(12*yrs-1), by=6), las=2)
	
	legend("topleft", title="Año", legend=c("Accidentes ofídicos", VAR), col=c(1,2), lty=1, horiz=F)
}

# Grafica regresion lineal de incidencia en funcion de una variable climatica dada en un intervalo de tiempo dado 
linearModel = function (Depto,VAR,StartDateVector,EndDateVector) {
	var=Clim[[Depto]][[VAR]]
	snakebite=Epi[[Depto]]
	
	var=window(var, start=StartDateVector, end=EndDateVector, extend=T)
	snakebite=window(snakebite, start=StartDateVector, end=EndDateVector, extend=T)
	
	par(mar=c(4,4,4,4), oma=c(1,1,1,1))
	plot(precip,snakebite, ylab="Accidentes ofídicos (casos)", xlab="Precipitación (mm de lluvia)", main=paste("Relación entre accidentes ofídicos y precipitación, ", Depto, ", 2008-2014") )
	
	mod=lm(snakebite ~ precip)
	abline(mod)
	print(summary(mod))
}

# Plots seasonal decomposition of snakebite data
seasonalDec = function(Depto,StartDateVector,EndDateVector) {
	snakebite=Epi[[Depto]]
	snakebite=window(snakebite, start=StartDateVector, end=EndDateVector, extend=T)
	
	season = stl(snakebite, s.window="periodic");
	plot(season);
	summary(season);
}

# Generates forecast based on seasonality
seasonForecast = function (Depto,StartDateVector,EndDateVector,PeriodsForecast,Confidence) {
	snakebite=Epi[[Depto]]
	snakebite=window(snakebite, start=StartDateVector, end=EndDateVector, extend=T)
	
	season = stl(snakebite, s.window="periodic");
	future = forecast(season, h=PeriodsForecast, level=Confidence);
	#summary(future);
	png(filename = "Data/Output/Season.png");
	plot(future, xlim=c(StartDateVector[1],(EndDateVector[1]+1+ceiling(PeriodsForecast/12))), ylim=range(snakebite), type="l",col=1, ylab="Casos", xlab="Annos", main=paste("Prediccion estacional", Depto));
	par(new=T);
	plot(Epi[[Depto]], xlim=c(StartDateVector[1],(EndDateVector[1]+1+ceiling(PeriodsForecast/12))), ylim=range(snakebite), type="l",col=2,xaxt="n",yaxt="n",xlab="",ylab="");
	dev.off();
	return(future);
}

# Generates and plots ARIMAX forecast
arimaxForecast = function (Depto,VAR,StartDateVector,EndDateVector,PeriodsForecast,Confidence) {
	var=Clim[[Depto]][[VAR]];
	snakebite=Epi[[Depto]];
	
	varPast = window(var, start=StartDateVector, end=EndDateVector, extend=T);
	snakebite = window(snakebite, start=StartDateVector, end=EndDateVector, extend=T);
	
	startFuture = c(EndDateVector[1],(EndDateVector[2]+1));
	if (startFuture[2]==13) {
		startFuture = c((EndDateVector[1]+1),1);
	}
	endFuture = c( (startFuture[1]+floor(PeriodsForecast/12)), (startFuture[2]+(PeriodsForecast%%12)) );
	varFuture = window(var, start=startFuture, end=endFuture, extend=T);
	
	mod = auto.arima(snakebite, xreg=varPast);
	future = forecast(mod, xreg=varFuture, level=Confidence);
	png(filename = "Data/Output/Arimax.png");
	plot(future, type="l",col=1, ylab="Casos", xlab="Annos", main=paste("Prediccion ARIMAX", Depto));
	lines(Epi[[Depto]], col=2);
	dev.off();
	#summary(future);
	return(future);
}


# Returns vector with upper limit values of cases
forecastDep = function(Dep, StartDateVector, PeriodInMonths, Certainty) {
	print(paste("Forecasting",Dep))
	endPast = c(StartDateVector[1],(StartDateVector[2]-1));
	if (endPast[2]==0) {
		startFuture = c((StartDateVector[1]-1),12);
	}
	sea = seasonForecast(Dep,c(2007,1),endPast,PeriodInMonths,Certainty);
	ari = arimaxForecast(Dep,"PRECIP",c(2007,1),endPast,PeriodInMonths,Certainty);
	fAri = ari$upper[1:PeriodInMonths];
	fSea = sea$upper[1:PeriodInMonths];
	fAri[is.na(fAri)] = fSea[is.na(fAri)];
	f = round(fAri);
	dosisPol = round(f*DOSIS_PROMEDIO*0.95);
	dosisMic = round(f*DOSIS_PROMEDIO*0.05);
	precioPol = dosisPol*PRECIO_POL;
	precioMic = dosisMic*PRECIO_MIC;
	precioTot = precioPol+precioMic;
	out = as.data.frame(cbind(f, dosisPol, precioPol, dosisMic, precioMic, precioTot));
	names(out) = c("Accidentes ofidicos", "Dosis necesarias suero polivalente", "Precio total (Polivalente, COP)", "Dosis necesarias suero Micrurus", "Precio total (Micrurus, COP)", "Precio total (COP)");
	out = rbind(out, c("","",""));
	out = rbind(out, c(Dep, StartDateVector[1], paste("Confianza:",1-0.5*(1-Certainty))) )
	write.xlsx(out,"Data/Output/PrediccionDep.xlsx");
	write.csv(out,"Data/Output/PrediccionDep.csv");
	return(f);
}

forecastAll = function(StartDateVector, PeriodInMonths, Certainty) { #TODO: dosis y precios todo
	deptos=unique(names(Epi));
	deptos=deptos[!deptos=="EXTERIOR"];
	deptos=deptos[!deptos=="PROCEDENCIA DESCONOCIDA"];
	f = lapply( deptos,FUN=function(depto) forecastDep(depto, StartDateVector, PeriodInMonths, Certainty) );
	names(f) = deptos;
	f = as.data.frame(f);
	f = as.data.frame(t(f));
	names(f)=c(1:12);
	library(xlsx);
	write.xlsx(f,"Data/Output/Prediccion.xlsx");
	return(f);
}

#TODO

#adjusts new data by multiplying it times a constant
normalizeData = function(old, new) {
	rv = as.numeric(old/new);
	print(rv);
	rv=rv[!is.nan(rv)];
	r = mean(rv, na.rm=T); #calculates avg ratio
	adjusted = as.numeric(new)*r; #adjusts
	return(adjusted);
}

adjCD = function(dept) {
	if (is.element(dept,old$DEPTO)) {
		old = subset(Clim14, DEPTO==dept);
		new = subset(d14, DEPTO==dept);
		print(old[4:15])
		print(new[4:15])
		return(normalizeData( old[4:15],new[4:15] ));
	}
	else {
		return();
	}
}

#apply( d14,1, FUN=function(row) adjCD(row[2]) )