
setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project")

library(ggplot2)
library(tidyr)
library(dplyr)

#### Find unique haplotypes

# Read the CSV file into R
data <- read.csv("Fulldataset_ready.csv", header = TRUE, sep = "\t")

# Combine the values of all microsatellites for each individual
data$Haplotype <- apply(data[, -c(1, 2, 3, 4, 5, 6)], 1, paste, collapse = "-")

#write.csv(data,file = "haplotype_data.csv")

# Haplotype frequency
haplotype_counts <- data %>%
  group_by(Population, HG, Haplotype) %>%
  summarise(Frequency = n()) %>%
  ungroup()

# Calculate the total count of haplotypes within each population and haplogroup
total_counts <- haplotype_counts %>%
  group_by(Population, HG) %>%
  summarise(Total = sum(Frequency))

# Merge the total counts with the haplotype counts
haplotype_freq <- haplotype_counts %>%
  left_join(total_counts, by = c("Population", "HG")) %>%
  mutate(Haplotype_Frequency = Frequency / Total) %>%
  select(-Total)
