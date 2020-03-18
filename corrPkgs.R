# The ulimate package for correlations (by easystats)
# https://www.r-bloggers.com/the-ulimate-package-for-correlations-by-easystats/


rm(list=ls())

# install.packages("correlation")
library(correlation)

cor <- correlation(iris)
cor
summary(cor)
as.table(cor)


# Grouped dataframes

# The function also supports stratified correlations, all within the tidyverse workflow!
  
  library(dplyr)

iris %>% 
  select(Species, Petal.Width, Sepal.Length, Sepal.Width) %>%
  group_by(Species) %>% 
  correlation()


# Bayesian Correlations

# It is very easy to switch to a Bayesian framework.
# install.packages("BayesFactor")
library(BayesFactor)

correlation(iris, bayesian=TRUE)



# Tetrachoric, Polychoric, Biserial, Biweight…

# The correlation package also supports different types of methods, which can deal with correlations between factors!
  
correlation(iris, include_factors = TRUE, method = "auto")



# Partial Correlations

# It also supports partial correlations:
  
  iris %>% 
  correlation(partial = TRUE) %>% 
  summary()

  
# Gaussian Graphical Models (GGMs)
  
#  Such partial correlations can also be represented as Gaussian graphical models, an increasingly 
# popular tool in psychology:
    
# install.packages("see")  
library(see) # for plotting
library(ggraph) # needs to be loaded
  
  mtcars %>% 
    correlation(partial = TRUE) %>% 
    plot()
  