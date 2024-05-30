

setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project")

# Load the tidyverse package
library(tidyr)
library(dplyr)

df <- read.csv(file = "Fulldataset.csv", sep = "\t")

# Perform the transformation
df <- df %>%
  mutate(DYS389II = if_else(DYS389II >= 25 & DYS389II <= 35, DYS389II - DYS389I, DYS389II))

# Replace 0 values with 99
df[df == 0] <- 99

write.csv(df,file = "Fulldataset_fixed.csv")
