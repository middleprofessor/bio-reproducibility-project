# analysis of http://datadryad.org/resource/doi:10.5061/dryad.25b8f
# Jeffrey Walker
# December 31, 2017

library(lsmeans)
library(data.table)
library(doBy)

# CTmin thermal limits at 5 days for 19C mean for +/- 8C treatment
fn <- 'CTmin_5d_8_19.csv'
fly <- fread(fn, stringsAsFactors = TRUE)
# remove no.29 ctmin=5.48 (following paper) as this is outlier
fly <- fly[ctmin<5,]

# published table thinks these are type III ANOVA but the results are type I
form <- formula('ctmin ~ dev.treat*ad.treat')
fit <- lm(form, data=fly)
anova(fit) # type I

# type III is not much different except the "critical" p-value!
options(contrasts=c(unordered="contr.sum", ordered="contr.poly"))
Anova(lm(form, data=fly), type='III')
options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))

# recode dev.treat and ad.treat so THCplot is interpretable
# fly[, dev.treat:=paste('DT',dev.treat,sep='-')]
# fly[, ad.treat:=paste('AT',ad.treat,sep='-')]
 fly[, dev.treat:=ifelse(dev.treat=='fluct','D+','D-')]
 fly[, ad.treat:=ifelse(ad.treat=='fluct','A+','A-')]
 
# re-order so that ad.treat starts with const first
fly <- orderBy(~dev.treat + ad.treat, fly)

write.table(fly, paste('recode.',fn,sep=''), sep='\t', quote=FALSE, row.names=FALSE)

form <- formula('ctmin ~ dev.treat*ad.treat')
fit <- lm(form, data=fly)
lsm <- lsmeans(fit,specs=c('dev.treat','ad.treat'))
diff <- contrast(lsm, method='revpairwise')

library(ggplot2)
library(car)
library(emmeans)
library(data.table)
file_list <- c('CTmin_9d_8_23.csv',
           'CTmin_9d_8_19.csv',
           'CTmax_9d_8_23.csv',
           'CTmax_9d_8_19.csv',
           'CTmin_9d_4_23.csv',
           'CTmin_9d_4_19.csv',
           'CTmax_9d_4_23.csv',
           'CTmax_9d_4_19.csv',
           'CTmin_5d_8_23.csv',
           'CTmin_5d_8_19.csv',
           'CTmax_5d_8_23.csv',
           'CTmax_5d_8_19.csv',
           'CTmin_5d_4_19,23.csv',
           'CTmax_5d_4_19,23.csv',
           'CTmin_2d_8_19,23.csv',
           'CTmin_2d_4_19,23.csv',
           'CTmax_2d_8_19,23.csv',
           'CTmax_2d_4_19,23.csv')

for(fn in file_list){
  fly <- fread(fn)
  form <- formula('ctmin ~ dev.treat*ad.treat')
  fit <- lm(form, data=fly)
  anova(fit) # type I
  
  # type III is not much different except the "critical" p-value!
  options(contrasts=c(unordered="contr.sum", ordered="contr.poly"))
  Anova(lm(form, data=fly), type='III')
  options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))
  
}
