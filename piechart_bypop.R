
library(ggplot2)
library(dplyr)

setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project")

# Read the data
data <- read.table("haplogroups_to_count.txt", header = TRUE)

# Group by Population and HG, then summarize the counts
haplogroup_frequency <- data %>%
  group_by(Population, HG) %>%
  summarize(count = n()) %>%
  mutate(Frequency = count / sum(count)*100) %>%
  ungroup()

# Summarize how many haplogroups for each Population
haplogroups_by_pop <- data %>%
  group_by(Population) %>%
  summarize(total = n_distinct(HG))

## count individuals by population
pop_individuals <- data %>%
  group_by(Population) %>%
  summarize(total_individuals = n())

# Write the results to a file
write.table(haplogroup_frequency, "haplogroup_frequency.txt", sep = ":", quote = FALSE, row.names = FALSE)
write.table(haplogroups_by_pop, "haplogroups_by_pop.txt", sep = ":", quote = FALSE, row.names = FALSE, append = TRUE)

######### Spanish dataset

# Read data from the CSV file
df <- read.csv("piechart_input_regionspain.csv", sep = ",")

# Group by population and haplogroup, calculate counts and frequencies in %

df_counts <- df %>%
  group_by(Population, HG) %>%
  summarize(total_N = sum(N)) %>%
  mutate(frequency = total_N / sum(total_N)*100)

### Iberian Roma + IBS

df_countsSpain <- df_counts %>%
  filter(grepl("*Spain|Spain*", Population, ignore.case = TRUE))

# Define colors
colors <- c("#31e1bb", "darkolivegreen4", "#4682B4", "#48D1dd","#7B68EE", "#87CEEB",
            "#87CEFA", "darkorchid4", "#98FB98", "#ADD8E6","bisque4", "#BA55D3",
            "#D8BFD8", "#E0FFFF", "darkkhaki", "#FA8072", "#FF6347", "grey",
            "#AEaFDf", "#FFA07A", "#FFA500", "#FFB6C1", "blue4", "#FFDAB9",
            "#7Fa8AA","#FAB751","azure4","aquamarine1","chocolate","darkorange4","darkgoldenrod4","darkorchid")

order_levels <- c("CentralSpain","NorthernSpain","EasternSpain","SouthernSpain","WesternSpain",
                  "RomaCentralSpain","RomaNorthernSpain","RomaEasternSpain","RomaSouthernSpain","RomaWesternSpain")

df_countsSpain$Population <- factor(df_countsSpain$Population, levels = order_levels)

# Using the colors in the ggplot script

p2 <- ggplot(df_countsSpain, aes(x = "", y = frequency, fill = HG)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  facet_wrap(~Population, ncol = 5)+
  scale_fill_manual(values = colors)+
  theme_void()+
  theme(legend.position = "right")
p2

############ European Roma plots

idpop <- data %>% 
  group_by(Population) %>%
  summarize(N = n()) %>% 
  ungroup()

df_counts1 <- left_join(haplogroup_frequency, idpop, by = "Population")

df_countsRoma <- df_counts1 %>%
  filter(grepl("Roma", Population, ignore.case = TRUE) &
           !grepl("PunjabiRoma", Population, ignore.case = TRUE) &
           !grepl("^Romanian$", Population))

populations_to_grep <- c("Bulgarian","Greek", 
                         "Hungarian",
                         "Portuguese","Romanian", 
                         "Serbian","Slovakian", 
                         "Ukrainian","NorthMacedoniaAlbanian","Spanish")

df_countsPopulations <- df_counts1 %>%
  filter(Population %in% populations_to_grep)

df_countsRomaEur <- rbind(df_countsRoma,df_countsPopulations)

order_levels1 <- c("SpanishRoma","PortugueseRoma",
                   "BosnianRoma", 
                   "BulgarianRoma", 
                   "GreekRoma", 
                   "HungarianRoma",
                   "RomanianRoma", 
                   "SerbianRoma", 
                   "SlovakianRoma", 
                   "UkrainianRoma",
                   "Spanish","Portuguese",
                   "NorthMacedoniaAlbanian",
                   "Bulgarian", 
                   "Greek",
                   "Hungarian",
                   "Romanian", 
                   "Serbian",
                   "Slovakian", 
                   "Ukrainian")

df_countsRomaEur <- transform(df_countsRomaEur,
                              Population = factor(Population, levels = order_levels1),
                              facet_label = paste(Population, "N =", N)) %>% arrange(Population)

df_countsRomaEur$facet_label <- factor(df_countsRomaEur$facet_label, levels = unique(df_countsRomaEur$facet_label))

p3 <- ggplot(df_countsRomaEur, aes(x = "", y = Frequency, fill = HG)) +
  geom_bar(width = 1, stat = "identity")+
  coord_polar("y", start = 0) +
  facet_wrap(~facet_label, ncol = 5)+
  scale_fill_manual(values = colors)+  
  theme_void()+
  guides(element_text(size = 16, family = "Liberation Serif"))+
  theme(legend.position = "right")
p3
