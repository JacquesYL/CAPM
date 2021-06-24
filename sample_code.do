
		*************************************************
		****			Characterisic Lines 		 ****
		*************************************************
***Characteristic line is the “ line of best fit for all the stock returns 
*relative to returns of market


*Consider monthly returns on JP Morgan and S&P 500 index
use data_char_line.dta, clear
des

tsline plot_vix plot_gvix, lpattern("-" "l")  ///
	ytitle(Votility index in percent) ///
	xtitle(Date) ///
	tlabel(04jan1996 04jan2002 04jan2008 04jan2013 01jan2019) 
	
	
*time series plot
tsset date
tsline jpmrtrn sprtrn, ytitle(Monthly returns in %) ///
						legend(order(1 "JP & Morgan" 2 "S&P 500 Index" ))

tsline jpmrtrn sprtrn rf, ytitle(Monthly returns in %) ///
						legend(order(1 "JP & Morgan" 2 "S&P 500 Index" 3 "One-month TBill"))


*summary statistics
tabstat jpmrtrn sprtrn rf, stat(mean sd p10 p25 p50 p75 p90) col(stat) 

*plot the JP & Morgan monthly return on S&P 500 monthly return
scatter jpmrtrn sprtrn


twoway (scatter jpmrtrn sprtrn) (lfit jpmrtrn sprtrn), ///
		ytitle(Return (%) on the JP Morgan) ///
		xtitle(Return (%) on the S&P 500 Index) ///
		legend(order(1 "Return (%) on the S&P 500 Index" 2 "Characteristic Line")) ///
		note("Data is obtained from CRSP, 2001-2020") ///
		scheme(s1color)

***OLS to estimate the slope of the characterisic line
est clear

qui: reg jpmrtrn sprtrn
_coef_table


***Esimate the beta using the excess return
gen y = jpmrtrn - rf
label var y "Excess return on the JP & Morgan"

gen x = sprtrn - rf
label var x "Excess return on the S&P 500 Index "


twoway (scatter y x) (lfit jpmrtrn sprtrn), ///
		ytitle(Excess return (%) on the JP Morgan) ///
		xtitle(Excess return (%) on the S&P 500 Index) ///
		legend(order(1 "Excess return (%) on the JP Morgan" 2 "Characteristic Line")) ///
		note("Data is obtained from CRSP, 2001-2020") ///
		scheme(s1color)

* OLS regression, the coefficient on x is the beta
qui: reg y x 
_coef_table



		*************************************************
		****			Security Market Line		 ****
		*************************************************

***The SML is a line drawn on a chart that serves as a graphical representation of CAPM
*which shows different levels of the expected rate of return of an individual security 
*as a function of systematic (or market) risk -- beta


*use the example on page 49 of the slides: 9 companies' beta coefficients in 2018

*step 1: collect the monthly return of those companies in 2018
use data_sml, clear
tabstat ret, stat(mean sd p10 p25 p50 p75 p90) col(stat) by(ticker) 

*compute the average of 12 months return for each stock
collapse ret, by(ticker)

*add a new column of beta coefficients
gen beta = 0.54 if ticker == "M"
replace beta = 0.81 if ticker == "FB"
replace beta = 0.85 if ticker == "F"
replace beta = 0.93 if ticker == "PFE"
replace beta = 1.05 if ticker == "COST"
replace beta = 1.06 if ticker == "HD"
replace beta = 1.15 if ticker == "AAPL"
replace beta = 1.46 if ticker == "PRU"
replace beta = 1.70 if ticker == "AMZN"


*generate company name for review
gen firm = "Macy's" if ticker == "M"
replace firm = "Facebook" if ticker == "FB"
replace firm = "Ford" if ticker == "F"
replace firm = "Prizer" if ticker == "PFE"
replace firm = "Costco" if ticker == "COST"
replace firm = "Home Depot" if ticker == "HD"
replace firm = "Apple" if ticker == "AAPL"
replace firm = "Prudential" if ticker == "PRU"
replace firm = "Amazon" if ticker == "AMZN"

*plot the SML
scatter ret beta, ytitle(Expected returns) mlabel(firm) 



twoway (scatter ret beta) (lfit jret beta), ///
		ytitle( Excess return (%) on the JP Morgan) ///
		legend(order(1 "Excess return (%) on the S&P 500 Index" 2 "Characteristic Line")) ///
	


twoway (scatter ret beta, mlabel(firm)) (lfit ret beta), ///
		ytitle(Expected returns) ///
		legend(order(1 "Invidiual stock returns" 2 "Security Market Line (SML")) ///
		note("Data is obtained from CRSP, 2018") ///
		scheme(s1color)

