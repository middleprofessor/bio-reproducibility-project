# Anderson et al. 2018. Herbivory and eutrophication mediate grassland plant 
# nutrient responses across a global climatic gradient. In press, Ecology.

# Model 1 - requires the file 'Model1.LRR.data.csv'

# In this analysis, the relative effects of nutrient addition are quantified by 
# calculating the log response ratios (LRR) within blocks at each site: 
# log((total nutrient content in fertilized)/(total nutrient content in control)).
# LRR for each block and site are plotted against solar insolation, MAP, MAT and 
# soil %N for both fenced and unfenced treatments. An analysis of covariance using 
# the 'lm' command is used to determine if the slopes of the LRR ~ environmental 
# predictors were different for levels of FENCE.

# load libraries
  library(bbmle)
  library(car)
  library(piecewiseSEM)

# set working directory
  setwd(".")
  
# read in data
  mod1.dat <- read.csv('Model1.LRR.data.csv')

# statistically test for the effect of MAP, MAT, solar insolation and soil % nitrogen 
# on logged response ratio of plant nutrient concentrations (g m-2) using ANCOVA 
# design and AICc model selection approach:

# CARBON
  C.mod1 <- lm(mod1.dat$LRR.C ~ 1, data=mod1.dat)
  C.mod2 <- lm(mod1.dat$LRR.C ~ mod1.dat$TREATMENT, data=mod1.dat)
  C.mod3 <- lm(mod1.dat$LRR.C ~ mod1.dat$MAP, data=mod1.dat)
  C.mod4 <- lm(mod1.dat$LRR.C ~ mod1.dat$MAT, data=mod1.dat)
  C.mod5 <- lm(mod1.dat$LRR.C ~ mod1.dat$SOLAR.INS, data=mod1.dat)
  C.mod6 <- lm(mod1.dat$LRR.C ~ mod1.dat$SOIL.PCT.N, data=mod1.dat)
  C.mod7 <- lm(mod1.dat$LRR.C ~ mod1.dat$MAP + mod1.dat$TREATMENT, data=mod1.dat)
  C.mod8 <- lm(mod1.dat$LRR.C ~ mod1.dat$MAT + mod1.dat$TREATMENT, data=mod1.dat)
  C.mod9 <- lm(mod1.dat$LRR.C ~ mod1.dat$SOLAR.INS + mod1.dat$TREATMENT, data=mod1.dat)
  C.mod10 <- lm(mod1.dat$LRR.C ~ mod1.dat$SOIL.PCT.N + mod1.dat$TREATMENT, data=mod1.dat)
  C.mod11 <- lm(mod1.dat$LRR.C ~ mod1.dat$MAP * mod1.dat$TREATMENT, data=mod1.dat)
  C.mod12 <- lm(mod1.dat$LRR.C ~ mod1.dat$MAT * mod1.dat$TREATMENT, data=mod1.dat)
  C.mod13 <- lm(mod1.dat$LRR.C ~ mod1.dat$SOLAR.INS * mod1.dat$TREATMENT, data=mod1.dat)
  C.mod14 <- lm(mod1.dat$LRR.C ~ mod1.dat$SOIL.PCT.N * mod1.dat$TREATMENT, data=mod1.dat)
  
# select best model by AICc model selection  
  AICctab(C.mod1, C.mod2, C.mod3, C.mod4, C.mod5, C.mod6, C.mod7, C.mod8, C.mod9, C.mod10, 
          C.mod11, C.mod12, C.mod13, C.mod14, sort=TRUE)
  
# inspect the best model  
  summary(C.mod11)
  Anova(C.mod11, type=3)
  sem.model.fits(C.mod11)
  
# NITROGEN
  N.mod1 <- lm(mod1.dat$LRR.N ~ 1, data=mod1.dat)
  N.mod2 <- lm(mod1.dat$LRR.N ~ mod1.dat$TREATMENT, data=mod1.dat)
  N.mod3 <- lm(mod1.dat$LRR.N ~ mod1.dat$MAP, data=mod1.dat)
  N.mod4 <- lm(mod1.dat$LRR.N ~ mod1.dat$MAT, data=mod1.dat)
  N.mod5 <- lm(mod1.dat$LRR.N ~ mod1.dat$SOLAR.INS, data=mod1.dat)
  N.mod6 <- lm(mod1.dat$LRR.N ~ mod1.dat$SOIL.PCT.N, data=mod1.dat)
  N.mod7 <- lm(mod1.dat$LRR.N ~ mod1.dat$MAP + mod1.dat$TREATMENT, data=mod1.dat)
  N.mod8 <- lm(mod1.dat$LRR.N ~ mod1.dat$MAT + mod1.dat$TREATMENT, data=mod1.dat)
  N.mod9 <- lm(mod1.dat$LRR.N ~ mod1.dat$SOLAR.INS + mod1.dat$TREATMENT, data=mod1.dat)
  N.mod10 <- lm(mod1.dat$LRR.N ~ mod1.dat$SOIL.PCT.N + mod1.dat$TREATMENT, data=mod1.dat)
  N.mod11 <- lm(mod1.dat$LRR.N ~ mod1.dat$MAP * mod1.dat$TREATMENT, data=mod1.dat)
  N.mod12 <- lm(mod1.dat$LRR.N ~ mod1.dat$MAT * mod1.dat$TREATMENT, data=mod1.dat)
  N.mod13 <- lm(mod1.dat$LRR.N ~ mod1.dat$SOLAR.INS * mod1.dat$TREATMENT, data=mod1.dat)
  N.mod14 <- lm(mod1.dat$LRR.N ~ mod1.dat$SOIL.PCT.N * mod1.dat$TREATMENT, data=mod1.dat)
  
# select best model by AICc model selection  
  AICctab(N.mod1, N.mod2, N.mod3, N.mod4, N.mod5, N.mod6, N.mod7, N.mod8, N.mod9, N.mod10, 
          N.mod11, N.mod12, N.mod13, N.mod14, sort=TRUE)
  
# inspect the best model  
  summary(N.mod11)
  Anova(N.mod11, type=3)
  sem.model.fits(N.mod11)
  
# PHOSPHORUS
  P.mod1 <- lm(mod1.dat$LRR.P ~ 1, data=mod1.dat)
  P.mod2 <- lm(mod1.dat$LRR.P ~ mod1.dat$TREATMENT, data=mod1.dat)
  P.mod3 <- lm(mod1.dat$LRR.P ~ mod1.dat$MAP, data=mod1.dat)
  P.mod4 <- lm(mod1.dat$LRR.P ~ mod1.dat$MAT, data=mod1.dat)
  P.mod5 <- lm(mod1.dat$LRR.P ~ mod1.dat$SOLAR.INS, data=mod1.dat)
  P.mod6 <- lm(mod1.dat$LRR.P ~ mod1.dat$SOIL.PCT.N, data=mod1.dat)
  P.mod7 <- lm(mod1.dat$LRR.P ~ mod1.dat$MAP + mod1.dat$TREATMENT, data=mod1.dat)
  P.mod8 <- lm(mod1.dat$LRR.P ~ mod1.dat$MAT + mod1.dat$TREATMENT, data=mod1.dat)
  P.mod9 <- lm(mod1.dat$LRR.P ~ mod1.dat$SOLAR.INS + mod1.dat$TREATMENT, data=mod1.dat)
  P.mod10 <- lm(mod1.dat$LRR.P ~ mod1.dat$SOIL.PCT.N + mod1.dat$TREATMENT, data=mod1.dat)
  P.mod11 <- lm(mod1.dat$LRR.P ~ mod1.dat$MAP * mod1.dat$TREATMENT, data=mod1.dat)
  P.mod12 <- lm(mod1.dat$LRR.P ~ mod1.dat$MAT * mod1.dat$TREATMENT, data=mod1.dat)
  P.mod13 <- lm(mod1.dat$LRR.P ~ mod1.dat$SOLAR.INS * mod1.dat$TREATMENT, data=mod1.dat)
  P.mod14 <- lm(mod1.dat$LRR.P ~ mod1.dat$SOIL.PCT.N * mod1.dat$TREATMENT, data=mod1.dat)
  
# select best model by AICc model selection  
  AICctab(P.mod1, P.mod2, P.mod3, P.mod4, P.mod5, P.mod6, P.mod7, P.mod8, P.mod9, P.mod10, 
          P.mod11, P.mod12, P.mod13, P.mod14, sort=TRUE)
  
# inspect the best model  
  summary(P.mod11)
  Anova(P.mod11, type=3)
  sem.model.fits(P.mod11)
  
# POTASSIUM
  K.mod1 <- lm(mod1.dat$LRR.K ~ 1, data=mod1.dat)
  K.mod2 <- lm(mod1.dat$LRR.K ~ mod1.dat$TREATMENT, data=mod1.dat)
  K.mod3 <- lm(mod1.dat$LRR.K ~ mod1.dat$MAP, data=mod1.dat)
  K.mod4 <- lm(mod1.dat$LRR.K ~ mod1.dat$MAT, data=mod1.dat)
  K.mod5 <- lm(mod1.dat$LRR.K ~ mod1.dat$SOLAR.INS, data=mod1.dat)
  K.mod6 <- lm(mod1.dat$LRR.K ~ mod1.dat$SOIL.PCT.N, data=mod1.dat)
  K.mod7 <- lm(mod1.dat$LRR.K ~ mod1.dat$MAP + mod1.dat$TREATMENT, data=mod1.dat)
  K.mod8 <- lm(mod1.dat$LRR.K ~ mod1.dat$MAT + mod1.dat$TREATMENT, data=mod1.dat)
  K.mod9 <- lm(mod1.dat$LRR.K ~ mod1.dat$SOLAR.INS + mod1.dat$TREATMENT, data=mod1.dat)
  K.mod10 <- lm(mod1.dat$LRR.K ~ mod1.dat$SOIL.PCT.N + mod1.dat$TREATMENT, data=mod1.dat)
  K.mod11 <- lm(mod1.dat$LRR.K ~ mod1.dat$MAP * mod1.dat$TREATMENT, data=mod1.dat)
  K.mod12 <- lm(mod1.dat$LRR.K ~ mod1.dat$MAT * mod1.dat$TREATMENT, data=mod1.dat)
  K.mod13 <- lm(mod1.dat$LRR.K ~ mod1.dat$SOLAR.INS * mod1.dat$TREATMENT, data=mod1.dat)
  K.mod14 <- lm(mod1.dat$LRR.K ~ mod1.dat$SOIL.PCT.N * mod1.dat$TREATMENT, data=mod1.dat)
  
# select best model by AICc model selection  
  AICctab(K.mod1, K.mod2, K.mod3, K.mod4, K.mod5, K.mod6, K.mod7, K.mod8, K.mod9, K.mod10, 
          K.mod11, K.mod12, K.mod13, K.mod14, sort=TRUE)
  
# inspect the best model  
  summary(K.mod11)
  Anova(K.mod11, type=3)
  sem.model.fits(K.mod11)  

# END ANALYSIS