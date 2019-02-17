# Type II and III ANOVA for lm
# wrapper to Anova

con3 <- list(Temp=contr.sum, CO2=contr.sum) # change the contrasts coding for the model matrix
urchin.t3 <- lm(Resp ~ Temp*CO2, data=urchin_unbalanced, contrasts=con3)
Anova(urchin.t3, type="3")

type2 <- function(fit){
  # fit is the object returned by lm()
  
}