
library(ggplot2)
library(factoextra)

setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project")
df <- read.csv("full_data_PCA.csv", sep = ",")
popdf <- read.csv("full_dataset.csv", sep = ",") 
### PCA

# Run PCA
pca1 <- prcomp(df, scale = TRUE)

# Extract results
scores <- pca1$x
loadings <- pca1$rotation
variances <- pca1$sdev^2

fviz_eig(pca1)

pc_df <- as.data.frame(pca1$x[, 1:4])  # Extract the first 4 PCs

#pc_df[,3] <- row.names(pc_df)

eigen.pop <- cbind (pc_df,popdf)

eigen.pop <- eigen.pop[,-7]

### plot

colnames(eigen.pop) <- c("PC1","PC2","PC3","PC4","Individual","Population")

# Calculate percentages of variation explained
variance_explained <- pca1$sdev^2
total_variance <- sum(variance_explained)
percent_explained <- (variance_explained / total_variance) * 100

### Compute mean PC values by population

eigen.pop$Population <- factor(eigen.pop$Population, levels = c(
  
  
  "AfghanPathan", "Armenian", "Azhara", "Balochistan", "Basque", "Bengali", 
  "BettaKurumba","BosniaHerzegovina_Roma","BrahacharanamBrahmin", "Bulgaria_Generalpopulation",
  "Bulgaria_Roma", "CapeNadar", "CentralSpain",
                                                                "EasternSpain", "Ezhava", "German", "Greece_Generalpopulation", "Greece_Roma", "HimachalPradesh", 
                                                                "Hungary_Generalpopulation", "Hungary_Roma", "IndiaLeh", "IndiaMadras", "IndiaSoligas", "Iranian", 
                                                                "Iraq", "Irula", "IyengarBrahmin", "Kadar", "Kanikaran", "Kashmiri", "Kattunaickan", "KhandayatOdisha", 
                                                                "Kota", "Kurumba", "Lingayat", "MadyaPradesh", "Maravar", "Mukkuvar", "Mullukurumba", "NadarTNV",
                                                                "NorthernPortugal", "NorthernSpain", "NorthMacedoniaAlbanian", 
                                                          "NorthMacedoniaMacedonian", "NorthMacedoniaTurk", "Paliyan", "Pallar", "Paniya", "Paravar", "Parayar", 
                                                          "ParayarNTN", "PiramalaiKallar", "Portugal", "Portuguese_Roma", "Pulayar", "Punjabi", "RajastanBrahmin", 
                                                          "RomaCentralSpain", "RomaEasternSpain", "Romania_Generalpopulation", "Romania_Roma", "RomaNorthernSpain", 
                                                          "RomaPunjabPakistan", "RomaSouthernSpain", "RomaWesternSpain", "Sardinia", "Saudi", "Serbian", "SerbianRoma", 
                                                          "Slovakia_Generalpopulation", "Slovakia_Roma", "Sourashtra", "SouthernSpain", "TamilJains", "Thoda", 
                                                          "TurkCyprus", "Ukraine_Generalpopulation", "Ukraine_Roma", "VadamaBrahmin", "Valayar", "Vanniyar", 
                                                          "VanniyarNTN", "Vokkaliga", "WesternSpain", "Yadhava"),
                            labels = c("AfghanPathan", "Armenian", "Azhara", "Balochistan", "Basque", "Bengali", "BettaKurumba", "BosniaHerzegovina_Roma", "BrahacharanamBrahmin", "Bulgaria_Generalpopulation", "Bulgaria_Roma", "CapeNadar", "CentralSpain", "EasternSpain", "Ezhava", "German", "Greece_Generalpopulation", "Greece_Roma", "HimachalPradesh", "Hungary_Generalpopulation", "Hungary_Roma", "IndiaLeh", "IndiaMadras", "IndiaSoligas", "Iranian", "Iraq", "Irula", "IyengarBrahmin", "Kadar", "Kanikaran", "Kashmiri", "Kattunaickan", "KhandayatOdisha", "Kota", "Kurumba", "Lingayat", "MadyaPradesh", "Maravar", "Mukkuvar", "Mullukurumba", "NadarTNV", "NorthernPortugal", "NorthernSpain", "NorthMacedoniaAlbanian", 
                                       "NorthMacedoniaMacedonian", "NorthMacedoniaTurk", "Paliyan", "Pallar", "Paniya", "Paravar", "Parayar", 
                                       "ParayarNTN", "PiramalaiKallar", "Portugal", "Portuguese_Roma", "Pulayar", "Punjabi", "RajastanBrahmin", 
                                       "RomaCentralSpain", "RomaEasternSpain", "Romania_Generalpopulation", "Romania_Roma", "RomaNorthernSpain", 
                                       "RomaPunjabPakistan", "RomaSouthernSpain", "RomaWesternSpain", "Sardinia", "Saudi", "Serbian", "SerbianRoma", 
                                       "Slovakia_Generalpopulation", "Slovakia_Roma", "Sourashtra", "SouthernSpain", "TamilJains", "Thoda", 
                                       "TurkCyprus", "Ukraine_Generalpopulation", "Ukraine_Roma", "VadamaBrahmin", "Valayar", "Vanniyar", 
                                       "VanniyarNTN", "Vokkaliga", "WesternSpain", "Yadhava"))

pca12 <- ggplot(eigen.pop,aes(x=PC1,y=PC2,color=Population, fill=Population))+
  geom_point(aes(shape=Population, col=Population), size=2.5, alpha=0.9)+
  xlab(paste0("PC1 (", round(percent_explained[1],2), "%)")) + ylab(paste0("PC2 (", round(percent_explained[2],2), "%)"))+
  scale_shape_manual(values=c(13,14,11,10,9,5,6,8,
                              7,
                              10,1,2,3,4,5,6,7,
                              8,8,
                              1,2,3,4,5,6,7,8,9,10,11,
                              1,2,3,4,5,6,7,8,9,10,
                              11,12,13,14,15,
                              13,14,
                              13,14,11,10,9,5,6,8,
                              7,
                              10,1,2,3,4,5,6,7,
                              8,8,
                              1,2,3,4,5,6,7,8,9,10,11,
                              1,2,3,4,5,6,7,8,9))+
  scale_color_manual(values=c("#8b1bc7","#8b1bc7","#8b1bc7","#8b1bc7","#8b1bc7",
                              "#1b71c7","#1b71c7","#1b71c7",
                              "#8b1bc7",
                              "#25a869",
                              "#80d341","#80d341","#80d341","#80d341","#80d341","#80d341","#80d341",
                              "#c7701a","#c7701a",
                              "#a83838","#a83838","#a83838","#a83838","#a83838","#a85238","#a85238","#a85238","#a85238","#a85238","#a85238",
                              "#d4cc61","#d4cc61",
                              "#c7821a",
                              "#d4cc61","#d4cc61","#d4cc61","#d4cc61","#d4cc61","#d4cc61","#d4cc61",
                              "#f7dff5","#f7dff5","#f7dff5","#f7dff5","#f7dff5",
                              "#9da331","#9da331",
                              "#8b1bc7","#8b1bc7","#8b1bc7","#8b1bc7","#8b1bc7",
                              "#1b71c7","#1b71c7","#1b71c7",
                              "#8b1bc7",
                              "#25a869",
                              "#80d341","#80d341","#80d341","#80d341","#80d341","#80d341","#80d341",
                              "#c7701a","#c7701a",
                              "#a83838","#a83838","#a83838","#a83838","#a83838","#a85238","#a85238","#a85238","#a85238","#a85238","#a85238",
                              "#d4cc61","#d4cc61",
                              "#c7821a",
                              "#d4cc61","#d4cc61","#d4cc61","#d4cc61","#d4cc61","#d4cc61"))+
  theme_bw()+
  theme(legend.box="horizontal",legend.position="bottom", legend.key.size = unit(0.5, 'cm'), #change legend key size
        legend.key.height = unit(0.5, 'cm'), #change legend key height
        legend.key.width = unit(0.5, 'cm'), #change legend key width
        legend.title = element_text(size=10), #change legend title font size
        legend.text = element_text(size=9))+
  guides(colour = guide_legend(nrow = 4),shape = guide_legend(nrow = 4))+
  theme(text = element_text(family = "Liberation Serif"))+
  theme(axis.text = element_text(family = "Liberation Serif"))

pca12


### distance

# Transpose the data
data_t <- t(data[, -1])  # Transpose, removing the first column (ID)

# Calculate pairwise genetic distances using Euclidean distance
dist_matrix <- dist(data_t, method = "euclidean")

# Print the distance matrix
print(dist_matrix)

### alternative

# Install and load adegenet package

library(adegenet)

# Assume 'microsat_data' is your dataframe containing microsatellite data
# Rows: Individuals, Columns: Microsatellite loci
# For this example, let's assume 'microsat_data' contains numeric values representing repeat counts

# Convert data to genind object
microsat_genind <- df2genind(microsat_data)

# Calculate pairwise genetic distances
dist_matrix <- pairwise.distances(microsat_genind, method = "euclidean")

# View the distance matrix
print(dist_matrix)
