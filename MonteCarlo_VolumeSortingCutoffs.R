### Write in the parameters obtained from mclust analysis of a sample dataset 'volumes'. 
volumes_G = 4   # G is the number of subpopulations that is the best fit at the BIC analysis. In the sample 'volumes' dataset, G=4.
volumes_n = c(69, 82, 25, 15)  # from mclust; the number of observations in each subpopulation of the volumes dataset
volumes_means = c(0.8666019,  1.9099352,  3.9887601, 12.5644316)  # from mclust; mean values for each subpopulation in the sample 'volumes' dataset.
volumes_sd = c(0.288277523,	0.638343928,	1.354984856,	5.14251193)  # from mclust; standard deviations for each subpopulation in the sample  'volumes' dataset

### Install mclust 
library(mclust)

### Define the functions to be replicated for each subpopulation (sp)
sp_mc_function <- function() {
  ## simulate each subpopulation. sf is the scaling factor for subpopulation sizes.    
  sp1 <- rnorm(volumes_n[1]*sf, mean = volumes_means[1], sd = volumes_sd[1])
  sp2 <- rnorm(volumes_n[2]*sf, mean = volumes_means[2], sd = volumes_sd[2])
  sp3 <- rnorm(volumes_n[3]*sf, mean = volumes_means[3], sd = volumes_sd[3])
  sp4 <- rnorm(volumes_n[4]*sf, mean = volumes_means[4], sd = volumes_sd[4])
  sp_data <- sort(c(sp1, sp2, sp3, sp4))
  
  ## Exclude negative data points from simulations, perform clustering on sp_data using Mclust with G clusters, and combine the cluster classification and data into a matrix
  sp_data <- sp_data[which(sp_data > 0)]
  sp_mclust <- Mclust(sp_data, G = volumes_G)
  sp_matrix <- cbind(sp_mclust$classification, sp_mclust$data) 
  
  ## Store the calculated mean values in a vector and calculate the mean of specific data points in sp_matrix
  sp_cuts <- c()  
  for(i in 1:(volumes_G-1)){
    sp_cuts[i] <- mean(sp_matrix[c(which(sp_matrix[,1] == i+1)[1]-1, which(sp_matrix[,1] == i+1)[1]), 2])
  }
  sp_cuts
}

### Replicate
B <- 10000
sf <- 5

## Create cutoff values for B replications.
sp_cut_matrix <- matrix(nrow = B, ncol = volumes_G - 1)
num_iterations <- 0  # Number of valid iterations

while (num_iterations < B) {
  sp_cut <- sp_mc_function()
  
  # Check if any negative values or missing values exist in the cutoff values
  if (any(sp_cut < 0) || any(is.na(sp_cut))) {
    next  # Skip the current iteration
  }
  
  num_iterations <- num_iterations + 1
  sp_cut_matrix[num_iterations, ] <- sp_cut
}

# Convert the matrix to a data frame
sp_cut_data <- data.frame(sp_cut_matrix)

# Write the data frame to a CSV file
write.csv(sp_cut_data, "sp_cut_values.csv", row.names = FALSE)

# Read the sp_cut_data from the CSV file
sp_cut_data <- read.csv("sp_cut_values.csv")

# Calculate the median of each column of cutoff values
median_X1 <- median(sp_cut_data$X1)
median_X2 <- median(sp_cut_data$X2)
median_X3 <- median(sp_cut_data$X3)

# Calculate the mean of each column
mean_X1 <- mean(sp_cut_data$X1)
mean_X2 <- mean(sp_cut_data$X2)
mean_X3 <- mean(sp_cut_data$X3)

# Print the results
cat("Median of X1:", median_X1, "\n")
cat("Median of X2:", median_X2, "\n")
cat("Median of X3:", median_X3, "\n")

cat("Mean of X1:", mean_X1, "\n")
cat("Mean of X2:", mean_X2, "\n")
cat("Mean of X3:", mean_X3, "\n")
