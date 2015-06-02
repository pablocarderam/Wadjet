#Grafica incidencia mensual en antioquia para años 2008-2014

setwd("/Users/Palo/Documents/Trabajos/Wadjet")

A=read.csv("Data/Epidemiologia/ModeloAntioquia.csv");
As=split(A,A[,"ANYO"]) # Split into list of dataframes by year
rm13 = function(yr) { # remove month 13 function, assigns 13 to 12
	yr$MES[yr$MES=="13"]=12
	return(yr)
}
As=lapply(As, function(x) rm13(x) ) # remove month 13 from all years
As=lapply(As, function(x) aggregate(CASOS ~ MES, x, sum)) #aggregate data from weeks into months in every dataframe of list

plot(1, type="n", xlab="Mes", ylab="Casos", xlim=c(0,13), ylim=c(0,100), xaxt="n", main="Incidencia mensual de accidentes ofídicos, Antioquia")

for (i in seq(2,length(As) )) { #Draw lines except for 2007
	lines(As[[i]]$MES,As[[i]]$CASOS,type="l",col=i)
}

axis(side=1, at=c(1:12), labels=c("Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"), las=2)
legend("topleft", title="Año", legend=names(As)[-1], col=c(seq(As)), lty=1, horiz=F)