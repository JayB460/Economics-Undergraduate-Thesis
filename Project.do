*-------------------------------------------------------------------*
* Author: John Baker
* Semester Project: How CARES Act and Covid-19 Impact Labor Market
* November of 2021
*----------------------------------------------------------------------

global path = "C:\Users\johnr\Desktop\Capstone\Project\Data Downloaded\"

clear

import excel "$path\Cleaned Version 2.xlsx", sheet("HomePage") firstrow

rename OptOutState1ifyes Opt_out
rename Dose1_Pop_Pct firstdose
rename LaborForcepercentofpop lfpercent
rename percentofpopemployed employrate

egen state_id = group(State)

destring Month , generate(Month_n)

	egen time_num=group(Year Month)
	
	
reg UnemploymentRate Opt_out firstdose tot_casespercentofpop tot_deathpercentofpop i.state_id i.time_num , r

*------------------------------------------------------------------------
* Using ##c to see how the lag effect of Opting Out. 
*------------------------------------------------------------------------
		
* Here we are treating time as linear where we treat time as a continuous variable. What this means when we adjust "continuously" for time is that we include just the linear term. So between day 1 and day 2, the same difference in response is expected (conditional on all other covariates) as is expected at day 10 and 11. Two ## indicates lag by two months because time period is already predetermined by our data

reg UnemploymentRate i.Opt_out##c.time_num firstdose tot_casespercentofpop tot_deathpercentofpop i.state_id , r
	
reg lfpercent i.Opt_out##c.time_num firstdose tot_casespercentofpop tot_deathpercentofpop i.state_id , r 
	
reg employrate i.Opt_out##c.time_num firstdose tot_casespercentofpop tot_deathpercentofpop i.state_id , r
	

*------------------------------------------------------------------
* Outregging to Create Outputs
*------------------------------------------------------------------

* Below for each independent variable, I am creating multiple models for each independent variable I have. Each will include varying amounts of dependent variables to see how the addition each will impact our independent variable as we add more. For example in the first model, I regress my independent variable, Unemployment rate, with just one dependent variable, opt-out.  

* Output Unemployment Rate

reg UnemploymentRate i.Opt_out , r 
	outreg2 using Unemployed, word replace bdec(3) sdec (4) title(Impact of
	Withdrawal of Federal Unemployment Insurance Extended Benefits on State
	Aggregagte Unemployment Rates) ctitle(" ")

 
reg UnemploymentRate i.Opt_out firstdose , r 
	outreg2 using Unemployed, word append  bdec(3) sdec (4) ctitle(" ")
	
reg UnemploymentRate i.Opt_out firstdose tot_casespercentofpop , r 
	outreg2 using Unemployed, word append  bdec(3) sdec (4) ctitle(" ")

reg UnemploymentRate i.Opt_out firstdose tot_casespercentofpop
	tot_deathpercentofpop , r 
	outreg2 using Unemployed, word append  bdec(3) sdec (4) ctitle(" ")

reg UnemploymentRate i.Opt_out firstdose tot_casespercentofpop
	tot_deathpercentofpop i.time_num , r 
	outreg2 using Unemployed, word drop(i.time_num) append  bdec(3) sdec (4)
	ctitle(" ")

reg UnemploymentRate i.Opt_out##c.time_num firstdose tot_casespercentofpop
	tot_deathpercentofpop i.state_id , r
	outreg2 using Unemployed, word drop(i.time_num  i.state_id) 
		replace bdec(3) sdec (4) ctitle(" ") 


* Output Employment Rate
reg employrate i.Opt_out , r 
	outreg2 using Employed, word replace bdec(3) sdec (4) title(Impact of
	Withdrawal of Federal Unemployment Insurance Extended Benefits on State
	Aggregagte Employment Rates) addnote(Model 1 Represents) ctitle(" ")

reg employrate i.Opt_out firstdose , r 
	outreg2 using Employed, word append  bdec(3) sdec (4) ctitle(" ")
	
reg employrate i.Opt_out firstdose tot_casespercentofpop , r 
	outreg2 using Employed, word append  bdec(3) sdec (4) ctitle(" ")

reg employrate i.Opt_out firstdose tot_casespercentofpop
	tot_deathpercentofpop , r 
	outreg2 using Employed, word append  bdec(3) sdec (4) ctitle(" ")

reg employrate i.Opt_out firstdose tot_casespercentofpop
	tot_deathpercentofpop i.time_num , r 
	outreg2 using Employed, word drop(i.time_num) append  bdec(3) sdec (4)
	ctitle(" ")

reg employrate i.Opt_out##c.time_num firstdose tot_casespercentofpop
	tot_deathpercentofpop i.state_id , r
	outreg2 using Unemployed, word drop(i.time_num  i.state_id) 
		replace  bdec(3sdec (4) ctitle(" ") 

	
* Output Labor Force 
reg lfpercent i.Opt_out , r 
	outreg2 using LaborForce, word replace bdec(3) sdec (4) title(Impact of
	Withdrawal of Federal Unemployment Insurance Extended Benefits on State
	Labor Force) addnote(Model 1 Represents) ctitle(" ")

reg lfpercent i.Opt_out firstdose , r 
	outreg2 using LaborForce, word append  bdec(3) sdec (4) ctitle(" ")
	
reg lfpercent i.Opt_out firstdose tot_casespercentofpop , r 
	outreg2 using LaborForce, word append  bdec(3) sdec (4) ctitle(" ")

reg lfpercent i.Opt_out firstdose tot_casespercentofpop
	tot_deathpercentofpop , r 
	outreg2 using LaborForce, word append  bdec(3) sdec (4) ctitle(" ")
	
reg lfpercent i.Opt_out firstdose tot_casespercentofpop
	tot_deathpercentofpop i.time_num, r 
	outreg2 using LaborForce, word drop(i.time_num) append  bdec(3) sdec(4)
	ctitle(" ")

reg lfpercent i.Opt_out##c.time_num firstdose tot_casespercentofpop
	tot_deathpercentofpop i.state_id , r
	outreg2 using Unemployed, word drop(i.time_num  i.state_id) replace
	bdec(3) sdec (4) ctitle(" ") 

	
*--------------------------------------------------------------------*
* Creating binary variable for states
*--------------------------------------------------------------------*

* We had an issue with each state having its own unique ID when we want to graph the results. To make a clean model that groups Retain states and Withdraw states, I generate a new variable, a binary variable, for these two groups. In binaries, 0 is 'no' and 1 is 'yes' generally speaking. It is usually represented as a Boolean, True or False, or in this case an integer variable, 0 or 1, where 0 typically indicates that the attribute is absent, and 1 indicates that it is present. False is 0, true is 1. In this case we elect withdraw states to be optOutState = 0. New variable for fixing opt out ambiguity and Graphing Purposes. This binary variable will help me create a 2-line visual representing our Retain states and Withdraw states. The lines for each group consist of the average unemployment rate. 

* This is new variable that will not harm regression unless inputted directly  into main Stata window AND saved.

gen optOutState = 0

	replace optOutState = 1 if State == "Alabama" 
	replace optOutState = 1 if State == "Alaska"
	replace optOutState = 1 if State == "Arizona"
	replace optOutState = 1 if State == "Arkansas"
	replace optOutState = 1 if State == "Florida"
	replace optOutState = 1 if State == "Georgia"
	replace optOutState = 1 if State == "Idaho"
	replace optOutState = 1 if State == "Indiana"
	replace optOutState = 1 if State == "Iowa"
	replace optOutState = 1 if State == "Louisiana"
	replace optOutState = 1 if State == "Maryland"
	replace optOutState = 1 if State == "Mississippi"
	replace optOutState = 1 if State == "Missouri"
	replace optOutState = 1 if State == "Montana"
	replace optOutState = 1 if State == "Nebraska"
	replace optOutState = 1 if State == "New Hampshire"
	replace optOutState = 1 if State == "North Dakota"
	replace optOutState = 1 if State == "Ohio"
	replace optOutState = 1 if State == "Oklahoma"
	replace optOutState = 1 if State == "South Carolina"
	replace optOutState = 1 if State == "South Dakota"
	replace optOutState = 1 if State == "Tennessee"
	replace optOutState = 1 if State == "Texas"
	replace optOutState = 1 if State == "Utah"
	replace optOutState = 1 if State == "West Virginia"
	replace optOutState = 1 if State == "Wyoming"
	
	
*------------------------------------------------------------------
* Creating Visuals (using generated variable above)
*------------------------------------------------------------------

* Graphing Part (Blue lines = Retain, Red line = Opt out)
* This twoway line will graph the unemployment rate for Retain states and withdraw states


						* Unemployment Rate
						
twoway (line UnemploymentRate time_num if optOutState == 0) (line UnemploymentRate time_num if optOutState == 1)
		collapse (mean) UnemploymentRate , by(optOutState time_num)
	
twoway (line UnemploymentRate time_num if optOutState == 0)
* This is non-opt-out (Retain) 

twoway (line UnemploymentRate time_num if optOutState == 1)
* This one above is my opt-out states (Withdraw)
	
	
						* Employment Rate
						
twoway (line employrate time_num if optOutState == 0) (line employrate time_num if optOutState == 1)
		collapse (mean) employrate , by(optOutState time_num)

	
						* Labor Force
						
twoway (line lfpercent time_num if optOutState == 0) (line lfpercent time_num if optOutState == 1)
		collapse (mean) lfpercent , by(optOutState time_num)

	
	
*------------------------------------------------------------------------
* Summarize our data using above generated variable 
*------------------------------------------------------------------------	

*Summarize will provide summary statistics. Asdoc will add present the stats in a Word file. Running these 3 summarize commands will present summary stats all on the same Word file. Replace and append are necessary to add to orginal Word doc created. 


	
summarize  Month_n lfpercent employrate UnemploymentRate Opt_out firstdose tot_cases tot_death if optOutState == 0

asdoc summarize  Month_n lfpercent employrate UnemploymentRate Opt_out
	firstdose tot_cases tot_death if optOutState == 0 , replace

asdoc summarize  Month_n lfpercent employrate UnemploymentRate Opt_out
	firstdose tot_cases tot_death if optOutState == 1 , append
		