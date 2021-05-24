# ---
# title: "R로 하는 상관분석 실습"
# ---

# 이 글은 pXd 그룹을 위해 만든 R 로 하는 상관분석에 대한 기본 실습 코드와 시각화 코드 예제입니다.

# 이 글에서 인용된 데이터는 Martin Edward 와 Kirsten Edwards 가 공저한 "Predictive HR Analytics"에서 사용한 데이터 예제를 활용하였습니다.

# 오늘은 아래 내용애  대해서 간단히 배워보도록 하겠습니다.

# 1. txt 데이터 읽어들이기

# 2. R 상관분석을 위한 함수 검토

# 3. 상관분석 시각화 함수


rm(list=ls())


df <- read.table(file = "data/Chapter4Diversity1.txt", header = TRUE, sep = "\t")

names(df)

head(df)

df$BossGender <- as.factor(df$BossGender)
df$Gender <- as.factor(df$Gender)
df$Status <- as.factor(df$Status)
df$Division <- as.factor(df$Division)
df$Country <- as.factor(df$Country)
df$leaver <- as.factor(df$leaver)

str(df)

summary(df)

library(dplyr)

df1 <- select(df, c(JobGrade, Age, Tenure, PerformanceScore, BossPerformance))


# install.packages("kableExtra")
library(kableExtra)

dt1 <- c( "함수","pearson","spearman","kendall","p-value","confidence","multi-correlation","remark")
dt2 <- c(" ","피어슨","스피어만","켄달","p값","신뢰구간","다중 상관","비고")
dt3 <- c("cor()","Y","Y","Y"," ","  ","Y", " ")
dt4 <- c("cor.test()","Y","Y","Y","Y","Y","  "," ")
dt5 <- c("rcorr()","Y","Y"," ","Y"," ","Y","소숫점 이하 두 자리")

dt <- rbind(dt1,dt2,dt3,dt4,dt5)

dt %>%
  kbl(caption = "R 상관분석 함수 종류별 차이") %>%
  kable_material_dark() %>%
  kable_paper(bootstrap_options = "striped", full_width = F)

cor(df1)


df2 <- na.omit(df1)


cor(df2)

cor.test(formula =  ~ JobGrade + Age, data = df2)

# install.packages("Hmisc")
library(Hmisc)

rcorr(as.matrix(df2))

# install.packages("correlation")
library(correlation)

cor <- correlation(df2)
cor
summary(cor)
as.table(cor)


df2 %>% 
  select(JobGrade, Age, Tenure, PerformanceScore, BossPerformance) %>%
  correlation()


# Tetrachoric, Polychoric, Biserial, Biweight…

# The correlation package also supports different types of methods, which can deal with correlations between factors!

correlation(df2, include_factors = TRUE, method = "auto")


# It also supports partial correlations:

df2 %>% 
  correlation(partial = TRUE) %>% 
  summary()



# make correlation matrix
cmat <- rstatix::cor_mat(df1, names(select_if(df1, is.numeric)))
cmat

# matrix of p-values

library(tidyr)
library(rstatix)

rstatix::cor_get_pval(cmat)

rstatix::cor_mark_significant(cmat)
rstatix::cor_gather(cmat)

cmat_long <- cor_gather(cmat)
rstatix::cor_spread(cmat_long)


# Gaussian Graphical Models (GGMs)

#  Such partial correlations can also be represented as Gaussian graphical models, an increasingly 
# popular tool in psychology:

# install.packages("see")  
library(see) # for plotting
library(ggraph) # needs to be loaded

df2 %>% 
  correlation(partial = TRUE) %>% 
  plot()


library(reshape2)


melted_cormat <- melt(cor)
melted_cormat

library(ggplot2)

ggplot(data = melted_cormat, aes(x=Parameter1, y=Parameter2, fill=value)) + 
  geom_tile(aes(fill = value),colour = "white") + scale_fill_gradient(low = "white",high = "steelblue")

# Visualizing Correlation Matrix


# install ggcorrplot and ggpubr
# install.packages("ggcorrplot")
# install.packages("ggpubr")
# install.packages("latex2exp")


library(ggcorrplot)
library(ggpubr)
library(latex2exp)

# ggcorrplot - basic 
ggcorrplot(cor, title = "근속, 연령, 직위과 성과의 상관관계 분석")


# ggcorrplot - customized
ggcorrplot(cor, # takes correlation matrix
           title = "근속, 연령, 직위과 성과의 상관관계 분석",
           ggtheme = theme_classic, # takes ggplot2 and custom themes
           colors = c("red", "white", "forestgreen"), # custom color palette
           hc.order = TRUE, # reorders matrix by corr. coeff.
           type = "upper", # prevents duplication; also try "lower"
           lab = TRUE, # adds corr. coeffs. to the plot
           insig = "blank", # wipes non-significant coeffs.
           lab_size = 3.5) %>% 
  # add subtitle and caption; note rendering LaTeX symbols in ggplot objects
  ggpubr::ggpar(subtitle = latex2exp::TeX("Significant correlations only (p$\\leq$.05)",
                                          output = "text"), 
                caption = "Data: Gorman, Williams, and Fraser 2014")

library(corrplot)
library(RColorBrewer)
library(dplyr)

M <- df %>% select(JobGrade, Age, Tenure, PerformanceScore, BossPerformance) %>% cor()
corrplot(M, method="circle")


library(PerformanceAnalytics)
chart.Correlation(cor, histogram=TRUE, pch="+")

