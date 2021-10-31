#This is an R Script for loading RGB data into an arrow parquet, which is the fastest data structure in R.

# -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  ----- ----- ----- #

# 1)Loading required libraries

library(arrow)
library(tidyverse)

# -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  ----- ----- ----- #

# 2) Creating the dataset

# 2.1)Defining the size of the dataset. Previous dataset had 10k entries. This one has 20k, twice the size.
smpl_sz=20000

# 2.2) Creation of the dataset
rgb_df=as.data.frame(matrix(nrow = smpl_sz, ncol = 3))

# 2.3) Defining column names as R,G,B
colnames(rgb_df) = c('R', 'G', 'B')

# 2.4) Randomly initialising row values for R G B columns
rgb_df$R = sample(0:255, smpl_sz, replace = T)
rgb_df$G = sample(0:255, smpl_sz, replace = T)
rgb_df$B = sample(0:255, smpl_sz, replace = T)

# 2.5) Scale data
scaled_data=as.matrix(scale(rgb_df))

# 2.6) Converting R data frame into Arrow parquet. 
file_path <- tempfile()
write_parquet(as.data.frame(scaled_data), file_path)
df=read_parquet(file_path)

# -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  ----- ----- ----- #
