rm(list=ls())

# install.packages("heatmaply")
library(heatmaply)
mtcars_2 <- percentize(mtcars)
heatmaply(mtcars_2, k_row = 4, k_col = 2)
# I got the static image using ggheatmap instead of heatmaply