# CARGA DATOS DESDE ARCHIVOS .dta, CREA ARCHIVOS CSV

#rm(list=ls()); #clear workspace
print("Please wait. Lotta info coming in.")

library(foreign);

#reads dta files
d70=read.dta("Data/IDEAMClima/Microdatos/precipitacionytemper1970-2011.dta");
d10=read.dta("Data/IDEAMClima/Microdatos/precipitacionytemper2010-2014.dta");
d12=read.dta("Data/IDEAMClima/Microdatos/precipitacionytemper2012.dta");
dD=read.dta("Data/IDEAMClima/Microdatos/precipitacionytemperdiarias.dta");

#convert column name to "anyo"
names(d70)[1] <- "ANYO";
names(d10)[1] <- "ANYO";
names(d12)[1] <- "ANYO";
names(dD)[1] <- "ANYO";

#write csv files
write.csv(d70, "Data/IDEAMClima/Microdatos/precipitacionytemper1970-2011.csv", row.names=FALSE, na="");
write.csv(d10, "Data/IDEAMClima/Microdatos/precipitacionytemper2010-2014.csv", row.names=FALSE, na="");
write.csv(d12, "Data/IDEAMClima/Microdatos/precipitacionytemper2012.csv", row.names=FALSE, na="");
write.csv(dD, "Data/IDEAMClima/Microdatos/precipitacionytemperdiarias.csv", row.names=FALSE, na="");

#
d10[d10=="**"]=NA
d10[d10=="*"]=NA
d10[d10==""]=NA

d70[d70=="**"]=NA
d70[d70=="*"]=NA
d70[d70==""]=NA

d12[d12=="**"]=NA
d12[d12=="*"]=NA
d12[d12==""]=NA


print("DB are locked n' loaded.")