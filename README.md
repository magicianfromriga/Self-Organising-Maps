# Self-Organising-Maps
This repository contains all the work that I have done regarding Self Organising Maps, which includes my project work for the R-FOSSEE team and the Technical Seminar that I presented as compulsory course-work during my 5th semester. 

A brief summary of Self Organising Maps (sourced from my presentation):
1. A Self Organising Map is an Artificial Neural Network trained using unsupervised learning.
2. It was introduced by Finnish Professor Kohonen in the 1980s.
3. It produces a low dimensional representation of input space.
4. SOM is generally considered as a method of dimensionality reduction.
5. Compared to other NNs, it uses competitive learning.
6. Large SOMs can be used for clustering applications.

My work in Self Organising Maps can be summarised as follows:
1. For my technical seminar, I implemented an SOM in R that can be used to cluster similar groups of colors together and later classify new color entries. 
2. For my work with R FOSSEE, IIT Bombay, I had to implement an SOM model from scratch in R that will be used to track the spread of COVID-19 virus. My contribution to this project included designing the base algorithm and optimising the code. I was also involved in convergence of the algorithm to the optimal solution (a joint effort with Aboli Marathe, a fellow intern at R FOSSEE). 

There were numerous challenges involved when designing the algorithm from scratch:
1. A lack of coding experience in R.
2. Deficiencies in a statistical and mathematical background.
3. No previous implementation in R that could be used as a reference. 

These challenges were overcome step-by-step as follows:
1. The beginning: Numerous versions of the self organising map was developed from scratch. Kohonen’s textbook was used as a primary source. The most primitive implementation only ran for 1 epoch and took 37 seconds to work on a very small dataset (around 400 values).
2. Problems with Naive Approach: One of the drawbacks of R is that compared to C or C++ it is a slower language. Thus, the naive approach had the drawback of being extremely slow.
Compared to C, using a lot of for-loops in R hindered performance quite a bit. Two of the most expensive operations were computing the best matching unit (BMU) function and the SOM function. However, even the sum of squared distance (SSD) function was taking longer than expected. Thus the focus shifted to getting the code to run faster and more efficiently. 
3. Vectorisation: Focus shifted to the BMU function, where using vectorisation reduced the number of lines of code while making it 10x faster. The SOM code was also optimised to use matrix operations as much as possible. The end result was a model that used more than 4x less memory and was almost 10x faster than the naive implementation.
4. Convergence: In the initial model, the SOM function ran for only one epoch. This doesn’t guarantee convergence. Hence, appropriate modifications were made to ensure that the model only stopped when there was no change between the old weights and new.





