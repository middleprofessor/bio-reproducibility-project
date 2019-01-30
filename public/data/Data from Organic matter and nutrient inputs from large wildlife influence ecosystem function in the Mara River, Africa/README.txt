README File for the data accompanying the following manuscript:

Title:

Organic matter and nutrient inputs from large wildlife influence ecosystem function in the Mara River, Africa

Authors:

Amanda L. Subalusky1,2*, Christopher L. Dutton1, Laban Njoroge3, Emma J. Rosi2, David M. Post1

Affiliations:

1Department of Ecology and Evolutionary Biology, Yale University, New Haven, CT, USA
2Cary Institute of Ecosystem Studies, Millbrook, NY, USA
3Invertebrate Zoology Section, National Museums of Kenya, Nairobi, Kenya


*Corresponding author: Amanda Subalusky, Email: asubalusky@gmail.com


Overview:

Data included here from this manuscript are in various status of curation. Some data is presented in a relatively raw format and other data have been cleaned and processed for analysis. If you require data in a different state of curation, please reach out to us and we'll do our best to accomodate.  

Files:

Subalusky_2018_mara_biochemical_oxygen_demand.csv

This file contains data on biochemical oxygen demand measured over 5 days in 310 ml bottles in water samples collected from the water column at our three primary study sites.

site	=	Site 1, Site 2 or Site 3 (site descriptions given in the manuscript)
data	=	data sample was collected from the river, between Aug. 2012 and Feb. 2014; final measurements were conducted 5 days later
time	=	time of day sample was collected from the river
temp	=	temperature of water sample right after collected in Celsius
dDO	=	change in dissolved oxygen over 5 days (final minus initial reading ) in mg/L
days	=	the total number of days over which the sample was incubated
BOD.ug.day	=	the total biochemical oxygen demand in the water sample in ug O2 day-1, calculated as the total amount of oxygen consumed in * the volume of the bottle (310 ml) / the total number of days


Subalusky_2018_mara_experimental_stream_tiles.csv

This file contains data on the biofilm growth and production of indvidual ceramic tiles placed in experimental streams and destructively sampled weekly to measure biofilm growth over time

id	=	the individual experimental stream
treatment	=	the experimental treatment; control: no subsidy added; hippo: hippo feces added; wildebeest: wildebeest muscle tissue added; Hippo Wildebeest: both hippo feces and wildebeest tissue were added; details of experimental treatments available in the ms
days	=	the total number of days the tile had been in the experimental stream
date	=	the date the tile was collected from the experimental stream
AFDM	=	ash free dry mass in mg cm-2 per tile (methods described in paper)
Chl	=	chlorophyll a in ug cm-2 per tile (methods described in paper)
Chl AFDM-1	=	the ratio of chl a to AFDM on the tile
GPP	=	gross primary production in ug O2 cm-2 hr-1(methods described in paper); negative GPP values were treated as 0 for analysis as we assumed GPP had been too low to measure
GPP.no0	=	GPP data with a very small value (0.00001) added to values of 0 to enable log transformation
CR	=	the absolute value of community respiration in ug O2 cm-2 hr-1 (methods described in paper)
CR.no0	=	CR data with a very small value (0.00001) added to values of 0 to enable log transformation


Subalusky_2018_mara_hippo_feces_decomp_litterbags.csv

This file contains data on decomposition rates of hippo feces in litterbags in the Mara River

treatment	=	experimental treatment, where A: 40 g fresh hippo feces; B: 10 g aged hippo feces; C: 10 g aged hippo feces + 20 g wildebeest tissue
id	=	individual litterbag id
date	=	the date the litterbag was collected from the river
days	=	the number of days the litterbag was inside the river
hippo pre	=	the pre-weighed dry mass of the hippo feces when the litterbag was initially deployed (details in methods of the paper)
hippo post	=	the dry mass of the hippo feces after the litterbag was collected from the river
hippo prop rem	=	the proportion of the hippo feces remaining after the litterbag was collected from the river
adj hippo prop rem	=	the proportion of the hippo feces remaining after the litterbag was collected from the river, adjusted for loss on initial deployment
adj hippo pct rem	=	the adjusted proportion of remaining hippo feces as a percent
ln hippo prop rem	=	the natural log of the adjusted proportion of remaining hippo feces


Subalusky_2018_mara_nutrient_dissolution_chambers.csv

This file contains data on nutrient dissolution of hippo feces and wildebeest tissue measured using 5L chamber experiments filled with river water

data	=	the date the sample was measured
treatment	=	the experimental treatment; H 1: 1 g fresh hippo feces; H 5: 5 g fresh hippo feces; H 20: 20 g fresh hippo feces; HW: 5 g fresh hippo feces and 26 g wildebeest muscle tissue; W: 26 g wildebeest muscle tissue
hours	=	the total number of hours the wildlife input had been in the chamber before the sample was collected
SRP	=	net soluble reactive phosphorus produced in mg, measured as the concentration * total chamber volume (5 L) - the mean total amount in the control chambers
SRP.no0	=	SRP measurement corrected by adding a constant value so the lowest measurement was >0
NH4	=	net ammonium produced in mg, measured as the concentration * total chamber volume (5 L) - the mean total amount in the control chambers
NH4.no0	=	NH4 measurement corrected by adding a constant value so the lowest measurement was >0
DOC	=	net dissolved organic carbon produced in mg, measured as the concentration * total chamber volume (5 L) - the mean total amount in the control chambers
DOC.no0	=	DOC measurements corrected by adding a constant value so the lowest measurement was >0
DO	=	net dissolved oxygen consumed in mg, measured as the concentration * total chamber volume (5 L) - the mean total amount in the control chambers


Subalusky_2018_mara_nutrient_limitation_assays.csv

This file contains data on biofilm growth on nutrient-diffusing substrates, comprised of glass discs (for measurements of cholorophyll a) and cellulose sponges (for measurements of respiration) on cups of agar amended with different nutrients.

year	=	year experiment was conducted; either 2011 or 2013
site	=	Site 1, Site 2 or Site 3 (site descriptions given in the manuscript)
id	=	cup id in the experimental array
substrate	=	either fritted glass disc or cellulose spong
treatment	=	nutrients added to agar cup; Ctl: control, C: carbon (only measured in 2013), H: ammonium, N: nitrate, P: phosphate, HP: ammonium + phosphate, NP: nitrate + phosphate
NEP	=	net ecosystem production in ug O2 cm-2 hr-1, measured as the net change in dissolved oxygen during light treatment * volume of water in the container (50 ml) / hours of treatment  / area of substrate
CR	=	community respiration in ug O2 cm-2 hr-1, measured as the net change in dissolved oxygen during dark treatment * volume of water in the container / hours of treatment / area of substrate; data only analyzed for heterotrophic community on cellulose sponges
CR.corr	=	the absolute value of CR data; where CR was measured as a positive increase in DO, we assumed actual respiration was too low to measure so assigned it as 0
CR.corr.no0	=	a very small value (0.00001) was added to all 0 values to allow log transformation
GPP	=	gross primary production in ug O2 cm-2 hr-1, measured as (NEP - CR) * volume of water in the container / hours of treatment / area of substrate; negative GPP values were treated as 0 for analysis as we assumed GPP had been too low to measure; data not used in analysis
GPP.corr	=	where GPP was measured as a decrease in DO, we assumed actual production was too low to measure so assigned it as 0
GPP.corr.no0	=	a very small value (0.00001) was added to all 0 values to allow log transformation
Chl	=	chlorophyll a in ug cm-2 (methods described in paper); data only analyzed as proxy for production of autotrophic community on glass discs
Chl.corr	=	where Chl was measured as negative, we assumed actual Chl a was too low to measure so assigned it as 0
Chl.corr.no0	=	a very small value (0.00001) was added to all 0 values to allow log transformation



Subalusky_2018_mara_river_biofilm_alldata.csv

This file contains data on the biofilm growth and production on individual ceramic tiles placed in the Mara River at our three primary study sites for 3-4 weeks at a time; these are the individual values for 4-5 tiles at each site at each sampling period. The mean values for each site and visit were used for analysis.

date	=	the date the tile was collected from the river, after having been deployed for 3-4 weeks
site	=	Site 1, Site 2 or Site 3 (site descriptions given in the manuscript)
sample	=	the code for the individual tile measured
NEP	=	net ecosystem production in ug O2 cm-2 hr-1, measured as the net change in dissolved oxygen during light treatment * volume of water in the container (300 ml) / hours of treatment (2-4 hours) / area of ceramic tile (56.25 cm-2)
CR	=	community respiration in ug O2 cm-2 hr-1, measured as the net change in dissolved oxygen during dark treatment * volume of water in the container (300 ml) / hours of treatment (2-4 hours)/ area of ceramic tile (56.25 cm-2)
GPP	=	gross primary production in ug O2 cm-2 hr-1, measured as (NEP - CR) * volume of water in the container (300 ml) / hours of treatment (2-4 hours)/ area of ceramic tile (56.25 cm-2); negative GPP values were treated as 0 for analysis as we assumed GPP had been too low to measure
Chl	=	chlorophyll a in ug cm-2 per tile (methods described in paper)
AFDM	=	ash free dry mass in mg cm-2 per tile (methods described in paper)


Subalusky_2018_mara_river_biofilm_summary_data.csv

This file contains data on the mean biofilm growth and production on ceramic tiles placed in the Mara River at our three primary study sites for 3-4 weeks at a time; these are the mean values averaged for 4-5 tiles at each site at each sampling period. These are the data that were used for analysis in the paper. 

date	=	the date the tile was collected from the river, after having been deployed for 3-4 weeks
site	=	Site 1, Site 2 or Site 3 (site descriptions given in the manuscript)
site.wb	=	Site 1, Site 2 or Site 3 with indication of whether fresh carcasses had been present upstream of Site 3 within the last month (Site - wb) or not (Site - no wb)
NEP	=	mean net ecosystem production in ug O2 cm-2 hr-1, measured as the net change in dissolved oxygen during light treatment * volume of water in the container (300 ml) / hours of treatment (2-4 hours) / area of ceramic tile (56.25 cm-2)
CR	=	mean community respiration in ug O2 cm-2 hr-1, measured as the net change in dissolved oxygen during dark treatment * volume of water in the container (300 ml) / hours of treatment (2-4 hours)/ area of ceramic tile (56.25 cm-2)
GPP	=	mean gross primary production in ug O2 cm-2 hr-1, measured as (NEP - CR) * volume of water in the container (300 ml) / hours of treatment (2-4 hours)/ area of ceramic tile (56.25 cm-2); negative GPP values were treated as 0 for analysis as we assumed GPP had been too low to measure
Chl	=	mean chlorophyll a in ug cm-2 per tile (methods described in paper)
AFDM	=	mean ash free dry mass in mg cm-2 per tile (methods described in paper)


Subalusky_2018_mara_river_nutrients_tenpttransect.csv

This file contains data on carbon and nutrient concentrations measured along a 10 point sampling transect down the Mara River, and the mean and standard error of all C and nutrient measurements over the period of study at our three primary study sites.

season	=	wet or dry; the season the sample was collected for the 10 point samples
date	=	the date the sample was collected for the 10 point samples
site.name	=	the distance of the sampling site in river kilometers from the most upstream site, Site 1
site.no	=	the locations of our three primary study sites: Site 1, Site 2 or Site 3 (site descriptions given in the manuscript)
time	=	the time the sample was collected
DOC	=	dissolved organic carbon in mg L-1
NO3	=	nitrate in ug L-1
SRP	=	 soluble reactive phosphorus in ug L-1
NH4	=	ammonium in ug L-1
TN	=	total nitrogen in mg L-1
TP	=	total phosphorus in ug L-1
Chl	=	chlorophyll a in ug L-1
CPOM	=	coarse particulate organic matter in mg L-1; the two very high values (8.80 from site 83 in wet season; 0.4 form site 71 in dry season) were not included in the figure in the paper for easier visualization
NH4.mean	=	mean ammonium in ug L-1 at our primary study sites over the period of the study
NH4.se	=	standard error of ammonium in ug L-1 at our primary study sites over the period of the study
SRP.mean	=	mean soluble reactive phosphorus in ug L-1 at our primary study sites over the period of the study
SRP.se	=	standard error of soluble reactive phosphorus in ug L-1 at our primary study sites over the period of the study
TN.mean	=	mean total nitrogen in mg L-1 at our primary study sites over the period of the study
TN.se	=	standard error of total nitrogen in mg L-1 at our primary study sites over the period of the study
TP.mean	=	mean total phosphorus in ug L-1 at our primary study sites over the period of the study
TP.se	=	standard error of total phosphorus in ug L-1 at our primary study sites over the period of the study
DOC.mean	=	mean dissolved organic carbon in mg L-1 at our primary study sites over the period of the study
DOC.se	=	standard error of dissolved organic carbon in mg L-1 at our primary study sites over the period of the study
CPOM.mean	=	mean coarse particulate organic matter in mg L-1 at our primary study sites over the period of the study
CPOM.se	=	standard error of coarse particulate organic matter in mg L-1 at our primary study sites over the period of the study


Subalusky_2018_mara_river_physicochem_nutrient_data.csv

This file contains data on discharge and water column parameters measured monthly at our three primary study sites in the Mara River from Jun-Aug 2011, Jul-Dec 2012, and Aug 2013-Mar 2014. 

site	=	Site 1, Site 2 or Site 3 (site descriptions given in the manuscript)
site.dist	=	the distance of the sampling site in river kilometers from the most upstream site, Site 1
carcasses	=	yes or no; indication of whether fresh carcasses had been present upstream of Site 3 within the last month (y) or not (n)
date	=	date sample was collected in the field
Manta.time	=	time Manta2 sonde data was recorded
discharge	=	discharge measured at Site 1 (for Site 1 and 2) or Site 3 in m3 sec-1
Temp_deg_C	=	river temperature in degree C as measured by Manta2sonde
Turb_NTU	=	river turbidity in NTU as measured by Manta2sonde
Chl_ug.l	=	river chlorophyll a in ug L-1 as measured by an optical probe on Manta2sonde; not used in analysis
HDO_mg.l	=	river dissolved oxygen in mg L-1 as measured by Manta2sonde
HDO_.Sat	=	river dissolved oxygen in % saturation as measured by Manta2sonde
SpCond_uS.cm	=	river specific conductivity in uS cm-1 as measured by Manta2sonde
SpCond_mS.cm	=	river specific conductivity in mS cm-1 as measured by Manta2sonde
Salinity_PSS	=	river salinity in practical salinity scale as measured by Manta2sonde
TDS_mg.l	=	river total dissolved solutes in mg L-1 as measured by Manta2sonde
pH_units	=	river pH as measured by Manta2sonde
pH_mV	=	river pH in mV as measured by Manta2sonde
Int_Batt_V	=	internal battery voltage of Manta2sonde
BP_mmHg	=	barometric pressure of atmosphere as measured by In-Situ logger
Sample Time	=	the recorded time the river sample was collected
DOC.mgL	=	dissolved organic carbon in mg L-1 measured in a sample of river water
DOC.Flux.kgd	=	daily flux of dissolved organic carbon in kg day-1
NO3.ugL	=	nitrate in ug L-1 measured in a sample of river water
NO3.Flux.kgd	=	daily flux of nitrate in kg day-1
PO4.ugL	=	soluble reactive phosphorus in ug L-1 measured in a sample of river water
PO4.Flux.kgd	=	daily flux of soluble reactive phosphorus in kg day-1
NH4.ugL	=	ammonium in ug L-1 measured in a sample of river water
NH4.Flux.kgd	=	 daily flux of ammonium in kg day-1
TDN.mgL	=	total dissolved nitrogen in mg L-1 measured in a sample of river water
TDP.ugL	=	 total dissolved phosphorus in ug L-1 measured in a sample of river water
TN.mgL	=	total nitrogen in mg L-1 measured in a sample of river water
TN.ugL	=	 total nitrogen in ug L-1 measured in a sample of river water
TN.Flux.kgd	=	daily flux of total nitroen in kg day-1
TP.ugL	=	total phosphorus in ug L-1 measured in a sample of river water
TP.Flux.kgd	=	daily flux of total phosphorus in kg day-1
TSS.mgL	=	total suspended sediments in mg L-1 measured in a sample of river water
TSS.flux.kgd	=	daily flux of total suspended sediments in kg day-1
AFDM.mgL	=	ash free dry mass in mg L-1
AFDM.Flux.kgd	=	daily flux of ash free dry mass in kg day-1
Org.pct	=	percent of total suspeded sediments comprised or organic material
Chl.ugL	=	chlorophyll a in ug L-1 measured in a sample of river water
CPOM.mgL	=	coarse particulate organic matter in mg L-1 measured in a sample of river water
CPOM.flux.kgd	=	daily flux of coarse particulate organic matter in kg day-1
