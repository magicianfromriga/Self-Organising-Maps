#This is the R Script containing all the essential functions for the Self Organising Map.

# -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  ----- ----- ----- #

# 1) Function to calculate the distance measure - Sum of Squared Distance.
ssd_ <- function(x, y) {
  ret <- sum((x - y)^2)
  return(ret)
}

# -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  ----- ----- ----- #

# 2) Function to create a n*n grid, where each grid unit stores a weight vector.

crt_gr <- function(n,p) {
  ret <- matrix(data = rnorm(n * p), nrow = n, ncol = p)
  return(ret)
}

# -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  ----- ----- ----- #

# 3) Function to decay the radius exponentially over time. 
# rds is the initial radius that is passed.
# cur_iter represents the current iteration.
# tm_cnst is the time constant that is calculated before the 

dcy_rds <- function(rds, cur_iter, tm_cnst) {
  ret <- rds * exp(-cur_iter / tm_cnst)
  return(ret)
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------

# 4) Function to decay the learning rate.
# lr is the current learning rate.
# cur_iter is the current iteration
# n_iter is the number of iterations.

dcy_lrng_rt <- function(lr, cur_iter, n_iter) {
  ret <- lr * exp(-cur_iter / n_iter)
  return(ret)
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------

# 5) A function to calculate influence over neighboring neurons
#dstnc is the lateral distance.
#rds is the current neighbourhood radius.

inflnc <- function(dstnc, rds) {
  ret <- exp(-(dstnc^2) / (2 * (rds^2)))
  return(ret)
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------

# 6)Function to find the best matching unit, also known as the winning neuron.
#x is a single row of data and gr is the grid

BMU_Vectorised <- function(x, gr) { 
  dist_mtrx=rowSums(sweep(gr,2,as.vector(unlist(x)))^2) #Calculating the distance of this row from all the neurons using matrix operations.
  min_ind=which.min(dist_mtrx) #Finding the location of the neuron with the minimum distance.
  return (min_ind-1) #Returning the zero-indexed value of the winning neuron.
}

# -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  ----- ----- ----- #

# 7)Function to output a Self Organising Map.
#x is the input and gr is the SOM grid that will be updated iteratively.

SOM <- function(x, gr) {
  n_iter <- nrow(x) # Defining number of iterations
  intl_lr <- 0.1 # Defining initial learning rate
  intl_rds <- 50 # Defining initial radius
  tm_cnst <- n_iter / log(intl_rds) # Initializing time constant
  ltrl_dst_points=expand.grid(1:sqrt(nrow(gr)),1:sqrt(nrow(gr)))#Initialising physical locations of neurons to figure out lateral distance.
  rows=sqrt(nrow(gr)) #The square grid is used here - so taking the number of rows as square root of number of entries in the grid.
  n_epochs=10 #Defining the number of epochs.
  for(ne in 1:n_epochs)
  {
    print(ne)
    old_grid=gr
    for (i in 1:n_iter) # Looping through for training
    {
      dt <- as.vector(unlist(x[sample(1:nrow(x), size = 1, replace = F), ])) # Selecting random input row from given data set
      new_rds <- dcy_rds(intl_rds, i, tm_cnst) # Decaying radius
      new_lr <- max(dcy_lrng_rt(intl_lr, i, n_iter), 0.01) # Decaying learning rate
      index_temp <- BMU_Vectorised(dt, gr) # Finding best matching unit for given input row
      index_new=c((as.integer(index_temp/rows))+1,(index_temp%%rows)+1) #Converting a 1D co-ordinate to a 2D co-ordinate for finding lateral distance on the map.
      ltrl_dist=sqrt(rowSums(sweep(ltrl_dst_points,2,index_new)^2)) #Finding Euclidean distance between the given best matching units and all units on the map.
      rn=which(ltrl_dist<=new_rds) #Finding neurons that are within the radius of the winning unit.
      inf=inflnc(ltrl_dist[rn],new_rds) #Calculating the influence of the winning neuron on neighbours.
      diff_grid=(sweep(gr[rn,],2,dt))*-1 #A temporary matrix that stores the difference between the data point and the weights of the winning neuron & neighbours.
      updt_weights=new_lr*inf*diff_grid #The updating operation on the winning and neighbouring neurons.
      gr[rn,]=gr[rn,]+updt_weights #Now updating those grid entries that are either the winning neuron or its neighbours.
      if(isTRUE(all.equal(old_grid,gr)))
      {
        print(i)
        print("Converged")
      }
    }
  }
  return(gr) #Returning the updated SOM weights.
}

# -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  ----- ----- ----- #

