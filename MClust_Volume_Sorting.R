setwd() #set your working directory to be where you keep your data
library(mclust) #load in the mclust package

# Read in data. The sample data frame has two columns: Volumes and Mito.color.
terminal_data <- read.csv("UTS_TerminalVolumes_Sample.csv")

# Sort data into light mitochondria terminals (code 2) and dark/no mitochondria terminals (codes 1 or 0)
light_terms = terminal_data$Volume[terminal_data$Mito.color==2]
dark_no_terms = terminal_data$Volume[terminal_data$Mito.color==1 | terminal_data$Mito.color==0]

# Run Mclust
light_terms_mclust = Mclust(light_terms)
dark_no_terms_mclust = Mclust(dark_no_terms, G=5) # If you want Mclust to return a specific number of clusters, use the G argument

# View Mclust results
summary(light_terms_mclust)
summary(dark_no_terms_mclust)

# Mean and Standard Deviation
light_terms_mclust$parameters$mean
light_terms_mclust$parameters$variance$sigmasq
dark_no_terms_mclust$parameters$mean
dark_no_terms_mclust$parameters$variance$sigmasq

# BIC of different models
light_terms_mclust$BIC
dark_no_terms_mclust$BIC

# Combine data and classification into single data frame
cbind(light_terms_mclust$data, light_terms_mclust$classification)
cbind(dark_no_terms_mclust$data, dark_no_terms_mclust$classification)
