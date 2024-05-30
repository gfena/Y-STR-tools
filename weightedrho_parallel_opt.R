
# Load Libraries
if (!requireNamespace("optparse", quietly = TRUE)) {
  install.packages("optparse")
}

library(optparse)
library(parallel)

# Command-line options
option_list <- list(
  make_option(c("-m", "--mutationrates"), type = "character", default = "mutationrates.csv",
              help = "CSV file with mutation rates [default: %default]", metavar = "character"),
  make_option(c("-g", "--genlength"), type = "numeric", default = 25,
              help = "Generation length in years [default: %default]", metavar = "numeric")
)

opt_parser <- OptionParser(usage = "usage: %prog input prefix [options]", option_list = option_list)
opt <- parse_args(opt_parser, positional_arguments = 2)

if (length(opt$args) == 0) {
  stop("At least one argument must be supplied (input file).\n", call. = FALSE)
} else if (length(opt$args) == 1) {
  opt$args <- c(opt$args, "out.txt")
}

# Input arguments
infile <- opt$args[1]
out_file_prefix <- opt$args[2]

# Optional args
mutationrates_file <- opt$options$mutationrates
genlength <- opt$options$genlength

execution_time <- system.time({
  setwd("~/Desktop/Giacomo/IberianRoma_PaternalDNA_Project/codes/weightedrho")
  
  haps <- read.csv(infile, header = TRUE, sep = ",")
  mutationrates <- read.csv(mutationrates_file, header = FALSE, sep = ",")
  
  nind <- nrow(haps)
  nloci <- ncol(haps)
  yearspermut <- genlength / mutationrates
  totyearspermut <- genlength / sum(t(mutationrates))
  meanmut <- mean(t(mutationrates))
  
  no_cores <- detectCores() - 1
  cl <- makeCluster(no_cores)
  clusterExport(cl, varlist = c("haps", "mutationrates", "genlength", "nloci", "nind", "meanmut"))
  
  medianhap <- parLapply(cl, 1:nloci, function(i) {
    median(haps[, i])
  })
  medianhap <- unlist(medianhap)
  
  clusterExport(cl, varlist = c("medianhap"))
  
  wdistl_list <- parLapply(cl, 1:nloci, function(i) {
    sapply(1:nind, function(k) {
      abs((haps[k, i] - medianhap[i])) * (meanmut / t(mutationrates[i]))
    })
  })
  wdistl <- do.call(cbind, wdistl_list)
  
  rwdistl_list <- parLapply(cl, 1:nloci, function(i) {
    sapply(1:nind, function(k) {
      abs((haps[k, i] - medianhap[i]))
    })
  })
  rwdistl <- do.call(cbind, rwdistl_list)
  
  stopCluster(cl)
  
  rhoh <- rowSums(wdistl)
  rhoh2 <- rowSums(wdistl ^ 2)
  rrhoh <- rowSums(rwdistl)
  rrhoh2 <- rowSums(rwdistl ^ 2)
  
  wrho <- sum(rhoh) / nind
  wage <- wrho * totyearspermut
  sdwrho <- sqrt(sum(rhoh2)) / nind
  sdwage <- sdwrho * totyearspermut
  
  rho <- sum(rrhoh) / nind
  age <- rho * totyearspermut
  sdrho <- sqrt(sum(rrhoh2)) / nind
  sdage <- sdrho * totyearspermut
  
  results <- data.frame(
    N = round(nind, digits = 0),
    Nhap = round(nind, digits = 0),
    rho = round(rho, digits = 4),
    sdrho = round(sdrho, digits = 4),
    age = round(age, digits = 0),
    sdage = round(sdage, digits = 0),
    weighted_rho = round(wrho, digits = 4),
    weighted_sdrho = round(sdwrho, digits = 4),
    weighted_age = round(wage, digits = 0),
    weighted_sdage = round(sdwage, digits = 0)
  )
  
  output_file_name <- paste0(out_file_prefix, "_timing_results.csv")
  write.table(results, file = output_file_name, row.names = FALSE, quote = FALSE, sep = "\t")
})

print(paste("Total computing time:", execution_time["elapsed"], "seconds"))
