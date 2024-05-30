
setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project")


################################################### Spanish Roma
#### Find unique haplotypes

# Read the CSV file into R
data <- read.csv("full_data_toreplaceNA.csv", header = TRUE, sep = "\t")

# Replace 0 values with 99
data[data == 0] <- 99

write.csv(data,file = "full_data_notamil_replaced.csv")
