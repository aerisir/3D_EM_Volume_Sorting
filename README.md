# 3D_EM_Volume_Sorting
R code and sample data for categorizing axon terminals based on their morphology and volume.

Repository for files that are used in 1) Maher EE, Briegel AC, Imtiaz S, Fox MA, Golino H, Erisir A. 3D electron microscopy and volume-based bouton sorting reveal the selectivity of inputs onto geniculate relay cell and interneuron dendrite segments. Front Neuroanat. 2023 Mar 17;17:1150747. doi: 10.3389/fnana.2023.1150747. and 2) "Unbiased Sampling and Volume-Sorting of Origin-Specific Terminals Using SBEM Image Stacks" by Erisir A, Briegel AC, Maher EE, and Sciaccotta FP (citation pending).

The two .R code files are written and tested by Alex Briegel and Alev Erisir in the Department of Psychology, University of Virginia, Charlottesville, VA USA. 
All questions can be directed to erisir@virginia.edu. 

Redistribution and use in source and binary forms, with or without modification, are permitted under BSD 2-Clause License. 

## Mclust_Volume_Sorting.R
This code contains a basic walkthrough detailing the usage of the "mclust" package for Gaussian Normal Mixture Modeling in R, using a dataset of terminal bouton volumes measured using Serial Electron Microscopy image stacks and an Unbiased Terminal Sampling method detailed in Erisir et al., (citation pending). A sample dataset is provided as a template for the data structure of the user's specific application.

## MonteCarlo_VolumeSortingCutoffs.R
This code contains a basic function and process for determining generalizable cutoff values between the subpopulations with partially overlapping volumes returned by the Mclust_Volume_Sorting analysis. Importantly, the user should edit this code as needed for their project and datasets by changing parameter values, names, and the number of subpopulations within the function. The cutoff values can then be implemented in other datasets from the same or the same type of tissue where UTS method is not feasible. 

## Getting Started with Volume Sorting with Mclust
To start, open up the Mclust_Volume_Sorting.R file. Make sure to set your working directory in line 1.  Since our data consisted of two distinct populations that could initially be sorted using morphological criteria, the code separates the sample data into two groups in lines 7-9. The actual mclust functions are run in lines 12-13.  The summary() function is used to overview the results of mclust, including the descriptive statistics of each subpopulation component, the log-likelihood and BIC for the model. For a detailed walkthrough of the "Mclust" package, visit: https://cran.r-project.org/web/packages/mclust/vignettes/mclust.html

## Determination of Cutoff Values using Monte Carlo Simulation
While mclust function classifies each data point into a subpopulation based on the likelihood of a value belonging to one of the two adjacent populations, it does not identify a cutoff value that can be applied to other datasets. To estimate a cutoff criteria between two subpopulations that overlap at the lower and higher end of their distributions respectively, Monte Carlo simulations can be used. The code in the file MonteCarlo_VolumeSortingCutoffs.R generates dense simulations of subpopulations and calculates the average midpoint between the largest and the smallest members of adjacent subpopulations across iterations. 

The function, named **sp_mc_function**, starts by simulating values from each subpopulation based on the parameters of the subpopulations entered in lines 2-5. The function then combines the values into one variable and removes any smaller than 0, since axon terminal volumes are always >0. The mclust function is then run on this final version of the simulated data on line 20. 

Following this, a matrix is created containing each simulated data point along with its classification based on Mclust. The **for loop** on lines 23-25 calculates the cutoff values between each subpopulation.  For each subpopulation, for example, clusters 1 and 2, the code finds the highest terminal volume contained in cluster 1 and the lowest terminal volume contained in cluster 2 and averages them.  This then repeats for clusters 2 and 3 and so on. The function returns all the cutoff values.

User input is required on lines 2-5, replacing the sample values with the parameters of subpopulations in user's dataset. The data size can be scaled up by assigning an sf value on line 34. The default iteration number is set to 10,000, and can be changed at B= on line 33.
The code assumes 4 subpopulations; it can be revised to handle different numbers by revising lines 16-17.

Lines 52-59 generate a .csv file for all cutoff values in simulated datasets.
Lines 61-78 provide the mean and median for simulated cutoff values. Median values are used as generalizable cutoffs. 
