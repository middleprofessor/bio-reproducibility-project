#################################################################################
## Script used in 
## Christopher Bosc, Anton Pauw, Francois Roets and Cang Hui. 
## 2018. Interactions among predators and plant specificity protect 
## herbivores from top predators. Ecology. 
#################################################################################

## Load tables (available in Dryad)
  ## Arthropod (herbivore + intermediate predator) species abundances per quadrat
ArthroAb <-read.csv("ArthropodAbundances_BirdExpe_Dec2014.csv",header=T, row.names=1, dec = ",")
  ## Plant species covers (m2) per quadrat
PlantCov <- read.csv("PlantCovers_m2_BirdExpe_Dec2014.csv",header=T, row.names=1, dec = ".") 
  ## Treatment-Site-Slope/quadrat
Envir <- read.csv("ExpeDesign_BirdExpe_Dec2014.csv",header=T, row.names=1, dec = ".")
  ## Arthropod information (including trophic group)
ArthroInfo <- read.csv("ArthropodTrophicGroup_BirdExpe_Dec2014.csv",header=T, row.names=1, dec = ".")
  ## Arthropod taxonomy
ArthroTaxo <- read.csv("ArthropodTaxonomy_BirdExpe_Dec2014.csv",header=T, row.names=1, dec = ".")





###############################################################################
## Effects of birds on total abundance of arthropods 
###############################################################################

library(lme4)
library(lmerTest)

## Intermediate predator species abundances per quadrat
PredAb <- ArthroAb[,ArthroInfo$TrophicGrp=="Pred"]
## Herbivore species abundances per quadrat
HerbAb <- ArthroAb[,ArthroInfo$TrophicGrp=="Herb"]

## Intermediate predator taxonomy
ArthroTaxoPred <- ArthroTaxo[ArthroInfo$TrophicGrp=="Pred", ]
## Herbivore taxonomy
ArthroTaxoHerb <- ArthroTaxo[ArthroInfo$TrophicGrp=="Herb", ]

## Araneae species abundances per quadrat
PredAbAraneae <- PredAb[,ArthroTaxoPred$Order=="Araneae"]
## Predatory insect species abundances per quadrat
PredAbPredInsect <- PredAb[,ArthroTaxoPred$Class=="Insecta"]

## Hemiptera species abundances per quadrat
HerbAbHemi <- HerbAb[,ArthroTaxoHerb$Order=="Hemiptera"] 
## Coleoptera species abundances per quadrat
HerbAbColeo <- HerbAb[,ArthroTaxoHerb$Order=="Coleoptera"] 
## Lepidoptera species abundances per quadrat
HerbAbLepido <- HerbAb[,ArthroTaxoHerb$Order=="Lepidoptera"] 
## Orthoptera species abundances per quadrat
HerbAbOrtho <- HerbAb[,ArthroTaxoHerb$Order=="Orthoptera"] 

## Vectors with total abundances per quadrat
PredAbun <- sapply(as.data.frame(t(PredAb)),sum)        # All intermediate predators
PredAbunAraneae <-sapply(as.data.frame(t(PredAbAraneae)),sum)    # Araneae
PredAbunPredInsect <-sapply(as.data.frame(t(PredAbPredInsect)),sum)   # Predatory insects

HerbAbun <- sapply(as.data.frame(t(HerbAb)),sum)        # All herbivores
HerbAbunHemi <- sapply(as.data.frame(t(HerbAbHemi)),sum)       # Hemiptera
HerbAbunColeo <- sapply(as.data.frame(t(HerbAbColeo)),sum)      # Coleoptera
HerbAbunLepido <- sapply(as.data.frame(t(HerbAbLepido)),sum)     # Lepidoptera
HerbAbunOrtho <- sapply(as.data.frame(t(HerbAbOrtho)),sum)      # Orthoptera


## Linear mixed models (LMMs) on arthropod total abundances 
## with treatment as fixed effect and site as random factor
Model1 = lmer(PredAbun ~ Treatment  + (1|Site), data=Envir)     # Intermediate predators
Model2 = lmer(HerbAbun ~ Treatment  + (1|Site), data=Envir)     # Herbivores

Model3 = lmer(PredAbunAraneae ~ Treatment  + (1|Site), data=Envir)      # Araneae 
Model4 = lmer(PredAbunPredInsect ~ Treatment  + (1|Site), data=Envir)     # Predarory insects
Model5 = lmer(HerbAbunHemi ~ Treatment  + (1|Site), data=Envir)           # Hemiptera 
Model6 = lmer(HerbAbunColeo ~ Treatment  + (1|Site), data=Envir)          # Coleoptera
Model7 = lmer(HerbAbunLepido ~ Treatment  + (1|Site), data=Envir)         # Lepidoptera
Model8 = lmer(HerbAbunOrtho ~ Treatment  + (1|Site), data=Envir)          # Orthoptera

## Summaries of LMMs: return comparisons cage/open and cage/shade
summary(Model1)      # Intermediate predators
summary(Model2)      # Herbivores
summary(Model3)      # Araneae
summary(Model4)      # Predarory insects
summary(Model5)      # Hemiptera 
summary(Model6)      # Coleoptera
summary(Model7)      # Lepidoptera
summary(Model8)      # Orthoptera


## Put levels in different order to obtain the comparisons 
## open/cage and open/shade
Envir1 <- within(Envir, 
                 Treatment <- factor(Treatment, 
                                     levels=c( "Open","Cage","Shade")))

## Linear mixed models (LMMs) on arthropod total abundances 
## with treatment as fixed effect and site as random factor
Model1b = lmer(PredAbun ~ Treatment  + (1|Site), data=Envir1)     # Intermediate predators
Model2b = lmer(HerbAbun ~ Treatment  + (1|Site), data=Envir1)     # Herbivores

Model3b = lmer(PredAbunAraneae ~ Treatment  + (1|Site), data=Envir1)      # Araneae 
Model4b = lmer(PredAbunPredInsect ~ Treatment  + (1|Site), data=Envir1)     # Predarory insects
Model5b = lmer(HerbAbunHemi ~ Treatment  + (1|Site), data=Envir1)           # Hemiptera 
Model6b = lmer(HerbAbunColeo ~ Treatment  + (1|Site), data=Envir1)          # Coleoptera
Model7b = lmer(HerbAbunLepido ~ Treatment  + (1|Site), data=Envir1)         # Lepidoptera
Model8b = lmer(HerbAbunOrtho ~ Treatment  + (1|Site), data=Envir1)          # Orthoptera

## Summaries of LMMs: return comparisons open/cage and open/shade
summary(Model1b)      # Intermediate predators
summary(Model2b)      # Herbivores
summary(Model3b)      # Araneae
summary(Model4b)      # Predarory insects
summary(Model5b)      # Hemiptera 
summary(Model6b)      # Coleoptera
summary(Model7b)      # Lepidoptera
summary(Model8b)      # Orthoptera



###############################################################################
## Effects of birds on arthropod species composition 
###############################################################################

library(vegan)

## Sqrt and Hellinger transformation of species abundances or covers per quadrat
ArthroLog <- decostand(sqrt(ArthroAb), method = "hellinger", MARGIN = 1)  # Arthropods
PlantLog <- decostand(sqrt(PlantCov), method = "hellinger", MARGIN = 1)   # Plants

## Orthogonalisation of plant variables = partial principal component analysis (pPCA)
## with site as condition
plant <- rda(PlantLog ~ Condition(Site),Envir, scale=F)

## Selection of plant variables (principal components) to use in pRDA
    ## 1/ Model building:
      ## Full model: partial redundancy analysis (pRDA) on arthropods 
      ##             with all plant variables as predictors
      ##             and treatment and site as conditions
fmla <- as.formula(paste("ArthroLog ~ ", 
                         paste(colnames(plant$CA$u), 
                               collapse= "+"), "+
                         Condition(Treatment) + 
                         Condition(Site)"))
EnvPlant <- cbind(Envir, plant$CA$u)
Arthrocca1 <- rda(fmla, EnvPlant, scale=T)  # Full model

      ## Unconstrained model: pRDA on arthropods with no predictor
      ##                      and treatment and site as conditions
Arthrocca0 <- rda(ArthroLog ~ Condition(Treatment) + 
                    Condition(Site), EnvPlant, scale=T) 

      ## Permutational block structure
perm = how(nperm=499, blocks=interaction(EnvPlant$Site, EnvPlant$Treatment))

    ## 2/ Run forward selection using adjusted R-squared 
modSel <- ordiR2step(Arthrocca0, 
                    scope = formula(Arthrocca1),
                    direction = c("forward"), Pin = 0.05,
                    pstep = 200, permutations = perm, R2scope = F)
modSel$anova
xnam <- rownames(modSel$CCA$biplot)  # Names of selected plant variables


## pRDA on arthropods with treatment as predictor and
## plants (selected variables) and sites as conditions
## = bird effect on arthropod species composition
fmla <- as.formula(paste("ArthroLog ~ Treatment + Condition(", 
                         paste(xnam, collapse= ") + Condition("),
                         ") +  Condition(Site)"))
EnvPlant <- cbind(Envir, plant$CA$u)
Arthrocca <- rda(fmla , EnvPlant, scale=T)
RsquareAdj(Arthrocca)

  # Permutation test by axis
perm = how(nperm=999, blocks=EnvPlant$Site)
anovaCCA <- anova(Arthrocca, by = "axis", permutations=perm)

## Calculation of B-scores = bird effect on each arthropod species
vectorS <- c(Arthrocca$CCA$centroids[1,1], Arthrocca$CCA$centroids[1,2]) # Bird axis coordinates
Bscores <- c()             
for (i in 1:nrow(Arthrocca$CCA$v)){
    # pRDA scores of arthropod species i
  vectorV <- c(Arthrocca$CCA$v[i,1], Arthrocca$CCA$v[i,2])   
    # Projection of pRDA scores of arthropod species i on bird axis
  projV   <- as.numeric(((vectorV %*% vectorS)/(vectorS %*% vectorS)))*vectorS
    # absolute B-score of arthropod species i
  absBscore <- (sqrt(projV[1]^2 + projV[2]^2)) 
    # Attribute sign to absolute B-score of arthropod species i
  if (sum(projV) > 0){     
    Bscores <- c(Bscores, absBscore)
  } else {
    Bscores <- c(Bscores, -absBscore)
  }
}
names(Bscores) <- rownames(ArthroInfo)


## negatively/neutrally affected limit
l3 <- quantile(Bscores[Bscores<0], probs = 0.75)
## positively/neutrally affected limit
l4 <- quantile(Bscores[Bscores>=0], probs = 0.25)

HerbBscores <- Bscores[ArthroInfo$TrophicGrp=="Herb"]  # B-scores of herbivores
PredBscores <- Bscores[ArthroInfo$TrophicGrp=="Pred"]  # B-scores of intermediate predators

## B-scores of negatively/neutrally/positively affected species
    # Herbivores
HerbBscoresPos <- HerbBscores[HerbBscores>=l4]       # Positively affected
HerbBscoresNeu <- HerbBscores[HerbBscores>l3 & HerbBscores<l4]  # Neutrally affected
HerbBscoresNeg <- HerbBscores[HerbBscores<=l3]       # Negatively affected
    # Intermediate predators
PredBscoresPos <- PredBscores[PredBscores>=l4]       # Positively affected
PredBscoresNeu <- PredBscores[PredBscores>l3 & PredBscores<l4]  # Neutrally affected
PredBscoresNeg <- PredBscores[PredBscores<=l3]       # Negatively affected




#######################################################################
## Estimation of plant specificity 
#######################################################################


## pRDA on arthropods with plants (selected variables) as predictors and
## treatment and sites as conditions
fmla <- as.formula(paste("ArthroLog ~ ", paste(xnam, collapse= "+"), "+
                         Condition(Treatment) + 
                         Condition(Site)"))
EnvPlant <- cbind(Envir, plant$CA$u)
Arthrocca2 <- rda(fmla , EnvPlant, scale = T) ## pRDA
RsquareAdj(Arthrocca2)

  # Permutation test by axis
perm = how(nperm=999, blocks=interaction(EnvPlant$Site, EnvPlant$Treatment))
anovaCCA <- anova(Arthrocca2, by = "axis", permutations=perm)

## Calculation of P-scores = plant specificity of each arthropod species
nbaxes <- c(1:6)   # 6 constrained axes of the pRDA are interpreted
tab <- as.data.frame(t(abs(Arthrocca2$CCA$v[,nbaxes])))
Pscores <- c()
for (i in 1:ncol(tab)){
  Pscores <- c(Pscores,
                  # P-score of arthropod species i
                  sqrt(eval(parse("(",
                                  text=(paste(paste(tab[,i]
                                                    ,collapse="^2 +"), "^2"))))))
}
names(Pscores) <- rownames(Arthrocca2$CCA$v)

HerbPscores <- Pscores[ArthroInfo$TrophicGrp=="Herb"]  # P-scores of herbivores
PredPscores <- Pscores[ArthroInfo$TrophicGrp=="Pred"]  # P-scores of intermediate predators


## Differences in P-scores between the herbivore species 
## negatively, neutrally and positively affected by birds

HerbPscoresNeg <- HerbPscores[names(HerbBscoresNeg)]    # P-scores of herbivore species with negative B-scores
HerbPscoresNeu <- HerbPscores[names(HerbBscoresNeu)]    # P-scores of herbivore species with neutral B-scores
HerbPscoresPos <- HerbPscores[names(HerbBscoresPos)]    # P-scores of herbivore species with positive B-scores

    # Vector with P-scores
PscoresVec <- c(HerbPscoresNeg, 
             HerbPscoresNeu, 
             HerbPscoresPos
)
    # Factor with three levels: -, 0 and + = negative, neutral and positive B-scores
BscoresFac <- factor(c(rep("-", length(HerbPscoresNeg)), 
                    rep("0", length(HerbPscoresNeu)), 
                    rep("+", length(HerbPscoresPos)))
)

    # Taxonomy of herbivores
ArthroTaxoHerb <- ArthroTaxo[ArthroInfo$TrophicGrp=="Herb", ]

    # Linear mixed model (LMM) on herbivore P-scores 
    # with B-scores categories as fixed effect and 
    # order and family within order as random factors (phylogenetic structure)
Model = lmer(PscoresVec ~ BscoresFac  + (1|Order/Family), data=ArthroTaxoHerb)

    # Summary of LMM: return comparisons negative/positive and negative/neutral Bscores
summary(Model)

    # Put levels in different order to obtain the comparisons 
    # positive/negative and positive/neutral 
BscoresFac1 <- factor(BscoresFac, levels=c( "+","-","0"))
levels(BscoresFac1)

Modelb = lmer(PscoresVec ~ BscoresFac1  + (1|Order/Family), data=ArthroTaxoHerb)
    # Summary of LMM: return comparisons positive/negative and positive/neutral Bscores
summary(Modelb)



