
setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project/Results")

library(ggplot2)
library(reshape2)

### PLOT FST

# Assuming df is your genetic distance matrix
# Make sure df has row and column names representing species

df <- read.table(file = "fst_spain_nei.txt", header = TRUE, sep = "\t", row.names = 1, fill = TRUE)

# Melt the data frame for ggplot2
df_melt <- melt(as.matrix(df))

# Create the heatmap
ggplot(df_melt, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(value, 2)), color = "black") +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "FST Heatmap", x = "", y = "") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

### PLOT pairwise distances

df <- read.table(file = "pixy_spain.txt", header = TRUE, sep = "\t", row.names = 1, fill = TRUE)

# Replace this with your actual data reading code
df_matrix <- as.matrix(df)

# Get the dimensions of the matrix
n <- nrow(df_matrix)

# Prepare data frames for different parts of the matrix
upper_matrix <- matrix(NA, n, n)
lower_matrix <- matrix(NA, n, n)
diag_matrix <- matrix(NA, n, n)

for (i in 1:n) {
  for (j in 1:n) {
    if (i < j) {
      upper_matrix[i, j] <- df_matrix[i, j]
    } else if (i > j) {
      lower_matrix[i, j] <- df_matrix[i, j]
    } else {
      diag_matrix[i, j] <- df_matrix[i, j]
    }
  }
}

# Melt the matrices for ggplot2
upper_melt <- melt(upper_matrix, na.rm = TRUE)
lower_melt <- melt(lower_matrix, na.rm = TRUE)
diag_melt <- melt(diag_matrix, na.rm = TRUE)

# Assign a type to each part
upper_melt$type <- "Between"
lower_melt$type <- "Corrected"
diag_melt$type <- "Within"

# Combine all parts into one data frame
combined_melt <- rbind(upper_melt, lower_melt, diag_melt)

# Create custom color ramps
colorRampBlue <- colorRampPalette(c("white", "steelblue1", "blue3"))
colorRampGreen <- colorRampPalette(c("white", "green3", "darkgreen"))
colorRampOrange <- colorRampPalette(c("white", "orange", "orangered2"))

# Map colors based on type
combined_melt <- combined_melt %>% mutate(color=case_when(type=="Between"~colorRampGreen(100),
                                   type=="Corrected"~colorRampBlue(100),
                                   type=="Within"~colorRampOrange(100)))

df <- read.csv(file = "combined_melt.csv")

# Create the heatmap
ggplot(df, aes(Pop1, Pop2, fill = color)) +
  geom_tile(color = "white")+
  geom_text(aes(label = round(value, 2)), color = "black")+ # Add labels
  scale_fill_identity() + # Use identity scale to use custom colors
  theme_minimal()+
  scale_x_continuous(breaks = c(1:10),labels = c("CentralSpain","EasternSpain","WesternSpain","SouthernSpain",
                                                 "NorthernSpain","RomaEasternSpain","RomaCentralSpain","RomaWesternSpain",
                                                 "RomaSouthernSpain","RomaNorthernSpain"))+
  scale_y_continuous(breaks = c(1:10),labels = c("CentralSpain","EasternSpain","WesternSpain","SouthernSpain",
                                                 "NorthernSpain","RomaEasternSpain","RomaCentralSpain","RomaWesternSpain",
                                                 "RomaSouthernSpain","RomaNorthernSpain"))+
  labs(title = "Average number of pairwise differences", x = "", y = "")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

