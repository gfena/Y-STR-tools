
#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("ggtree")

#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("Biostrings")

library("ape")
library("Biostrings")
library("ggplot2")
library("ggtree")
library("phytools")

setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project")

# ape
nwk <- ape::read.tree("FullDataset.tree.newick")

ape::plot.phylo(nwk)

nwk.unrooted<-unroot(nwk)

ee<-nwk.unrooted$edge.length
ee<-ee*rgamma(n=length(ee),shape=3,scale=1/3)
nwk.unrooted$edge.length<-ee

ape::plot.phylo(nwk.unrooted)

# phytools

tree <- read.tree("FullDataset.tree.newick")

ggtree(tree)

ggtree(tree) + geom_treescale()

ggtree(tree) + geom_tiplab(as_ylab=TRUE, color='black',align = FALSE)

## alternative
ggtree(tree, branch.length="none")