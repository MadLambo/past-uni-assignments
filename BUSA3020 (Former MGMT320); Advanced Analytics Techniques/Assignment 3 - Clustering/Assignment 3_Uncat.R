library(dplyr)      # for data manipulation
library(ggplot2)    # for pretty charts
library(ggcorrplot) # unnecessary but pretty correlation plot
library(NbClust)    # helps estimate optimum number of clusters

### Read the data 
df <-- read.csv("clustering.csv")
head(df)

str(df)


### Question 1

### Generate a correlation plot 
cormat <- round(cor(music.data), 2)
ggcorrplot(cormat, hc.order = TRUE, type = "lower",  lab = FALSE)


### Conduct PCA 
survey.pr <- prcomp(df, center = TRUE, scale = TRUE)
summary(survey.pr)

### Scree plot

```{r scree}
screeplot(survey.pr,
          type = "l",
          npcs = 12,
          main = "Screeplot of PCs")
abline(h = 1, col = "red", lty = 5)
legend(
  "topright",
  legend = c("Eigenvalue = 1"),
  col = c("red"),
  lty = 5,
  cex = 0.6
)
```

### Cumulative variance plot

```{r}

# Calculate cumulative proportion for charting
cumpro <- cumsum(survey.pr$sdev ^ 2 / sum(survey.pr$sdev ^ 2))

# the plot
plot(cumpro[0:12],
     type = "b",
     xlab = "PC #",
     ylab = "Explained variance",
     main = "Cumulative variance")
abline(v = 2, col = "blue", lty = 5)
abline(h = 0.90, col = "blue", lty = 5)
legend(
  "topleft",
  legend = c("Cut-off @ PC2"),
  col = c("blue"),
  lty = 5,
  cex = 0.6
)

```


# extract only the first two principal components
components <- data.frame(survey.pr$x[, 1:2])

head(components)

plot(components, pch = 19, col = rgb(0,0,0,0.5))

```

```{r plotPCs}

plot(
  survey.pr$rotation[, 1],
  survey.pr$rotation[, 2],
  col = "lightblue", pch = 19, cex = 2,
  xlab = "PC1 (74.3%)",
  ylab = "PC2 (15.7%)",
  main = "Unrotated PC1 / PC2 - plot"
)

########


Question 2

music.data <- data.frame (df$Music, df$Slow.songs.or.fast.songs, df$Dance, df$Folk, df$Country, df$Classical.music, df$Musical, df$Rock, df$Metal.or.Hardrock, df$Punk, df$Hiphop..Rap, df$Reggae..Ska, df$Swing..Jazz, df$Rock.n.roll, df$Alternative, df$Latino, df$Techno..Trance, df$Opera, df$Pop)
movie.data <- data.frame(df$Movies, df$Horror, df$Thriller, df$Comedy, df$Romantic, df$Sci.fi, df$War, df$Fantasy.Fairy.tales, df$Animated, df$Documentary, df$Western, df$Action)


```{r clustersn}

# Determine number of clusters
wss <- (nrow(music.data) - 1) * sum(apply(music.data, 2, var))
for (i in 2:15)
  wss[i] <-
  sum(kmeans(
    music.data,
    centers = i,
    nstart = 25,
    iter.max = 1000
  )$withinss)
plot(1:15,
     wss,
     type = "b",
     xlab = "Number of Clusters",
     ylab = "Within groups sum of squares")

```

```{r nclust}

nClust = NbClust(music.data, 
                 distance = "euclidean", 
                 method = "kmeans", 
                 min.nc = 2, 
                 max.nc = 15)

nClust - ####Find the optiminal number of clusters 
  
  
  # Apply k-means with k=3
  k <- kmeans(music.data,
              centers = 3,
              nstart = 25,
              iter.max = 1000)

plot(components, col = k$clust, pch = 16)

```


cluster.data <- NULL
cluster.data$id <- as.character(df$id)
cluster.data$Satisfaction <- as.integer(df$OverallSatisfaction)
cluster.data$PC1 <- components$PC1
cluster.data$PC2 <- components$PC2
cluster.data$kclust <- as.factor(k$clust)
cluster.data <- data.frame(cluster.data)


music.data$cluster
music.data$cluster <- k$cluster
music.data

write.csv(music.data, "music_data.csv")

#Hierarchical clustering
summary(cluster.data)

distances <- dist(music.data)

str(distances)

h <- hclust(distances, method = "ward.D2")
plot(h) #the dendrogram


hclust <- cutree(h, 3)

summary(hclust)


cluster1.data$hclust <- as.factor(hclust)

summary(cluster1.data)



#### Compare Solutions
Finally, let's compare the two different clustering solutions. Are the same observations allocated into the same clusters?
  
A simple crosstabulation

table(cluster.data$hclust, cluster.data$kclust)

df$Pc1 <- cluster.data$PC1
df$Pc2 <- cluster.data$PC2

df$kclust <- cluster.data$kclust
df$hclust <- cluster.data$hclust



ggplot(data = df, aes(Pc1, Pc2)) + 
  geom_point(shape = df$kclust, colour = df$hclust) +
  theme_classic()