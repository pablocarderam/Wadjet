#CARGA ARCHIVOS .CSV, MUESTRA TABLA 2010-2014. Directorio debe ser Wadjet.

#rm(list=ls()); #clear workspace

print("Please wait. Lotta climate info coming in.")

d70=read.csv("Data/IDEAMClima/Microdatos/precipitacionytemper1970-2011.csv", stringsAsFactors=F);
d10=read.csv("Data/IDEAMClima/Microdatos/precipitacionytemper2010-2014.csv",stringsAsFactors=F);
d12=read.csv("Data/IDEAMClima/Microdatos/precipitacionytemper2012.csv",stringsAsFactors=F);
dD=read.csv("Data/IDEAMClima/Microdatos/precipitacionytemperdiarias.csv",stringsAsFactors=F);
d14=read.csv("Data/IDEAMClima/Prec20142015.csv",stringsAsFactors=F);

print("Started building")

#Consolidate db's
Clim=rbind(d70,d10,d12)
Clim=Clim[c(1,2,19:31)]
names(Clim)=c("ANYO","DEPTO","VARIABLE",c(1:12))
names(d14)=c("ANYO","DEPTO","VARIABLE",c(1:12))
d14[d14=="Prec"]="PRECIP"
Clim=rbind(Clim,d14[c(1:15)])

Clim[Clim=="**"]=NA
Clim[Clim=="*"]=NA
Clim[Clim==""]=NA
Clim[Clim=="NARI#O"]="NARINYO" #corrects name
Clim[Clim=="BOGOTA D.C."]="BOGOTA" #corrects name
Clim[Clim=="LA GUAJIRA"]="GUAJIRA" #corrects name
Clim[Clim=="VALLE DEL CAUCA"]="VALLE" #corrects name
Clim[Clim=="NORTE DE SANTANDER"]="NORTE SANTANDER" #corrects name
Clim[Clim=="VALORES TOTALES MENSUALES DE PRECIPITACION (mms)"]="PRECIP"
Clim[Clim=="VALORES MEDIOS  MENSUALES DE TEMPERATURA (oC)"]="TEMP"
Clim=subset(Clim, VARIABLE=="PRECIP"|VARIABLE=="TEMP")
Clim=subset(Clim, ANYO>2006)

write.csv(Clim, "Data/IDEAMClima/Clim.csv", row.names=FALSE, na="NA")# Reads and writes to coerce number columns to numeric
Clim=read.csv("Data/IDEAMClima/Clim.csv", stringsAsFactors=F);
Clim=aggregate(Clim[c(4:15)], list(Clim$ANYO,Clim$DEPTO,Clim$VARIABLE), FUN=function(x) mean(x, na.rm=T)) # Aggregates data by deptos
names(Clim)=c("ANYO","DEPTO","VARIABLE",c(1:12)) #Renames columns
write.csv(Clim, "Data/IDEAMClima/Clim.csv", row.names=FALSE, na="NA") #Rewrites

print("Climate DB are locked n' loaded. Call Clim.")