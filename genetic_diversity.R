
setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project")

library(ggplot2)
library(tidyr)
library(dplyr)

################################################### Spanish Roma
#### Find unique haplotypes

# Read the CSV file into R
data <- read.csv("SpanishRoma.csv", header = TRUE, sep = ",")

# Replace 0 values with NA
data[data == 0] <- NA

# Replace 0 values with 99
data[data == 0] <- 99

### Average Hexp (expected heterozygosity)

# Calculate the gene diversity for each locus
microsatellites <- data[, 3:ncol(data)]

# Calculate the gene diversity for each locus
gene_diversity <- apply(microsatellites, 2, function(locus) {
  unique_alleles <- unique(locus)
  p <- table(locus) / length(locus)
  1 - sum(p^2)
})

# Create a data frame with locus names and gene diversity values
gene_diversity_df <- data.frame(Locus = colnames(microsatellites), Gene_Diversity = gene_diversity) 

# Plot gene diversity by locus using ggplot2
ggplot(gene_diversity_df, aes(x = Locus, y = Gene_Diversity)) +
  geom_bar(stat = "identity", fill = "skyblue", width = 0.7) +
  labs(title = "",
       x = "",
       y = "Hexp") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#### Allele Frequency

# Exclude the Population and ID columns
dataid <- data %>% select(-Population, -ID)

# Reshape the data to long format
data_long <- dataid %>%
  pivot_longer(cols = 1:ncol(dataid), names_to = "Locus", values_to = "Allele")

# Calculate allele frequency by locus, excluding NA values
allele_frequency <- data_long %>%
  drop_na(Allele) %>%
  group_by(Locus, Allele) %>%
  summarise(Frequency = n() / nrow(data))

# Plot allele frequency by locus
ggplot(allele_frequency, aes(x = Allele, y = Frequency, fill = Locus)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_x_continuous(limits = c(0, 35), breaks = seq(0, 35, by = 5))+
  facet_wrap(~ Locus)+
  labs(y = "")+theme(legend.position = "none")+
  scale_fill_manual(values = rep("skyblue", n_distinct(allele_frequency$Locus))) +  # Set bar colors
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

##################### By Population

# Reshape the data to long format
data_long <- data %>%
  pivot_longer(cols = 3:ncol(data), names_to = "Locus", values_to = "Allele")

# Calculate allele frequency by locus and population
allele_frequency <- data_long %>%
  group_by(Population, Locus, Allele) %>%
  summarise(Frequency = n() / nrow(data))

# Plot allele frequency by locus and population
ggplot(allele_frequency, aes(x = Allele, y = Frequency, fill = Population)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ Locus, scales = "free_x") +
  labs(y = "")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        strip.text.x = element_text(size = 8, angle = 45, hjust = 1))

### Haplotype frequency

# Combine the values of all microsatellites for each individual
data$Haplotype <- apply(data[, -c(1, 2)], 1, paste, collapse = "-")

# Count the number of unique haplotypes
unique_haplotypes <- unique(data$Haplotype)
num_unique_haplotypes <- length(unique_haplotypes)

# Count the frequency of each unique haplotype
haplotype_frequency <- as.data.frame(table(data$Haplotype))

#### Haplotype Diversity

# Calculate haplotype diversity
pi <- table(data$Haplotype) / nrow(data)
pi2 <- pi^2
sum_pi2 <- sum(pi2)
HD <- nrow(data) * (1 - sum_pi2) / (nrow(data) - 1)
HD

#### HD By Population

# Calculate haplotype diversity for each population
populations <- unique(data$Population)
haplotype_diversity <- numeric(length(populations))

for (i in 1:length(populations)) {
  subset_data <- subset(data, Population == populations[i])
  pi <- table(subset_data$Haplotype) / nrow(subset_data)
  pi2 <- pi^2
  sum_pi2 <- sum(pi2)
  haplotype_diversity[i] <- nrow(subset_data) * (1 - sum_pi2) / (nrow(subset_data) - 1)
}

# Create a data frame with population and haplotype diversity
haplotype_diversity_df <- data.frame(Population = populations, Haplotype_Diversity = haplotype_diversity)

# Print the result
print(haplotype_diversity_df)

################################################### 
################################################### Spanish non-Roma
################################################### 

#### Find unique haplotypes

# Read the CSV file into R
data <- read.csv("spanishnonroma.csv", header = TRUE, sep = "\t")

# Replace 0 values with NA
data[data == 0] <- NA

### Average Hexp (expected heterozygosity)

# Calculate the gene diversity for each locus
microsatellites <- data[, 3:ncol(data)]

# Calculate the gene diversity for each locus
gene_diversity <- apply(microsatellites, 2, function(locus) {
  unique_alleles <- unique(locus)
  p <- table(locus) / length(locus)
  1 - sum(p^2)
})

# Create a data frame with locus names and gene diversity values
gene_diversity_df <- data.frame(Locus = colnames(microsatellites), Gene_Diversity = gene_diversity) 

# Plot gene diversity by locus using ggplot2
ggplot(gene_diversity_df, aes(x = Locus, y = Gene_Diversity)) +
  geom_bar(stat = "identity", fill = "skyblue", width = 0.7) +
  labs(title = "",
       x = "",
       y = "Hexp") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#### Allele Frequency

# Exclude the Population and ID columns
dataid <- data %>% select(-Population, -ID)

# Reshape the data to long format
data_long <- dataid %>%
  pivot_longer(cols = 1:ncol(dataid), names_to = "Locus", values_to = "Allele")

# Calculate allele frequency by locus, excluding NA values
allele_frequency <- data_long %>%
  drop_na(Allele) %>%
  group_by(Locus, Allele) %>%
  summarise(Frequency = n() / nrow(data))

# Plot allele frequency by locus
ggplot(allele_frequency, aes(x = Allele, y = Frequency, fill = Locus)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.8) +
  scale_x_continuous(limits = c(0, 35), breaks = seq(0, 35, by = 5))+
  facet_wrap(~Locus)+
  labs(y = "")+theme(legend.position = "none")+
  scale_fill_manual(values = rep("skyblue", n_distinct(allele_frequency$Locus))) +  # Set bar colors
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

##################### By Population

# Reshape the data to long format
data_long <- data %>%
  pivot_longer(cols = 3:ncol(data), names_to = "Locus", values_to = "Allele")

# Calculate allele frequency by locus and population
allele_frequency <- data_long %>%
  group_by(Population, Locus, Allele) %>%
  summarise(Frequency = n() / nrow(data))

# Plot allele frequency by locus and population
ggplot(allele_frequency, aes(x = Allele, y = Frequency, fill = Population)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.9) +
  facet_wrap(~ Locus, scales = "free_x") +
  labs(y = "")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        strip.text.x = element_text(size = 8, angle = 45, hjust = 1))

### Haplotype frequency

# Combine the values of all microsatellites for each individual
data$Haplotype <- apply(data[, -c(1, 2)], 1, paste, collapse = "-")

# Count the number of unique haplotypes
unique_haplotypes <- unique(data$Haplotype)
num_unique_haplotypes <- length(unique_haplotypes)

# Count the frequency of each unique haplotype
haplotype_frequency <- as.data.frame(table(data$Haplotype))

#### Haplotype Diversity

# Calculate haplotype diversity
pi <- table(data$Haplotype) / nrow(data)
pi2 <- pi^2
sum_pi2 <- sum(pi2)
HD <- nrow(data) * (1 - sum_pi2) / (nrow(data) - 1)
HD

#### HD By Population

# Calculate haplotype diversity for each population
populations <- unique(data$Population)
haplotype_diversity <- numeric(length(populations))

for (i in 1:length(populations)) {
  subset_data <- subset(data, Population == populations[i])
  pi <- table(subset_data$Haplotype) / nrow(subset_data)
  pi2 <- pi^2
  sum_pi2 <- sum(pi2)
  haplotype_diversity[i] <- nrow(subset_data) * (1 - sum_pi2) / (nrow(subset_data) - 1)
}

# Create a data frame with population and haplotype diversity
haplotype_diversity_df <- data.frame(Population = populations, Haplotype_Diversity = haplotype_diversity)

# Print the result
print(haplotype_diversity_df)

### Run STRAF

#install.packages("remotes")
#remotes::install_github("agouy/straf")

library(shiny)

runGitHub("straf", "agouy")
