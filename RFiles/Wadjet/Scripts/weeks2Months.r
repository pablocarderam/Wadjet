#converts time series vector from weeks to months (approximation), returns time series. Assumes weeks start on Sunday. If trim==T, will return time series object only with data for complete months (trimming first and last month if incomplete)

weeks2Months = function(Weeks,StartDay,StartMonth,StartYear,Trim) {
	w=Weeks;
	w[is.na(w)]=0
	d=StartDay;
	m=StartMonth;
	y=StartYear;
	leap=F;
	if (y %% 4 ==0) {
		leap=T;
	}
	
	mNum=1;
	months=c(0);
	
	for (i in 1:length(w) ) {
		c=w[i]/7;
				
		for (j in 1:7) {
			
			months[mNum] = months[mNum] + c; 
			
			d = d + 1;
			
			if (d==29 && m == 2 && !leap) {
				m = m + 1;
				d = 1;
				mNum = mNum + 1;
				months = cbind( months, c(0) );
			}
			else if (d==30 && m == 2 && leap) {
				m = m + 1;
				d = 1;
				mNum = mNum + 1;
				months = cbind( months, c(0) );
			}
			else if (d==31 && (m==4||m==6||m==9||m==11) ) {
				m = m + 1;
				d = 1;
				mNum = mNum + 1;
				months = cbind( months, c(0) );
			}
			else if (d==32) {
				m = m + 1;
				d = 1;
				mNum = mNum + 1;
				months = cbind( months, c(0) );
				
				if (m == 13) {
					y = y + 1;
					m = 1;
					d = 1;
					leap=F;
					if (y %% 4 ==0) {
						leap=T;
					}
				}
			}
		}
		
		
	}
	
	months=round(months);
	months=ts( as.numeric(months), start=c(StartYear, StartMonth), end=c(y, m), frequency=12 );
	
	if (Trim) {
		sM=StartMonth;
		sY=StartYear;
		if (StartDay > 7) { # if more than one week missing from starting month
			if (StartMonth == 12) {
				sM=1;
				sY=sY+1;
			}
		}
		if (d < 23) { # if more than one week missing from ending month
			if (m == 1) {
				m = 12;
				y = y - 1;
			}
		}
		
		months = window(months, start=c(sY,sM), end=c(y,m))
	}
	
	return(months);
}