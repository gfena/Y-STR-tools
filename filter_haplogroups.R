setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project/")

### Load Libraries
library(ggplot2)
library(tidyr)
library(dplyr)

#### Find unique haplotypes

# Read the CSV file into R
data <- read.csv("j2a1b_tofilter+hg.txt", header = TRUE, sep = "\t")
data <- read.csv("spanishroma_allHG.txt", header = TRUE, sep = "\t")

### Haplotype frequency

### IF only ID, POP and STR
# Combine the values of all microsatellites for each individual
data$Haplotype <- apply(data[, -c(1, 2)], 1, paste, collapse = "-")

# Count the number of unique haplotypes
unique_haplotypes <- unique(data$Haplotype)
num_unique_haplotypes <- length(unique_haplotypes)

# Count the frequency of each unique haplotype
haplotype_frequency <- as.data.frame(table(data$Haplotype))

### IF all information, then
# Combine the values of all microsatellites for each individual
data$Haplotype <- apply(data[, -c(1, 2, 3, 4, 5, 6)], 1, paste, collapse = "-")

# Group by Population and Haplotype, and select the first individual within each group
individuals_per_haplotype <- data %>%
  group_by(Population, Haplotype) %>%
  slice(1) %>%
  ungroup()

individuals_per_haplotype <- individuals_per_haplotype %>% select(-DYS385a, -DYS385b, -DYS389I, -DYS389II)

# Save the dataframe as a CSV file
write.table(individuals_per_haplotype, "j2a1b_individuals_per_haplotype.txt", row.names = FALSE, sep = "\t", quote = FALSE)

### Calculate Variance and Weights

# Calculate variance for each column from 7 to 19
variance_values <- sapply(individuals_per_haplotype[, 7:19], var)

# Calculate the inverse of each variance value
inverse_variance <- 1 / variance_values

# Find the maximum of the inverse variance values
max_inverse_variance <- max(inverse_variance)

# Calculate the weights
raw_weights <- inverse_variance * (10 / max_inverse_variance)

# Scale the weights to ensure they fall within the range of 1 to 10
scaled_weights <- pmin(pmax(raw_weights, 1), 10)

# Create a data frame for weights with a single row
weights_df <- data.frame(t(scaled_weights))

# min max normalization
#min_weight <- min(raw_weights)
#max_weight <- max(raw_weights)
#scaled_weights <- (raw_weights - min_weight) / (max_weight - min_weight) * 9 + 1

# Scale on Log and account for min-max values 
log_weights <- log(raw_weights)
min_log_weight <- min(log_weights)
max_log_weight <- max(log_weights)
scaled_log_weights <- (log_weights - min_log_weight) / (max_log_weight - min_log_weight) * 9 + 1
weights_df <- data.frame(t(scaled_log_weights))

# Print the variance and the weights
variance_values

write.csv(weights_df, "j2a1b_weights.txt", row.names = FALSE)

