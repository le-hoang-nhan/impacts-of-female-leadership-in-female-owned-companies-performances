**----------------------------------------------------------------------
** OB Analyze female leadership in three measurements: innovation, accessing credit and performance from BEEPS data
**----------------------------------------------------------------------
** Information on the panel is available here: 
**https://ebrd-beeps.com/wp-content/uploads/2017/08/beeps_iv_v_panel_note.pdf
cd "G:\database Industrial\database\beeps\beeps_panel"
use "G:\database Industrial\database\beeps\beeps_panel/beeps_iv_v_panel.dta", clear
set more off

**rename general variables
rename i1 security 
rename i2a security_exp  
rename i3 robbery
rename i4a robbery_exp
rename country countryname
rename b4 female_own  
rename b7a female_manager
rename l5 female  
rename a4b sector  
rename a6a size  
rename a7 partoflargerfirm
rename b1 legalstatus
rename b2a ownerx 
rename b2b ownery 
rename b2c ownerz 
rename b2d ownerj 
rename ecaq5 typesofestablishment 
rename b5 yearofestablishment  
rename b8 certifications 
rename c22a email 
rename c23 internet
rename c22b website
rename c28 mobilephones
rename c30a electricityobstacle
rename c30b telecomunicaionsobstacle
rename n3 turnover_3 
rename d2 turnover 
rename d3a nationalsales
rename d3b indirectexports 
rename d3c directexports
rename d30b customandtraderegulationobstacle
rename d8 yearoffirstexports 
rename e1 mainmarket
rename e2 numberofcompetitors 
rename e6 licensedfromforeign
rename i30 crime 
rename k30 financeobstacle
rename j30a taxrateobstacle
rename j30c licensingobstacle
rename j30f corruptionobstacle
rename l2 empl3yearsago
rename ecaq69 emplwithuniversitydegree
rename l10 formaltraining
rename l30a labourregulationobstacle
rename l30b lackofskillobstacle
rename m1a obstacles

**rename innovation variables
rename h1 newproducts 
rename h2 productsnewtothefirmmarket
rename h3 newprocess 
rename h4 organizationinnovation 
rename h5 marketinginnovation 
rename h6 expenditureinRandD 
rename ecah8 timetoemployeestoinnovate  
rename g30a landobstacle
rename ecao1a howmanyproducts 
rename ecao2a localmarketproduct 
rename ecao2b countrymarketproduct
rename ecao2c internationalmarketproduct
rename ecao3a newfunctions
rename ecao3b newmaterials
rename ecao3c newtechnology
rename ecao3d newlook
rename ecao3e completelynew
rename ecao3f othernew
rename ecao4 innovativeannualsales
rename ecao5 wayofintroductionproduct
rename ecao6  purchaseorlicenseproduct
rename ecao7a productionprocess
rename ecao7b logistics
rename ecao7c supportservice
rename ecao9a localmarketprocess
rename ecao9b countrymarketprocess
rename ecao9c internationalmarketprocess
rename ecao11 wayofintroductionprocess
rename ecao12 purchaseorlicenseprocess
rename ecao17 rd

**rename loans variables
rename k15c totalvalueloans
rename k8  linecreditfrombank
rename k11  lastvalueloan
rename k14a  landcollateral
rename k14b  equipmentcollateral
rename k14c  accountscollateral
rename k14d  personalcollateral
rename k14e  othercollateral
rename k15d  personalloanstofinance
rename k16  lastyearapplyloans
rename k15  percentcollateral
rename k18 rejectednewloan

**rename performance variables
rename n2a totallaborcost
rename n2e rawmaterialscost
rename n2f fuelcost
rename n2i resellfinishedgoodscost
rename n2b electricitycost
rename n2ra rentalmachineryrcost
rename n2rb rentallandcost
rename n2c communicationscost
rename n2h watercost
rename l1 empl
rename ecaq53 subsidies 

**Create Sale revenue variable
gen ln_sale = log(turnover)

**Create Total Loan value variable
gen ln_loan = log(totalvalueloans)

**Create log R&D variable
gen ln_rd = log(rd)

** Create Age variable
gen age = 2017 - yearofestablishment
reg age female_manager

**Create ln_lp variable
tab countryname if empl!=.
tab countryname if turnover!=.
gen ln_lp=log(turnover/empl)  

**cleaning the datasets
foreach x in crime robbery_exp robbery security security_exp sector size partoflargerfirm legalstatus ownerx ownery ownerz ownerj typesofestablishment yearofestablishment certifications email website internet mobilephones electricityobstacle telecomunicaionsobstacle turnover_3 turnover nationalsales indirectexports directexports customandtraderegulationobstacle yearoffirstexport mainmarket numberofcompetitors licensedfromforeign subsidies newproducts productsnewtothefirmmarket newprocess organizationinnovation marketinginnovation expenditureinRandD timetoemployeestoinnovate  landobstacle financeobstacle taxrateobstacle licensingobstacle corruptionobstacle empl empl3yearsago emplwithuniversitydegree formaltraining labourregulationobstacle lackofskillobstacle obstacles howmanyproducts localmarketproduct countrymarketproduct internationalmarketproduct newfunctions newmaterials newtechnology newlook completelynew othernew innovativeannualsales wayofintroductionproduct  purchaseorlicenseproduct productionprocess logistics supportservice localmarketprocess countrymarketprocess internationalmarketprocess wayofintroductionprocess purchaseorlicenseprocess rd female_own female_manager female{
replace `x'=. if `x'<0 
	}

local varlist "howmanyproducts newfunctions newtechnology productsnewtothefirmmarket newprocess organizationinnovation marketinginnovation expenditureinRandD timetoemployeestoinnovate innovativeannualsales purchaseorlicenseproduct productionprocess rd totalvalueloans linecreditfrombank lastvalueloan landcollateral equipmentcollateral accountscollateral personalcollateral othercollateral personalloanstofinance lastyearapplyloans totallaborcost rawmaterialscost fuelcost resellfinishedgoodscost electricitycost rentalmachineryrcost rentallandcost communicationscost watercost age subsidies percentcollateral rejectednewloan"
 foreach x in `varlist'{
replace `x' = . if `x' < 0
 }

 
**Create a dummy with yes = 1, no = 0 
foreach x in female_manager newproducts newfunctions newtechnology productsnewtothefirmmarket newprocess organizationinnovation marketinginnovation expenditureinRandD timetoemployeestoinnovate innovativeannualsales purchaseorlicenseproduct productionprocess linecreditfrombank landcollateral equipmentcollateral accountscollateral personalcollateral othercollateral personalloanstofinance lastyearapplyloans rejectednewloan {
	replace `x'=0 if `x'==2 
	}
		
**Drop sectors with many missing value
tab sector if female!=.
drop if sector == 14 |  sector == 19 | sector == 20 |  sector == 21 | sector == 22 |  sector == 23 | sector == 30 |  sector == 32 | sector == 33 |  sector == 34 | sector == 35 |  sector == 36 | sector == 37 |  sector == 61 | sector == 62 |  sector == 65 | sector == 66|  sector == 70 | sector == 71 |  sector == 74 | sector == 90 |  sector == 93   

**Create area groups
generate eec=1 if countryname=="Georgia" | countryname=="Moldova" | countryname=="Ukraine" | countryname=="Armenia" | countryname=="Russia"| countryname=="Turkey"| countryname=="Belarus"| countryname=="Azerbaijan"    
replace eec=0 if eec==.

generate ceb=1 if countryname=="Estonia" |countryname=="Slovak Rep." |countryname=="Latvia" |countryname=="Poland" |countryname=="Lithuania" |countryname=="Slovenia" |countryname=="Hungary" |countryname=="Croatia"|countryname=="Czech Rep." 
replace ceb=0 if ceb==.

generate see=1 if countryname=="FYR Macedonia" |countryname=="Bosnia and Herz." |countryname=="Greece" |countryname=="Montenegro"|countryname=="Romania"|countryname=="Serbia"|countryname=="Bulgaria"|countryname=="Albania"|countryname=="Cyprus"|countryname=="Kosovo"      
replace see=0 if see==.

replace countryname = "Kyrgyzstan" if countryname == "Kyrgyz Rep."

generate ca=1 if countryname=="Mongolia" |countryname=="Kyrgyzstan"| countryname=="Tajikistan"| countryname=="Kazakhstan"| countryname=="Uzbekistan"
replace ca=0 if ca==.

gen areag=1 if eec==1
replace areag=2 if ceb==1
replace areag=3 if see==1
replace areag=4 if ca==1

**show number of firms in each area
tab areag

**check the variable female has a lot of missing value
tab countryname if female!=.
tab countryname if female_manager!=.
tab female_manager, m  
tab female, m

**Provide some descriptive statistics
******************************
** show mean of ln_lp across countries and sectors
table countryname, content (mean ln_lp)
table sector, content (mean ln_lp)

** show means of these variables acorss sector by each area (create table 1)
bysort areag : table female_manager , content (mean howmanyproducts)
bysort areag : table female_manager , content (mean ln_loan)
bysort areag : table female_manager , content (mean ln_sale)
bysort areag : table female_manager , content (mean ln_lp)
bysort areag : table female_manager , content (mean rejectednewloan)
bysort areag : table female_manager , content (mean empl)
bysort areag : table female_manager , content (mean age)
bysort areag : table female_manager , content (mean ln_rd)

*show precentages of female managers across sectors by each area (create table 2)
tab sector if female!=.
bysort areag : tab sector if female!=. 

cd "G:\database Industrial\database\beeps\beeps_panel"

** RUN THE REGRESSION FOR TABLE 3 (combine many excel files into table 3)
**FOR INNOVATIONS MEASUREMENT
**for howmanyproducts varibale 
** Only includes a dummy for female_manager (column 1)
foreach x in 1 2 3 4 {
reg howmanyproducts female_manager  if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using howmanyproducts.csv,replace p

** includes also country fixed effects (column 2)
foreach x in 1 2 3 4 {
reg howmanyproducts female_manager i.a1 if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using howmanyproductscountryname.csv,replace p

** includes also controls, country fixed effects and sector fixed effects (column 3)
foreach x in 1 2 3 4 {
areg howmanyproducts female_manager newfunctions productsnewtothefirmmarket organizationinnovation marketinginnovation timetoemployeestoinnovate innovativeannualsales purchaseorlicenseproduct productionprocess ln_rd i.a1 if areag == `x' , absorb(sector) 
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using howmanyproductscountrynamesector.csv,replace p

**for ln_rd varibale
** Only includes a dummy for female_manager (column 1)
foreach x in 1 2 3 4 {
reg ln_rd female_manager if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_rd.csv,replace p

** includes also country fixed effects (column 2)
foreach x in 1 2 3 4 {
reg ln_rd female_manager i.a1 if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_rdcountryname.csv,replace p

** includes also controls, country fixed effects and sector fixed effects (column 3)
foreach x in 1 2 3 4 {
areg ln_rd female_manager newfunctions productsnewtothefirmmarket organizationinnovation marketinginnovation timetoemployeestoinnovate innovativeannualsales purchaseorlicenseproduct productionprocess howmanyproducts i.a1 if areag == `x' , absorb(sector) 
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_rdcountrynamesector.csv,replace p

**FOR EFFICIENCY MEASUREMENT
**for ln_sale variable
** Only includes a dummy for female_manager(column 1)
foreach x in 1 2 3 4 {
reg ln_sale female_manager if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_sale.csv,replace p

** includes also country fixed effects (column 2)
foreach x in 1 2 3 4 {
reg ln_sale female_manager i.a1 if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_salecountryname.csv,replace p

** includes also controls, country fixed effects and sector fixed effects (column 3)
foreach x in 1 2 3 4 {
areg ln_sale female_manager age empl lastvalueloan howmanyproducts  i.a1 if areag == `x' , absorb(sector) 
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_salecountrynamesector.csv,replace p

**for ln_lp variable
** Only includes a dummy for female_manager (column 1)
foreach x in 1 2 3 4 {
reg ln_lp female_manager if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_lp.csv,replace p

** includes also country fixed effects(column 2)
foreach x in 1 2 3 4 {
reg ln_lp female_manager i.a1 if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_lpcountryname.csv,replace p

** includes also controls, country fixed effects and sector fixed effects (column 3)
foreach x in 1 2 3 4 {
areg ln_lp female_manager age empl lastvalueloan howmanyproducts  i.a1 if areag == `x' , absorb(sector) 
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_lpcountrynamesector.csv,replace p

**FOR LOANS MEASUREMENT
**for ln_loan variable
** Only includes a dummy for female_manager(column 1) 
foreach x in 1 2 3 4 {
reg ln_loan female_manager if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_loan.csv,replace p

** includes also country fixed effects (column 2)
foreach x in 1 2 3 4 {
reg ln_loan female_manager i.a1 if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_loancountryname.csv,replace p

** includes also controls, country fixed effects and sector fixed effects(column 3)
foreach x in 1 2 3 4 {
areg ln_loan female_manager lastvalueloan landcollateral equipmentcollateral accountscollateral personalcollateral othercollateral personalloanstofinance lastyearapplyloans i.a1 if areag == `x' , absorb(sector) 
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using ln_loancountrynamesector.csv,replace p

**for rejectednewloan variable
** Only includes a dummy for female_manager (column 1)
foreach x in 1 2 3 4 {
reg rejectednewloan female_manager if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using rejectednewloan.csv,replace p

** includes also country fixed effects (column 2)
foreach x in 1 2 3 4 {
reg rejectednewloan female_manager i.a1 if areag == `x'
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using rejectednewloancountryname.csv,replace p

** includes also controls, country fixed effects and sector fixed effects (column 3)
foreach x in 1 2 3 4 {
areg rejectednewloan female_manager lastvalueloan landcollateral i.a1 if areag == `x' , absorb(sector) 
est store m`x'
}

esttab m1 m2 m3 m4, p
esttab m1 m2 m3 m4 using rejectednewloancountrynamesector.csv,replace p


