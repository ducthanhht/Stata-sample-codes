
**============================================================================**
/*

This do-file is to calculate parental investments and parental human capital for
the job market paper "Parental Investment and Child Development": 

1. parental investments (Expenditure on the Young Lives child, 
Number of hours studying outside school as a proxy for the time that parents dedicate
to the child, and Quality of relationship between child and
parents)

2. Prental human capital (Cognitive skills, noncognitive skills and health)

*/

clear all
macro drop _all
mata: mata clear
set mem 500m
set more off
capture log close

sjlog using "Parental education", replace

cd "~/Desktop/Github/Young Lives"

********************************************************************************

          ********* EXPENDITURE ON THE YOUNG LIVE CHILD *************
		  
******************************************************************************** 

********************************************************************************
                   ** EXPENDITURE - ROUND 3**
********************************************************************************

use R3/vn_oc_householdlevel.dta, clear

rename CHILDID childid

recode SPYRR312 SPYRR311 SPYRR314 SPYRR313 SPYRR315 SPYRR310 SPYRR309 SPYRR303 SPYRR304 SPYRR307 SPYRR308 (-77=.) (-79=.) (-88=.) (-99=.) (-8=.)
recode SPNMR312 SPNMR311 SPNMR314 SPNMR313 SPNMR315 SPNMR310 SPNMR309 SPNMR303 SPNMR304 SPNMR307 SPNMR308 (77=.) (79=.) (88=.) (99=.)

recode EVNTR301 EVNTR312 EVNTR313 EVNTR347  EVNTR314 EVNTR316 EVNTR324 EVNTR325 EVNTR328 EVNTR329 EVNTR331 EVNTR348 EVNTR337 EVNTR338 EVNTR339 (77=.) (79=.) (88=.) (99=.)

recode EVNTR301 EVNTR310 EVNTR312 EVNTR313 EVNTR347 EVNTR314 EVNTR316 EVNTR323 ///
EVNTR324 EVNTR325 EVNTR326 EVNTR327 EVNTR328 EVNTR329 EVNTR330 EVNTR331 EVNTR348 ///
EVNTR332 EVNTR334 EVNTR335 EVNTR336 EVNTR337 EVNTR338 EVNTR339 EVNTR340 EVNTR341 EVNTR342 EVNTR345  (77=.) (79=.) (88=.) (99=.)


recode EVNTR301 EVNTR310 EVNTR312 EVNTR313 EVNTR347 EVNTR314 EVNTR316 EVNTR323 ///
EVNTR324 EVNTR325 EVNTR326 EVNTR327 EVNTR328 EVNTR329 EVNTR330 EVNTR331 EVNTR348 ///
EVNTR332 EVNTR334 EVNTR335 EVNTR336 EVNTR337 EVNTR338 EVNTR339 EVNTR340 EVNTR341 EVNTR342 EVNTR345  (.=0) 

*********************************************

capture program drop cfee3
program define cfee3 /* arguments*/

  gen `6'=`1' if `3'==2&`4'==4
  replace `6'=`1'*0.75 if `3'==2&`4'==3
  replace `6'=`1'*0.5 if `3'==2&`4'==2
  replace `6'=`1'*0.25 if `3'==2&`4'==1
  
  replace `6'=0 if `3'==2&`4'==0
  
  
  replace `6'=`2' if `3'==1&`5'==4
  replace `6'=`2'*0.75 if `3'==1&`5'==3
  replace `6'=`2'*0.5 if `3'==1&`5'==2
  replace `6'=`2'*0.25 if `3'==1&`5'==1
  
  replace `6'=0 if `3'==1&`5'==0
mvencode `6', mv(0) override

end

*.1.** Fees 3
cfee3 SPYRR312 SPYRR311 SEX SPNMR312 SPNMR311 scfees3
cfee3 SPYRR314 SPYRR313 SEX SPNMR314 SPNMR313 scextrafees3

egen double fees3 = rowtotal(scfees3 scextrafees3)

*.2.** uniform 3
cfee3 SPYRR310 SPYRR309 SEX SPNMR310 SPNMR309 uniform3
*.3.** Clothing 3
cfee3 SPYRR303 SPYRR304 SEX SPNMR303 SPNMR304 clothing3
*.4.** Shoes 3
cfee3 SPYRR307 SPYRR308 SEX SPNMR307 SPNMR308 shoes3

*********************************************
*.5.** Books 3
*********************************************

capture program drop cbooks3
program define cbooks3 /* arguments */

  gen `3'=`1' if `2'==4
  replace `3'=`1'*0.75 if `2'==3
  replace `3'=`1'*0.5 if `2'==2
  replace `3'=`1'*0.25 if `2'==1
  
  replace `3'=0 if `2'==0
  
mvencode `3', mv(0) override

end

cbooks3 SPYRR315 SPNMR315 books3


*********************************************
** TOTAL EXPENDITURE - ROUND 3
*********************************************
egen double totalinvest3 = rowtotal(fees3 books3 uniform3 clothing3 shoes3)

label var totalinvest3 "Expenditure on YL children"

gen lntotalinvest3 = ln(totalinvest3)
label var lntotalinvest3 "Log expenditure on YL children"


egen double ztotalinvest3 = std(totalinvest3)
egen double zlntotalinvest3 = std(lntotalinvest3)

label var ztotalinvest3 "Expenditure on YL children"
label var zlntotalinvest3 "Expenditure on YL children"

keep childid totalinvest3 ztotalinvest3 lntotalinvest3 zlntotalinvest3 fees3 books3 uniform3 clothing3 shoes3 ///
EVNTR301 EVNTR312 EVNTR313 EVNTR347  EVNTR314 EVNTR316 EVNTR324 EVNTR325 /// 
EVNTR328 EVNTR329 EVNTR331 EVNTR348 EVNTR337 EVNTR338 EVNTR339 ///
EVNTR301 EVNTR310 EVNTR312 EVNTR313 EVNTR347 EVNTR314 EVNTR316 EVNTR323 ///
EVNTR324 EVNTR325 EVNTR326 EVNTR327 EVNTR328 EVNTR329 EVNTR330 EVNTR331 EVNTR348 ///
EVNTR332 EVNTR334 EVNTR335 EVNTR336 EVNTR337 EVNTR338 EVNTR339 EVNTR340 EVNTR341 EVNTR342 EVNTR345 ///
EVNTR312 EVNTR313 EVNTR314 EVNTR324 EVNTR325 EVNTR328 EVNTR329 EVNTR337 EVNTR338 EVNTR339 EVNTR316

tempfile  exp3
save     `exp3'	

********************************************************************************
                      ** EXPENDITURE - ROUND 2**
********************************************************************************

use R2/vnchildlevel12yrold.dta, clear

rename CHILDID childid

recode SPYR12 SPYR11 SPYR14 SPYR13 SPYR15 SPYR10 SPYR09 SPYR03 SPYR04 SPYR07 SPYR08 (-77=.) (-79=.) (-88=.) (-99=.) (-8=.)
recode SPNAME12 SPNAME11 SPNAME14 SPNAME13 SPNAME15 SPNAME10 SPNAME09 SPNAME03 SPNAME04 SPNAME07 SPNAME08 (77=.) (79=.) (88=.) (99=.)

*********************************************
capture program drop cfee2
program define cfee2 /* arguments are amount timeunit dayswk hoursdy yramt */

  gen `6'=`1' if `3'==2&`4'==4
  replace `6'=`1'*0.75 if `3'==2&`4'==3
  replace `6'=`1'*0.5 if `3'==2&`4'==2
  replace `6'=`1'*0.25 if `3'==2&`4'==1
  
  replace `6'=`2' if `3'==1&`5'==4
  replace `6'=`2'*0.75 if `3'==1&`5'==3
  replace `6'=`2'*0.5 if `3'==1&`5'==2
  replace `6'=`2'*0.25 if `3'==1&`5'==1

mvencode `6', mv(0) override

end

*.1.** Fees 2
cfee2 SPYR12 SPYR11 SEX SPNAME12 SPNAME11 scfees2
cfee2 SPYR14 SPYR13 SEX SPNAME14 SPNAME13 scextrafees2

egen double fees2 = rowtotal(scfees2 scextrafees2)

*.2.** uniform 2
cfee2 SPYR10 SPYR09 SEX SPNAME10 SPNAME09 uniform2

*.3.** Clothing 2
cfee2 SPYR03 SPYR04 SEX SPNAME03 SPNAME04 clothing2
   
*.4.** Shoes 2
cfee2 SPYR07 SPYR08 SEX SPNAME07 SPNAME08 shoes2

*********************************************
*.2.** Books 2
*********************************************
capture program drop cbooks2
program define cbooks2 /* arguments */

  gen `3'=`1' if `2'==4
  replace `3'=`1'*0.75 if `2'==3
  replace `3'=`1'*0.5 if `2'==2
  replace `3'=`1'*0.25 if `2'==1
  
mvencode `3', mv(0) override

end

cbooks2 SPYR15 SPNAME15 books2

*********************************************
** TOTAL EXPENDITURE - ROUND  2
*********************************************
egen double totalinvest2 = rowtotal(fees2 books2 uniform2 clothing2 shoes2)
label var totalinvest2 "Expenditure on YL children"

gen lntotalinvest2 = ln(totalinvest2)
label var lntotalinvest2 "Log expenditure on YL children"

egen double ztotalinvest2 = std(totalinvest2)
egen double zlntotalinvest2 = std(lntotalinvest2)

label var ztotalinvest2 "Expenditure on YL children"
label var zlntotalinvest2 "Expenditure on YL children"

  
keep childid totalinvest2 ztotalinvest2 lntotalinvest2 zlntotalinvest2 fees2 books2 uniform2 clothing2 shoes2

tempfile  exp2
save     `exp2'	
*/ save "~/Documents/Thesis/T2/Output/finalmatlab/exinvest2", replace


********************************************************************************

********* NUMBER OF HOURS STUDYING OUTSIDE SCHOOL and QUALITY OF RELATION ******

******************************************************************************** 


********************************************************************************
** Study outside school - Round 3**
********************************************************************************

use R3/vn_oc_childlevel.dta, clear
rename CHILDID childid

recode STUDYGR3 SPVIEWR3 TRFAIRR3 CMSITGR3 CMBRTGR3 CMBRFRR3 CMSIFRR3 (77=.) (79=.) (88=.) (99=.) 
recode SPVIEWR3 TRFAIRR3 CMSITGR3 CMBRTGR3 CMBRFRR3 CMSIFRR3(4=.)

rename STUDYGR3 timeinvest3

label var timeinvest3 "Study hours outside school"

egen double ztimeinvest3 = std(timeinvest3)

********************************************************************************
** Quality of relationship between child and parents - Round 3 **
********************************************************************************

recode SPVIEWR3 TRFAIRR3 (3=1)(1=3)

local rel3 SPVIEWR3 TRFAIRR3 CMSITGR3 CMBRTGR3 CMBRFRR3 CMSIFRR3  

foreach x of local rel3 {
	egen double z`x'=std(`x')
	}

egen double zrel3 = rowmean(zTRFAIRR3 zCMSITGR3 zCMBRTGR3 zCMBRFRR3 zCMSIFRR3)
label var zrel3 "Quality of relationship"  

egen double REL3 = rowmean(TRFAIRR3 CMSITGR3 CMBRTGR3 CMBRFRR3 CMSIFRR3)
label var REL3 "Quality of relationship, Raw Score"

alpha SPVIEWR3 TRFAIRR3 CMSITGR3 CMBRTGR3 CMBRFRR3 CMSIFRR3, item
alpha SPVIEWR3 TRFAIRR3 CMSITGR3 CMBRTGR3 CMBRFRR3 CMSIFRR3, item std
pwcorr SPVIEWR3 TRFAIRR3 CMSITGR3 CMBRTGR3 CMBRFRR3 CMSIFRR3


keep childid timeinvest3 ztimeinvest3 REL3 zrel3 SPVIEWR3 TRFAIRR3 CMSITGR3 CMBRTGR3 CMBRFRR3 CMSIFRR3  

* save "~/Documents/Thesis/T2/Output/finalmatlab/timeandrelateinvest3", replace

merge 1:1 childid using `exp3'
drop _merge


save Output/invest3, replace

********************************************************************************
** Study outside school - Round 2 **
********************************************************************************


use R2/vnchildquest12yrold.dta, clear
rename CHILDID childid

recode CSTUDY (-77=.) (-79=.) (-88=.) (-99=.)

recode OBEY NOTALK LOVED NOSUPP SPEAK FAIRPUN SISLESS TIMATT BROLESS BROFREE SISFREE PARWOR (77=.) (79=.) (88=.) (99=.) 

rename CSTUDY timeinvest2
label var timeinvest2 "Study hours outside school"

egen double ztimeinvest2 = std(timeinvest2)

********************************************************************************
** Quality of relationship between child and parents - Round 2 **
********************************************************************************
recode OBEY LOVED SPEAK FAIRPUN TIMATT (4=1) (3=2) (2=3) (1=4) 
 
local rel2 OBEY NOTALK LOVED NOSUPP SPEAK FAIRPUN SISLESS TIMATT BROLESS BROFREE SISFREE PARWOR    

foreach x of local rel2 {
	egen double z`x'=std(`x')
	}

egen double zrel2 = rowmean(zOBEY zNOTALK zLOVED zNOSUPP zSPEAK zFAIRPUN zSISLESS zTIMATT zBROLESS zBROFREE zSISFREE zPARWOR)
label var zrel2 "Quality of relationship" 

egen double REL2 = rowmean(OBEY NOTALK LOVED NOSUPP SPEAK FAIRPUN SISLESS TIMATT BROLESS BROFREE SISFREE PARWOR)
label var REL2 "Quality of relationship, Raw Score"

alpha OBEY NOTALK LOVED NOSUPP SPEAK FAIRPUN SISLESS TIMATT BROLESS BROFREE SISFREE PARWOR, item
alpha OBEY NOTALK LOVED NOSUPP SPEAK FAIRPUN SISLESS TIMATT BROLESS BROFREE SISFREE PARWOR, item std
pwcorr OBEY NOTALK LOVED NOSUPP SPEAK FAIRPUN SISLESS TIMATT BROLESS BROFREE SISFREE PARWOR

keep childid timeinvest2 ztimeinvest2 REL2 zrel2 OBEY NOTALK LOVED NOSUPP SPEAK FAIRPUN SISLESS TIMATT BROLESS BROFREE SISFREE PARWOR


* save "~/Documents/Thesis/T2/Output/finalmatlab/timeandrelateinvest2", replace


merge 1:1 childid using `exp2'
drop _merge


save Output/invest2, replace


*===============================================================================
*===============================================================================
********************************************************************************

          ********* PRENTAL - CAREGIVER NONCOGNITIVE  SKILLS *************
		  
******************************************************************************** 

********************************************************************************
** Parental - Caregiver Non-cognitive - Round 3 **
********************************************************************************


use R3/vn_oc_householdlevel.dta, clear
rename CHILDID childid

recode CPS1R3 CPS2R3 CPS3R3 CPS4R3 CPS5R3 CAG1R3 CAG2R3 CAG3R3 CAG4R3 CAG5R3 CSD1R3 CSD2R3 CSD3R3 STSHTHR3 (77=.) (79=.) (88=.) (99=.)

rename STSHTHR3 phealthy3

local parses3 CPS1R3 CPS2R3 CPS3R3 CPS4R3 CPS5R3   

foreach x of local parses3 {
	egen double z`x'=std(`x')
	}

egen double zparses3 = rowmean(zCPS1R3 zCPS2R3 zCPS3R3 zCPS4R3 zCPS5R3)
label var zparses3 "Parental Self-Esteem"

egen double PARSES3 = rowmean(CPS1R3 CPS2R3 CPS3R3 CPS4R3 CPS5R3)
label var PARSES3 "Self-Esteem, Raw Score"

*-------------------------------------------
recode CAG4R3 CAG5R3(5=1) (4=2) (2=4) (1=5)

local parsef3 CAG1R3 CAG2R3 CAG3R3 CAG4R3 CAG5R3

foreach x of local parsef3 {
	egen double z`x'=std(`x')
	}

egen double zparsef3 = rowmean(zCAG1R3 zCAG2R3 zCAG3R3 zCAG4R3 zCAG5R3)
label var zparsef3 "Parental Self-Efficacy"

egen double PARSEF3 = rowmean(CAG1R3 CAG2R3 CAG3R3 CAG4R3 CAG5R3)
label var PARSEF3 "Self-Efficacy, Raw Score"


*-------------------------------------------

recode CSD2R3 CSD3R3(5=1) (4=2) (2=4) (1=5)
local parser3 CSD1R3 CSD2R3 CSD3R3

foreach x of local parser3 {
	egen double z`x'=std(`x')
	}

egen double zparser3 = rowmean(zCSD1R3 zCSD2R3 zCSD3R3)
label var zparser3 "Self-respect and Inclusion"

egen double PARSER3 = rowmean(CSD1R3 CSD2R3 CSD3R3)
label var PARSER3 "Self-respect and Inclusion, Raw Score"

keep childid PARSES3 PARSEF3 PARSER3 zparses3 zparsef3 zparser3 phealthy3

save Output/pncog3, replace


********************************************************************************
** Parental - Caregiver Non-cognitive - Round 2 **
********************************************************************************



use R2/vnchildlevel12yrold.dta, clear
rename CHILDID childid

recode CPS1 CPS2 CPS3 CPS4 CPS5 CAG1 CAG2 CAG3 CAG4 CAG5 CSD1 CSD2 CSD3 (77=.) (79=.) (88=.) (99=.)

recode CPS1 CPS3 CPS4 CPS5 (4=1) (3=2) (2=3) (1=4) 
local parses2 CPS1 CPS2 CPS3 CPS4 CPS5  

foreach x of local parses2 {
	egen double z`x'=std(`x')
	}

egen double zparses2 = rowmean(zCPS1 zCPS2 zCPS3 zCPS4 zCPS5)
label var zparses2 "Parental Self-Esteem"

egen double PARSES2 = rowmean(CPS1 CPS2 CPS3 CPS4 CPS5)
label var PARSES2 "Self-Esteem, Raw Score"

alpha CPS1 CPS2 CPS3 CPS4 CPS5, item
alpha CPS1 CPS2 CPS3 CPS4 CPS5, item std
pwcorr CPS1 CPS2 CPS3 CPS4 CPS5
*-------------------------------------------
recode CAG1 CAG2 (4=1) (3=2) (2=3) (1=4) 

local parsef2 CAG1 CAG2 CAG3 CAG4 CAG5

foreach x of local parsef2 {
	egen double z`x'=std(`x')
	}

egen double zparsef2 = rowmean(zCAG1 zCAG2 zCAG3 zCAG4 zCAG5)
label var zparsef2 "Parental Self-Efficacy"

egen double PARSEF2 = rowmean(CAG1 CAG2)
label var PARSEF2 "Self-Efficacy, Raw Score"

alpha CAG1 CAG2 CAG3 CAG4 CAG5, item
alpha CAG1 CAG2 CAG3 CAG4 CAG5, item std
pwcorr CAG1 CAG2 CAG3 CAG4 CAG5
/*
The items CAG3, CAG4, CAG5  are excluded b/c it is negatively correlated with the other items of the scale.
*/
*-------------------------------------------

recode CSD1 (4=1) (3=2) (2=3) (1=4) 
local parser2 CSD1 CSD2 CSD3

foreach x of local parser2 {
	egen double z`x'=std(`x')
	}

egen double zparser2 = rowmean(zCSD1 zCSD2 zCSD3) 
* NOTE NOTE NOTE BEFORE ONLY zCSD1
label var zparser2 "Self-respect and Inclusion"

egen double PARSER2 = rowmean(CSD1 CSD2 CSD3)
label var PARSER2 "Self-respect and Inclusion, Raw Score"
alpha CSD1 CSD2 CSD3, item
alpha CSD1 CSD2 CSD3, item std
pwcorr CSD1 CSD2 CSD3

keep childid PARSES2 PARSEF2 PARSER2 zparses2 zparsef2 zparser2
save Output/pncog2, replace



*===============================================================================
*===============================================================================
********************************************************************************
          ********* Parental - Health - Take Round 2*************
******************************************************************************** 


use R2/vnchildlevel12yrold.dta, clear

rename CHILDID childid

recode MTWEIGHT MTHEIGHT (-77=.) (-79=.) (-88=.) (-99=.)

rename MTWEIGHT mtweight
rename MTHEIGHT mtheight

local prhealth mtweight mtheight

foreach x of local prhealth {
	egen double z`x'=std(`x')
	}
	
	

keep childid mtweight mtheight zmtweight zmtheight

save Output/phealth, replace


********************************************************************************

          ********* PRENTAL COGNITIVE  SKILLS *************
	*******  Mother's and father's years of education  *************
  ******* This corrects mistakes and inconsistences from the Young Lives files *
		  
******************************************************************************** 

**============================================================================**
/*
* Correct mom's and dad's education across 5 rounds of YLS and 
create mom's and dad's education profile (Correct mistakes and inconsistences from
the Young Lives files)

*/
**============================================================================**

***** Mother's education *****

**============================================================================**		
			
use CHILDID ID SEX RELATE YRSCHOOL using round1/vnsubsec2householdroster8.dta, clear

gen mother=1 if RELATE==1 & SEX==2
keep if mother==1                                   
recode RELATE YRSCHOOL (88 99=.)
recode YRSCHOOL (45=13) (46=14) (42 43 44=.)
rename CHILDID childid
rename ID momid
rename YRSCHOOL momedu
keep childid mom*
g round=1
tempfile  mom1
save     `mom1'	

use CHILDID ID MEMSEX LIVHSE GRADE RELATE CHGRADE using Round2/vnsubhouseholdmember12.dta, clear
gen mother=1 if RELATE==1 & MEMSEX==2
keep if mother==1 
recode LIVHSE RELATE GRADE CHGRADE (77 79 88 99=.)
rename CHILDID childid
rename ID momid
rename LIVHSE momlive
rename GRADE momedu
replace momedu=CHGRADE if missing(momedu)
keep childid mom*
g round=2
tempfile  mom2
save     `mom2'


use CHILDID ID MEMSEX RELATE LIVHSE GRADE using Round3/vn_oc_householdmemberlevel.dta, clear
gen mother=1 if RELATE==1 & MEMSEX==2
keep if mother==1 
recode LIVHSE (4=2) (77 79 88 99 5=.)
recode GRADE (16=28) (17=29)
rename CHILDID childid
rename ID momid
rename LIVHSE momlive
rename GRADE momedu			
recode momedu (18=17) (19=16) (77 79 88 99=.)
keep childid mom*		
g round=3
tempfile  mom3
save     `mom3'	

use CHILDCODE MEMIDR4 MEMSEXR4 MEMAGER4 RELATER4 GRDE18R4 LIVHSER4 YRDIEDR4 using Round4/VN_R4_OCHH_HouseholdRosterR4.dta, clear
recode GRDE18R4 (77 79 88 99=.) 
recode MEMAGER4 (-88 -77=.)
gen mother=1 if RELATER4==1 & MEMSEXR4==2
gen childid="VN"+string(CHILDCODE, "%06.0f")
keep if mother==1	
recode LIVHSER4 (4=2) (77 79 88 99 5=.)			
rename MEMIDR4 momid
rename MEMAGER4 momage
rename LIVHSER4 momlive
rename GRDE18R4 momedu
rename YRDIEDR4 momyrdied
drop if childid=="VN110072" & momid==6
drop if childid=="VN170039" & momid==7
keep childid mom*
g round=4
tempfile  mom4
save     `mom4'	

use CHILDCODE MEMIDR5 MEMSEXR5 MEMAGER5 RELATER5 GRDE18R5 LIVHSER5 YRDIEDR5 using Round5/vn_r5_ochh_householdrosterr5, clear

recode GRDE18R5 (77 79 88 99=.) 
recode MEMAGER5 (-88 -77 1 2=.)
gen mother=1 if RELATER5==1 & MEMSEXR5==2
gen childid="VN"+string(CHILDCODE, "%06.0f")
keep if mother==1	
recode LIVHSER5 (4=2) (77 79 88 99 5=.)			
rename MEMIDR5 momid
rename MEMAGER5 momage
rename LIVHSER5 momlive
rename GRDE18R5 momedu
rename YRDIEDR5 momyrdied
drop if childid=="VN041002" & momid==7
drop if childid=="VN110072" & momid==6
drop if childid=="VN170039" & momid==7
keep childid mom*
g round=5
tempfile  mom5
save     `mom5'					


	* MERGE
			use `mom1', clear
			forvalues i=2/5 {
				qui append using `mom`i''
				}					
			sort childid round
			tempfile    mom
			save       `mom'		
		
			use childid round momid using `mom', clear
			egen momid2=mode(momid), by(childid) 
			drop momid
			merge 1:1 childid round using `mom', nogen
			recode momage momedu momlive momyrdied (*=.) if momid!=momid2
			drop momid
			rename momid2 momid
			sort childid round
			tempfile    mom
			save       `mom'			
						
			sort childid round
			keep childid momid momedu round
			g inround=1
			reshape wide momedu inround, i(childid momid) j(round)
		
			* Step 1:
			local r=4
			forvalues i=1/4 {
				local j=`r'+1
				replace momedu`r'=momedu`j' if missing(momedu`r')
				local r=`r'-1
				}
		
			* Step 2:
			forvalues i=1/4 {
				local j=`i'+1
				replace momedu`j'=momedu`i' if missing(momedu`j')
				}
				
			* Step 3:	
			local r=4
			forvalues i=1/4 {
				local j=`r'+1
				replace momedu`r'=momedu`j' if momedu`r'>momedu`j' 
				local r=`r'-1
				}
			reshape long
			keep if inround==1
			drop inround
			rename momedu momeducorr
			
			merge 1:1 childid round using `mom', nogen
			drop momedu
			rename momeducorr momedu
			
			replace momlive=3 if momlive[_n-1]==3 & childid==childid[_n-1]
			recode momage (*=.) if momlive==3
			bys childid: egen diedround=min(round) if momlive==3
			bys childid: egen yrdied=min(momyrdied) if momlive==3
			replace momyrdied=yrdied
			recode momage momedu momyrdied momlive (*=.) if diedround!=round & diedround!=.
			recode momage momedu (*=.) if momlive==3			
			keep childid round mom*

label var momedu		"Mother's level of education"
			label define educ1  0 "None" ///
							   1 "Grade 1" ///
							   2 "Grade 2" ///
							   3 "Grade 3" ///
							   4 "Grade 4" ///
							   5 "Grade 5" ///
							   6 "Grade 6" ///
							   7 "Grade 7" ///
							   8 "Grade 8" ///
							   9 "Grade 9" ///
							  10 "Grade 10" ///
							  11 "Grade 11" ///
							  12 "Grade 12" ///
							  13 "Post-secondary, vocational" ///
							  14 "University" ///
							  15 "Masters, doctorate" ///
							  28 "Adult literacy" ///
							  29 "Religious education" ///
							  30 "Other" 
label values momedu educ1			
			
drop if round!=3	
keep childid momedu 		
save Output/momedu, replace	

			
********************************************************************************
***** Father's education *****
********************************************************************************
			
			
			
use CHILDID ID SEX RELATE YRSCHOOL using Round1/vnsubsec2householdroster8.dta, clear

gen father=1 if RELATE==1 & SEX==1
keep if father==1                                   
recode RELATE YRSCHOOL (88 99=.)
recode YRSCHOOL (45=13) (46=14) (42 43 44=.)
rename CHILDID childid
rename ID dadid
rename YRSCHOOL dadedu
keep childid dad*
g round=1
tempfile  dad1
save     `dad1'	

use CHILDID ID MEMSEX LIVHSE GRADE RELATE CHGRADE using Round2/vnsubhouseholdmember12.dta, clear
gen father=1 if RELATE==1 & MEMSEX==1
keep if father==1 
recode LIVHSE RELATE GRADE CHGRADE (77 79 88 99=.)
rename CHILDID childid
rename ID dadid
rename LIVHSE dadlive
rename GRADE dadedu
replace dadedu=CHGRADE if missing(dadedu)
keep childid dad*
g round=2
tempfile  dad2
save     `dad2'


use CHILDID ID MEMSEX RELATE LIVHSE GRADE using Round3/vn_oc_householdmemberlevel.dta, clear
gen father=1 if RELATE==1 & MEMSEX==1
keep if father==1 
recode LIVHSE (4=2) (77 79 88 99 5=.)
recode GRADE (16=28) (17=29)
rename CHILDID childid
rename ID dadid
rename LIVHSE dadlive
rename GRADE dadedu			
recode dadedu (18=17) (19=16) (77 79 88 99=.)
keep childid dad*		
g round=3
tempfile  dad3
save     `dad3'	

use CHILDCODE MEMIDR4 MEMSEXR4 MEMAGER4 RELATER4 GRDE18R4 LIVHSER4 YRDIEDR4 using Round4/VN_R4_OCHH_HouseholdRosterR4.dta, clear
recode GRDE18R4 (77 79 88 99=.) 
recode MEMAGER4 (-88 -77=.)
gen father=1 if RELATER4==1 & MEMSEXR4==1
gen childid="VN"+string(CHILDCODE, "%06.0f")
keep if father==1	
recode LIVHSER4 (4=2) (77 79 88 99 5=.)			
rename MEMIDR4 dadid
rename MEMAGER4 dadage
rename LIVHSER4 dadlive
rename GRDE18R4 dadedu
rename YRDIEDR4 dadyrdied
keep childid dad*
g round=4
tempfile  dad4
save     `dad4'	

use CHILDCODE MEMIDR5 MEMSEXR5 MEMAGER5 RELATER5 GRDE18R5 LIVHSER5 YRDIEDR5 using Round5/vn_r5_ochh_householdrosterr5, clear

recode GRDE18R5 (77 79 88 99=.) 
recode MEMAGER5 (-88 -77 1 2=.)
gen father=1 if RELATER5==1 & MEMSEXR5==1
gen childid="VN"+string(CHILDCODE, "%06.0f")
keep if father==1	
recode LIVHSER5 (4=2) (77 79 88 99 5=.)			
rename MEMIDR5 dadid
rename MEMAGER5 dadage
rename LIVHSER5 dadlive
rename GRDE18R5 dadedu
rename YRDIEDR5 dadyrdied
keep childid dad*
g round=5
tempfile  dad5
save     `dad5'					


	* MERGE
			use `dad1', clear
			forvalues i=2/5 {
				qui append using `dad`i''
				}					
			sort childid round
			tempfile    dad
			save       `dad'			

			use childid round dadid using `dad', clear
			egen dadid2=mode(dadid), by(childid) 
			replace dadid2=4 if childid=="VN180011"
			drop dadid
			merge 1:1 childid round using `dad', nogen
			recode dadage dadedu dadlive dadyrdied (*=.) if dadid!=dadid2
			drop dadid
			rename dadid2 dadid
			sort childid round
			tempfile    dad
			save       `dad'		
			
			sort childid round
			keep childid dadid dadedu round
			g inround=1
			reshape wide dadedu inround, i(childid dadid) j(round)
		
			* Step 1:
			local r=4
			forvalues i=1/4 {
				local j=`r'+1
				replace dadedu`r'=dadedu`j' if missing(dadedu`r')
				local r=`r'-1
				}
		
			* Step 2:
			forvalues i=1/4 {
				local j=`i'+1
				replace dadedu`j'=dadedu`i' if missing(dadedu`j')
				}
				
			* Step 3:	
			local r=4
			forvalues i=1/4 {
				local j=`r'+1
				replace dadedu`r'=dadedu`j' if dadedu`r'>dadedu`j' 
				local r=`r'-1
				}
			reshape long
			keep if inround==1
			drop inround
			rename dadedu dadeducorr
			
			merge 1:1 childid round using `dad', nogen
			drop dadedu
			rename dadeducorr dadedu
			
			
			replace dadlive=3 if dadlive[_n-1]==3 & childid==childid[_n-1]
			recode dadage (*=.) if dadlive==3
			bys childid: egen diedround=min(round) if dadlive==3
			bys childid: egen yrdied=min(dadyrdied) if dadlive==3
			replace dadyrdied=yrdied
			recode dadage dadedu dadyrdied dadlive (*=.) if diedround!=round & diedround!=.
			recode dadage dadedu (*=.) if dadlive==3			
			keep childid round dad*
			
label var dadedu		"Father's level of education"
				label define educ2  0 "None" ///
							   1 "Grade 1" ///
							   2 "Grade 2" ///
							   3 "Grade 3" ///
							   4 "Grade 4" ///
							   5 "Grade 5" ///
							   6 "Grade 6" ///
							   7 "Grade 7" ///
							   8 "Grade 8" ///
							   9 "Grade 9" ///
							  10 "Grade 10" ///
							  11 "Grade 11" ///
							  12 "Grade 12" ///
							  13 "Post-secondary, vocational" ///
							  14 "University" ///
							  15 "Masters, doctorate" ///
							  28 "Adult literacy" ///
							  29 "Religious education" ///
							  30 "Other" 
			label values dadedu educ2
			
drop if round!=3
keep childid dadedu			

save Output/dadedu, replace	

merge 1:1 childid using momedu 
drop _merge


use vietnam_constructed.dta, clear
drop if round!=3
drop if yc==1
keep childid round momlive dadlive caredu caresex carerel headedu headsex headrel

merge 1:1 childid using momdadedu
drop _merge

recode momedu dadedu caredu headedu (28=0)

replace dadedu=caredu if caresex==1 & carerel==1&dadedu==.
replace momedu=caredu if caresex==2 & carerel==1&momedu==.

replace dadedu=headedu if headsex==1 & headrel==1&dadedu==.
replace momedu=headedu if headsex==2 & headrel==1&momedu==.			
			
gen paredu=max(momedu, dadedu)
replace paredu=caredu if momedu==.&dadedu==.
replace paredu=caredu if paredu==.

replace dadedu=0 if dadedu==.
replace momedu=0 if momedu==.


gen parlev=1 if paredu<5
replace parlev=2 if paredu>=5&paredu<9
replace parlev=3 if paredu>=9&paredu<12
replace parlev=4 if paredu==12
replace parlev=5 if paredu>12&paredu!=.

gen dadlev=1 if dadedu<5
replace dadlev=2 if dadedu>=5&dadedu<9
replace dadlev=3 if dadedu>=9&dadedu<12
replace dadlev=4 if dadedu==12
replace dadlev=5 if dadedu>12&dadedu!=.

gen momlev=1 if momedu<5
replace momlev=2 if momedu>=5&momedu<9
replace momlev=3 if momedu>=9&momedu<12
replace momlev=4 if momedu==12
replace momlev=5 if momedu>12&momedu!=.

replace dadedu=14 if dadedu==13
replace dadedu=16 if dadedu==14

replace momedu=14 if momedu==13
replace momedu=16 if momedu==14

save Output/paredu, replace

sjlog close, replace
