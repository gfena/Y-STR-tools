
setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project")

### Calculate Variance and Weights

variance_values <- c(0.318389568490388,0.59477080252722,0.728323699421967,0.272079580588788,0.383431952662723,1.39857507729534,1.0515526280414,0.219585965855626,0.512770533673882,0.901666890711117,0.298964914639064,1.97123269256621,1.33586503562307)

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

# Scale on Log and account for min-max values 
log_weights <- log(raw_weights)
min_log_weight <- min(log_weights)
max_log_weight <- max(log_weights)
scaled_log_weights <- (log_weights - min_log_weight) / (max_log_weight - min_log_weight) * 9 + 1
weights_df <- data.frame(t(scaled_log_weights))

# Print the scaled weights
write.csv(weights_df,"SProma_logscaledweights.csv", row.names = FALSE, quote = FALSE)
