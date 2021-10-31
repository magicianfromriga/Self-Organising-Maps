source("data_loading.R")
source("Essential_Functions.R")

#Creating a 50*50 Grid
som_grid=crt_gr(100,3)

#Creating a Self Organising Map
som_grid=SOM(df,som_grid)



