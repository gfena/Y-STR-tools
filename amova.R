
setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project")

library(adegenet)
library(poppr)

df <- read.genetix("input_ibsroma_amova.gtx")

dfibs <- read.genetix("input_ibs_amova.gtx")

popdata <- poppr(df)

popdataibs <- poppr(dfibs)

# Set the strata attribute to set the hierarchy of the subgroups I want to test

strata(df) <- data.frame(pop=pop(df))

strata(dfibs) <- data.frame(pop=pop(dfibs))

## Run amova

romaamova<-poppr.amova(df, ~pop, within = FALSE)

romaamovawithin<-poppr.amova(df, ~pop, within = TRUE)

sink(file = "Roma.amovaOutput.txt")
romaamova
romaamovawithin
sink(file = NULL)

### 2nd test

ibsamova<-poppr.amova(dfibs, ~pop, within = FALSE)

ibsamovawithin<-poppr.amova(dfibs, ~pop, within = TRUE)

sink(file = "IBS.amovaOutput.txt")
ibsamova
ibsamovawithin
sink(file = NULL)

### 3rd test

Romaibsamova<-poppr.amova(Romaibs_genind, ~pop, within = FALSE)
Romaibsamovawithin<-poppr.amova(Romaibs_genind, ~pop, within = TRUE)

sink(file = "Romaibs.amovaOutput.txt")
Romaibsamova
Romaibsamovawithin
sink(file = NULL)

### Significance testing

signif1<-randtest(romaamova, nrepet = 9999)
signif2<-randtest(romaamovawithin, nrepet = 9999)
signif3<-randtest(ibsamova, nrepet = 9999)
signif4<-randtest(ibsamovawithin, nrepet = 9999)
signif5<-randtest(Romaibsamova, nrepet = 9999)
signif6<-randtest(Romaibsamovawithin, nrepet = 9999)

plot(signif2)

sink(file = "randomisationTest.amova.txt")
signif1
signif2
signif3
signif4
signif5
signif6
sink(file = NULL)

### End