########################################################################################################################################
#########################		digitize and analyze landmark data with geometric morphometrix						################################
#########################		Richard Svanbäck	Jan 10, 2014													################################
########################################################################################################################################

###################################################################################
rm(list=ls()) # clears workspace
###################################################################################


### Load metadata
meta <- read.csv("/Users/lirichard/My documents/3. My Projects/1. Pågående Projekt/43. Yinghua/1. Predation-food ration morphology/1. Morphology/1. NTS photo order/metadata.csv")
attach(meta)
names(meta)

plot(log(Intestine) ~ log(Length))
model <- lm(log(Intestine) ~ log(Length))
summary(model)
intestine_resids <- resid(model)
meta <- cbind(meta, intestine_resids)

plot(log(Weight) ~ log(Length))
model <- lm(log(Weight) ~ log(Length))
summary(model)
weight_resids <- resid(model)
meta <- cbind(meta, weight_resids)






#### Required libraries
require(geomorph)
library(shapes)
library(svd)
library(scatterplot3d)
library(rgl)
library(MASS)
library(ape)
library(vegan)
library(psych)
library(gplots)
library(nlme)
library(ggplot2)

###################################################################################
###   function needed for summary statistics and making plots in ggplot2
###################################################################################

##### First run these lines to attach the function "summarySE"

## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
    require(plyr)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    # This does the summary. For each group's data frame, return a vector with
    # N, mean, and sd
    datac <- ddply(data, groupvars, .drop=.drop,
      .fun = function(xx, col) {
        c(N    = length2(xx[[col]], na.rm=na.rm),
          mean = mean   (xx[[col]], na.rm=na.rm),
          sd   = sd     (xx[[col]], na.rm=na.rm)
        )
      },
      measurevar
    )

    # Rename the "mean" column    
    datac <- rename(datac, c("mean" = measurevar))

    datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval: 
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$ci <- datac$se * ciMult

    return(datac)
}



#######################################
# 
# If already digitized then start here
#
#######################################


setwd("/Users/lirichard/My documents/3. My Projects/1. Pågående Projekt/43. Yinghua/1. Predation-food ration morphology/1. Morphology/1. NTS photo order")
myFiles <- dir(pattern="[nN][tT][sS]")
#mylands <- readmulti.nts(myFiles)

mylands <- matrix(NA,nrow = length(myFiles), ncol = 32) 

for(i in 1:length(myFiles)){
	individual <- readland.nts(myFiles[i])
	new <- two.d.array(individual) #not sure why, but had to convert the landmarks into a 2-D array
	mylands[i,] <- new
}
lands <- arrayspecs(mylands, 16, 2) # and then back into another type of landmark file



# This is needed to convert the landmark file into another set of landmark file that could be used for later analyzes etc.
#new <- two.d.array(mylands) #not sure why, but had to convert the landmarks into a 2-D array
#lands <- arrayspecs(new, 16, 2, byLand=FALSE) # and then back into another type of landmark file


# This is for superimposition of all the specimens
plotAllSpecimens(lands) # This plots the raw landmarks, without superimposition
proc <- gpagen(lands, Proj=TRUE)
proc$coords # Procrustes coordinates after superimposition
proc$Csize # the Centroid size of the specimens

# PCA of the landmarks
pca.lands <- plotTangentSpace(proc$coords, label=TRUE) # This creates a plot of the specimens in PC-space and 2 TPS grids showing the shape associated with the first axis
pca.lands$pc.summary # summary of variances associated with each PC axis
pca.lands$pc.scores # Shape variables as principal component scores


# Plot a gridplot
#ref <- apply(proc$coords, c(1,2), mean)
#ref <- mshape(proc$coords)
#pred <- mshape(proc$coords[,,1:8+14:20+25:29+32:36+38:39+49:59+63])
#pred <- mshape(proc$coords[,,1:8+14+15+16])
#d1 <- proc$coords[,,1:8]  
#d2 <- proc$coords[,,14:20]
#d3 <- proc$coords[,,1+2+3+4+5+6+7+8+14+15+16]
#d4 <- proc$coords[,,17+18+19+20]

#plotRefToTarget(ref, pred, mag=3, method="TPS", ) # This plots the difference between the consensus shape and the predation treatment



#procD.lm(two.d.array(proc$coords) ~ proc$Csize, iter=999) # This tests if there is an Allometry in shape with size (Centroid size)
#plotAllometry(proc$coords, proc$Csize, method=c("CAC")) # This plots the relationship between Csize and shape as well as gridplots

#procD.lm(two.d.array(proc$coords) ~ meta$Ratio*meta$Pike*proc$Csize, iter=999) # Procrustes ANOVA
#procD.lm(two.d.array(proc$coords) ~ meta$Ratio*meta$Pike*proc$Csize+ meta$Aquarium_ID/meta$number, iter=999) # Procrustes ANOVA

#pairwiseD.test(two.d.array(proc$coords),meta$Pike, iter=999) ### Pairwise comparisons
#pairwiseD.test(two.d.array(proc$coords),meta$Ratio, iter=999) ### Pairwise comparisons



proc.new <- two.d.array(proc$coords)   # Procrustes coordinates after superimposition but converted to be able to do a PCA

z <- prcomp(proc.new[ ,1:32]) # calculates the shape space (PC scores, same as Relative Warp scores)
PC.scores <- predict(z)


alldata <- cbind(meta, proc$Csize, PC.scores)
attach(alldata)
names(alldata)
#write.table(alldata,"/Users/lirichard/Desktop/Digitize/Photos/alldata.txt")

analyze.record <- matrix(NA,nrow = 36, ncol = 48)
colnames(analyze.record) <- c("photo_id", "sort_ID", "Aquarium_ID", "Diet", "Ratio", "Pike", "treatment_nr", "number", "Perch_ID", "Weight", "Length", "Intestine", "Sex", "intestine_resids", "weight_resids", "proc_Csize", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10", "PC11", "PC12", "PC13", "PC14", "PC15", "PC16", "PC17", "PC18", "PC19", "PC20", "PC21", "PC22", "PC23", "PC24", "PC25", "PC26", "PC27", "PC28", "PC29", "PC30", "PC31", "PC32")
for(i in 1:36){
	data <- subset(alldata, sort_ID==i)
	photo_id <- as.character(data$photo_id[1])
	analyze.record[i,1] <- as.character(data$photo_id[1])
	analyze.record[i,2] <- as.character(data$sort_ID[1])
	analyze.record[i,3] <-as.character(data$Aquarium_ID[1])
	analyze.record[i,4] <- as.character(data$Diet[1])
	analyze.record[i,5] <- as.character(data$Ratio[1])
	analyze.record[i,6] <- as.character(data$Pike[1])
	analyze.record[i,7] <- as.character(data$treatment_nr[1])
	analyze.record[i,8] <-as.character(data$number[1])
	analyze.record[i,9] <-as.character(data$Perch_ID[1])
	for(j in 10:48){
			analyze.record[i,j] <-mean(data[,j])
		}
	}
	
analyze.record <- data.frame(analyze.record)

analyze.record$PC1 <- as.numeric(as.vector(analyze.record$PC1))
analyze.record$PC2 <- as.numeric(as.vector(analyze.record$PC2))
analyze.record$PC3 <- as.numeric(as.vector(analyze.record$PC3))
analyze.record$PC4 <- as.numeric(as.vector(analyze.record$PC4))
analyze.record$PC5 <- as.numeric(as.vector(analyze.record$PC5))
analyze.record$PC6 <- as.numeric(as.vector(analyze.record$PC6))
analyze.record$PC7 <- as.numeric(as.vector(analyze.record$PC7))
analyze.record$PC8 <- as.numeric(as.vector(analyze.record$PC8))
analyze.record$PC9 <- as.numeric(as.vector(analyze.record$PC9))
analyze.record$PC10 <- as.numeric(as.vector(analyze.record$PC10))
analyze.record$PC11 <- as.numeric(as.vector(analyze.record$PC11))
analyze.record$PC12 <- as.numeric(as.vector(analyze.record$PC12))
analyze.record$PC13 <- as.numeric(as.vector(analyze.record$PC13))
analyze.record$PC14 <- as.numeric(as.vector(analyze.record$PC14))
analyze.record$PC15 <- as.numeric(as.vector(analyze.record$PC15))
analyze.record$PC16 <- as.numeric(as.vector(analyze.record$PC16))
analyze.record$PC17 <- as.numeric(as.vector(analyze.record$PC17))
analyze.record$PC18 <- as.numeric(as.vector(analyze.record$PC18))
analyze.record$PC19 <- as.numeric(as.vector(analyze.record$PC19))
analyze.record$PC20 <- as.numeric(as.vector(analyze.record$PC20))
analyze.record$PC21 <- as.numeric(as.vector(analyze.record$PC21))
analyze.record$PC22 <- as.numeric(as.vector(analyze.record$PC22))
analyze.record$PC23 <- as.numeric(as.vector(analyze.record$PC23))
analyze.record$PC24 <- as.numeric(as.vector(analyze.record$PC24))
analyze.record$PC25 <- as.numeric(as.vector(analyze.record$PC25))
analyze.record$PC26 <- as.numeric(as.vector(analyze.record$PC26))
analyze.record$PC27 <- as.numeric(as.vector(analyze.record$PC27))
analyze.record$PC28 <- as.numeric(as.vector(analyze.record$PC28))
analyze.record$PC29 <- as.numeric(as.vector(analyze.record$PC29))
analyze.record$PC30 <- as.numeric(as.vector(analyze.record$PC30))
analyze.record$PC31 <- as.numeric(as.vector(analyze.record$PC31))
analyze.record$PC32 <- as.numeric(as.vector(analyze.record$PC32))
analyze.record$proc_Csize <- as.numeric(as.vector(analyze.record$proc_Csize))
analyze.record$Length <- as.numeric(as.vector(analyze.record$Length))
analyze.record$Weight <- as.numeric(as.vector(analyze.record$Weight))
analyze.record$Intestine <- as.numeric(as.vector(analyze.record$Intestine))
analyze.record$intestine_resids <- as.numeric(as.vector(analyze.record$intestine_resids))
analyze.record$weight_resids <- as.numeric(as.vector(analyze.record$weight_resids))
analyze.record$Pike <- as.factor(analyze.record$Pike)
analyze.record$Ratio <- as.factor(analyze.record$Ratio)



par(mfrow=c(2,3))
boxplot(analyze.record$PC1 ~ analyze.record$Pike*analyze.record$Ratio, col=(c("gold","darkgreen")), main="PC1")
boxplot(analyze.record$PC2 ~ analyze.record$Pike*analyze.record$Ratio, col=(c("gold","darkgreen")), main="PC2")
boxplot(analyze.record$PC3 ~ analyze.record$Pike*analyze.record$Ratio, col=(c("gold","darkgreen")), main="PC3")
boxplot(analyze.record$PC4 ~ analyze.record$Pike*analyze.record$Ratio, col=(c("gold","darkgreen")), main="PC4")
plot(analyze.record$PC14 ~ analyze.record$proc_Csize, pch=16, main="PC14"); abline(lm(analyze.record$PC14 ~ analyze.record$proc_Csize))
plot(analyze.record$PC28 ~ analyze.record$proc_Csize, pch=16, main="PC28"); abline(lm(analyze.record$PC28 ~ analyze.record$proc_Csize))


# Mancova with cetroid size as covariate
y <- cbind(analyze.record$PC1, analyze.record$PC2, analyze.record$PC3, analyze.record$PC4, analyze.record$PC5, analyze.record$PC6, analyze.record$PC7, analyze.record$PC8, analyze.record$PC9, analyze.record$PC10, analyze.record$PC11, analyze.record$PC12, analyze.record$PC13, analyze.record$PC14, analyze.record$PC15, analyze.record$PC16, analyze.record$PC17, analyze.record$PC18, analyze.record$PC19, analyze.record$PC20, analyze.record$PC21, analyze.record$PC22, analyze.record$PC23, analyze.record$PC24, analyze.record$PC25, analyze.record$PC26, analyze.record$PC27, analyze.record$PC28)#, analyze.record$PC29, analyze.record$PC30, analyze.record$PC31, analyze.record$PC32)
fit <- manova(y ~ analyze.record$Pike * analyze.record$Ratio + analyze.record$proc_Csize)
summary(fit, test="Roy")
summary(fit, test="Pillai")
summary(fit, test="Wilks")
summary.aov(fit)







###############################################################################################################################
### Weight (residuals)

#boxplot(analyze.record$weight_resids ~ analyze.record$Pike*analyze.record$Ratio, col=(c("gold","darkgreen")), main="Weight residuals")
summary(aov(analyze.record$weight_resids ~ analyze.record$Pike*analyze.record$Ratio))

summary_weight_resids <- summarySE(analyze.record, measurevar="weight_resids", groupvars=c("Pike", "Ratio"))
pd <- position_dodge(.2) # move them .05 to the left and right
p1 <- ggplot(summary_weight_resids, aes(x= Ratio, y= weight_resids, group= Ratio: Pike)) + 
    geom_errorbar(aes(ymin= weight_resids-se, ymax= weight_resids +se), colour="black", width=.1, position= pd) +
    geom_point(position = pd, size=5, shape=21, fill=c(2,3,2,3,2,3), colour=c(2,3,2,3,2,3), alpha=1) + # 21 is filled circle
scale_x_discrete(limits=c("05_low","10_medium","15_high"), labels=c("5%", "10%", "15%")) +
#geom_point(data= initial_data, aes(x= Ratio, y= x_position_initial), alpha=0.2, position=pd)+
    xlab("Food Treatment") +
    ylab("Residual weight") +
    annotate("text", x=0.6, y=0.2, label="A)", size=4)+
    theme_bw() +
theme(axis.line = element_line(colour = "black"))+
theme(axis.text=element_text(size=10),axis.title=element_text(size=14,face="bold"))+
theme(axis.text.x=element_blank(), axis.title.x=element_blank())+
    theme(panel.grid.major=element_line(color="white"), panel.grid.minor=element_line(color="white"))

quartz()
p1



###############################################################################################################################
### Length
boxplot(analyze.record$Length ~ analyze.record$Pike*analyze.record$Ratio, col=(c("gold","darkgreen")), main="Length")
summary(aov(analyze.record$Length ~ analyze.record$Pike*analyze.record$Ratio))

summary_length <- summarySE(analyze.record, measurevar="Length", groupvars=c("Pike", "Ratio"))
pd <- position_dodge(.2) # move them .05 to the left and right
p2 <- ggplot(summary_length, aes(x= Ratio, y= Length, group= Ratio: Pike)) + 
    geom_errorbar(aes(ymin= Length-se, ymax= Length +se), colour="black", width=.1, position= pd) +
    geom_point(position = pd, size=5, shape=21, fill=c(2,3,2,3,2,3), colour=c(2,3,2,3,2,3), alpha=1) + # 21 is filled circle
scale_x_discrete(limits=c("05_low","10_medium","15_high"), labels=c("5%", "10%", "15%")) +
#geom_point(data= initial_data, aes(x= Ratio, y= x_position_initial), alpha=0.2, position=pd)+
    xlab("Food Treatment") +
    ylab("Length (mm)") +
    annotate("text", x=0.6, y=95.5, label="B)", size=4)+
    theme_bw() +
theme(axis.line = element_line(colour = "black"))+
theme(axis.text=element_text(size=10),axis.title=element_text(size=14,face="bold"))+
    theme(panel.grid.major=element_line(color="white"), panel.grid.minor=element_line(color="white"))

quartz()
p2



## assemble p1 &p2
#Set the margins between the plots
p1 <- p1 + theme(plot.margin=unit(c(2.5,5,0,4.75),"cm"))
p2 <- p2 + theme(plot.margin=unit(c(0,5,2,5),"cm"))

grid.arrange(p1, p2, ncol=1)

###############################################################################################################################
### Centroid size
#boxplot(analyze.record$proc_Csize ~ analyze.record$Pike*analyze.record$Ratio, col=(c("gold","darkgreen")), main="Concensus size")
summary(aov(analyze.record$proc_Csize ~ analyze.record$Pike*analyze.record$Ratio))

summary_proc_Csize <- summarySE(analyze.record, measurevar="proc_Csize", groupvars=c("Pike", "Ratio"))
pd <- position_dodge(.2) # move them .05 to the left and right
p3 <- ggplot(summary_proc_Csize, aes(x= Ratio, y= proc_Csize, group= Ratio: Pike)) + 
    geom_errorbar(aes(ymin= proc_Csize-se, ymax= proc_Csize +se), colour="black", width=.1, position= pd) +
    geom_point(position = pd, size=5, shape=21, fill=c(2,3,2,3,2,3), colour=c(2,3,2,3,2,3), alpha=1) + # 21 is filled circle
scale_x_discrete(limits=c("05_low","10_medium","15_high"), labels=c("5%", "10%", "15%")) +
#geom_point(data= initial_data, aes(x= Ratio, y= x_position_initial), alpha=0.2, position=pd)+
    xlab("Food Treatment") +
    ylab("Centroid size") +
    theme_bw() +
theme(axis.line = element_line(colour = "black"))+
theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+
    theme(panel.grid.major=element_line(color="white"), panel.grid.minor=element_line(color="white"))

quartz()
p3
###############################################################################################################################
### Intestine (residuals)
boxplot(analyze.record$intestine_resids ~ analyze.record$Pike*analyze.record$Ratio, col=(c("gold","darkgreen")), main="Intestine length")
summary(aov(analyze.record$Intestine ~ analyze.record$Pike*analyze.record$Ratio + analyze.record$Length))

summary_intestine_resids <- summarySE(analyze.record, measurevar="intestine_resids", groupvars=c("Pike", "Ratio"))
pd <- position_dodge(.2) # move them .05 to the left and right
p4 <- ggplot(summary_intestine_resids, aes(x= Ratio, y= intestine_resids, group= Ratio: Pike)) + 
    geom_errorbar(aes(ymin= intestine_resids-se, ymax= intestine_resids +se), colour="black", width=.1, position= pd) +
    geom_point(position = pd, size=5, shape=21, fill=c(2,3,2,3,2,3), colour=c(2,3,2,3,2,3), alpha=1) + # 21 is filled circle
scale_x_discrete(limits=c("05_low","10_medium","15_high"), labels=c("5%", "10%", "15%")) +
#geom_point(data= initial_data, aes(x= Ratio, y= x_position_initial), alpha=0.2, position=pd)+
    xlab("Food Treatment") +
    ylab("Intestine residuals") +
    theme_bw() +
theme(axis.line = element_line(colour = "black"))+
theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+
    theme(panel.grid.major=element_line(color="white"), panel.grid.minor=element_line(color="white"))

quartz()
p4


##### mixed model ANOVA (nested) to use the info from each individual
gut_length <-  data.frame(pike=meta$Pike, ratio=meta$Ratio, intestine=meta$Intestine, length=meta$Length,  Aquaria=meta$Aquarium_ID)
gut_length <- na.omit(gut_length)
str(gut_length)
fit <- lme(intestine ~ pike * ratio + length, random= ~ 1 | Aquaria, data= gut_length)
summary(fit)
anova(fit)







































###############
# here I test a normal PCA on Procrustes coordinates after superimposition

z <- prcomp(two.d.array(proc$coords))
predict(z)

plotmeans(predict(z)[,1] ~ meta$treatment_nr)
points(predict(z)[,1] ~ jitter(meta$treatment_nr),2, col=2)

par(mfrow=c(2,6))
boxplot(predict(z)[,1] ~ meta$Pike*meta$Ratio, col=(c("gold","darkgreen")))
boxplot(predict(z)[,2] ~ meta$Pike*meta$Ratio, col=(c("gold","darkgreen")))
boxplot(predict(z)[,3] ~ meta$Pike*meta$Ratio, col=(c("gold","darkgreen")))
boxplot(predict(z)[,4] ~ meta$Pike*meta$Ratio, col=(c("gold","darkgreen")))
boxplot(predict(z)[,5] ~ meta$Pike*meta$Ratio, col=(c("gold","darkgreen")))
boxplot(predict(z)[,6] ~ meta$Pike*meta$Ratio, col=(c("gold","darkgreen")))
interaction.plot(meta$Pike, meta$Ratio, predict(z)[,1])
interaction.plot(meta$Pike, meta$Ratio, predict(z)[,2])
interaction.plot(meta$Pike, meta$Ratio, predict(z)[,3])
interaction.plot(meta$Pike, meta$Ratio, predict(z)[,4])
interaction.plot(meta$Pike, meta$Ratio, predict(z)[,5])
interaction.plot(meta$Pike, meta$Ratio, predict(z)[,6])


model <- aov(predict(z)[,1] ~ meta$Pike * meta$Ratio)
summary(model)
model <- aov(predict(z)[,2] ~ meta$Pike * meta$Ratio)
summary(model)
model <- aov(predict(z)[,3] ~ meta$Pike * meta$Ratio)
summary(model)
model <- aov(predict(z)[,4] ~ meta$Pike * meta$Ratio)
summary(model)
model <- aov(predict(z)[,5] ~ meta$Pike * meta$Ratio)
summary(model)
model <- aov(predict(z)[,6] ~ meta$Pike * meta$Ratio)
summary(model)

### Nested design
model <- aov(predict(z)[,1] ~ meta$Pike * meta$Ratio + meta$Aquarium_ID/meta$number)
summary(model)

# Nested Mancova with cetroid size as covariate
fit <- manova(predict(z) ~ meta$Pike * meta$Ratio * proc$Csize + meta$Aquarium_ID/meta$number)
summary(fit, test="Pillai")
summary.aov(fit, test="Pillai")

fit <- manova(predict(z) ~ meta$Pike * meta$Ratio + proc$Csize + meta$Aquarium_ID/meta$number)
summary(fit, test="Pillai")
summary.aov(fit, test="Pillai")



fit <- manova(predict(z) ~ meta$Pike * meta$Ratio * proc$Csize + Error(meta$Aquarium_ID/meta$number))
summary(fit, test="Pillai")

fit <- lme(predict(z)[,1] ~ meta$Pike * meta$Ratio, random= ~ 1 | meta$Aquarium_ID)
summary(fit)
y1 <- as.numeric(predict(z)[,1])
y2 <- as.numeric(predict(z)[,2])
y3 <- as.numeric(predict(z)[,3])
str(y)
str(meta)
pike <- data.frame(pike=meta$Pike, ratio=meta$Ratio, y1=y1,y2=y2, y3=y3,  Aquaria=meta$Aquarium_ID)
str(pike)
pike$Aquaria <- as.factor(pike$Aquaria)

fit <- lme(y1 ~ Pike * ratio, random= ~ 1 | Aquaria, data=pike)
summary(fit)
anova(fit)








fit <- manova(predict(z) ~ meta$Pike * meta$Ratio * proc$Csize + meta$number%in%meta$Aquarium_ID)
summary(fit, test="Pillai")

fit <- manova(predict(z) ~ meta$Pike * meta$Ratio + proc$Csize + meta$number%in%meta$Aquarium_ID)
summary(fit, test="Pillai")




plot(predict(z)[,1] ~ proc$Csize, col=as.numeric(meta$Ratio), pch=as.numeric(meta$Pike)+15, cex=as.numeric(meta$Ratio), ylab="PC1", xlab="Size")

plot(predict(z)[,2] ~ predict(z)[,1] , col=as.numeric(meta$Ratio), pch=as.numeric(meta$Pike)+15, cex=as.numeric(meta$Ratio), ylab="PC2", xlab="PC1")  # OK it is the same stuff!!! NICE!!!!

boxplot(predict(z)[,1] ~ meta$Pike)
boxplot(predict(z)[,1] ~ meta$Ratio)
boxplot(predict(z)[,2] ~ meta$Pike)
boxplot(predict(z)[,2] ~ meta$Ratio)
boxplot(predict(z)[,3] ~ meta$Pike)
boxplot(predict(z)[,3] ~ meta$Ratio)
boxplot(predict(z)[,4] ~ meta$Pike)
boxplot(predict(z)[,4] ~ meta$Ratio)
boxplot(predict(z)[,5] ~ meta$Pike)
boxplot(predict(z)[,5] ~ meta$Ratio)
boxplot(predict(z)[,6] ~ meta$Pike)
boxplot(predict(z)[,6] ~ meta$Ratio)

















