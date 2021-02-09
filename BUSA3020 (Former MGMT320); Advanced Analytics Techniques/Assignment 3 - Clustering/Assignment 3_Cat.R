#Preliminary stuf 
library(dplyr)      # for data manipulation
library(ggplot2)    # for pretty charts
library(ggcorrplot) # unnecessary but pretty correlation plot
library(NbClust)    # helps estimate optimum number of clusters

### Read the data 
df <-- read.csv("clustering.csv")
head(df)

str(df)

#Categorised the variables. 
df$Gender <- as.factor(df$Gender)
df$Left...right.handed <- as.factor(df$Number.of.siblings)
df$Education <- as.factor(df$Education)
df$Only.child <- as.factor(df$Only.child)
df$Village...town <- as.factor(df$Village...town)
df$House...block.of.flats <- as.factor(df$House...block.of.flats)

str(df)

df

