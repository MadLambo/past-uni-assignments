library(dplyr)      # for data manipulation
library(ggplot2)    # for pretty charts
library(ggcorrplot) # unnecessary but pretty correlation plot
library(NbClust)    # helps estimate optimum number of clusters

### Read the data 
df <- read.csv("clustering.csv")
head(df)

df <- select (df,-c(Music, Movies, Slow.songs.or.fast.songs))

cormat <- round(cor(df), 2)
ggcorrplot(cormat, hc.order = TRUE, type = "lower",  lab = FALSE)

#PCA
df.pr <- prcomp(df, center = TRUE, scale = TRUE)
summary(df.pr)

### Scree plot

```{r scree}
screeplot(df.pr,
          type = "l",
          npcs = 12,
          main = "Screeplot of PCs - The overall dataset")
abline(h = 1, col = "red", lty = 5)
legend(
  "topright",
  legend = c("Eigenvalue = 1"),
  col = c("red"),
  lty = 5,
  cex = 0.6
)
```

# extract only the first four principal components
components <- data.frame(df.pr$x[, 1:4])

head(components)

plot(components, pch = 19, col = rgb(0,0,0,0.5))

summary(components)


plot(
  df.pr$rotation[, 1],
  df.pr$rotation[, 2],
  col = "lightblue", pch = 19, cex = 2,
  xlab = "PC1 (74.3%)",
  ylab = "PC2 (15.7%)",
  main = "Unrotated PC1 / PC2 - plot",
  text(df.pr$rotation, labels = rownames(df.pr$rotation), cex = 0.75, font = 1)
)


wss <- (nrow(df) - 1) * sum(apply(df, 2, var))
for (i in 2:15)
  wss[i] <-
  sum(kmeans(
    df,
    centers = i,
    nstart = 25,
    iter.max = 1000
  )$withinss)
plot(1:15,
     wss,
     type = "b",
     xlab = "Number of Clusters",
     ylab = "Within groups sum of squares")


nClust = NbClust(df, 
                 distance = "euclidean", 
                 method = "kmeans", 
                 min.nc = 2, 
                 max.nc = 15)


# Apply k-means with k=2
k <- kmeans(df,
            centers = 2,
            nstart = 25,
            iter.max = 1000)

plot(components, col = k$clust, pch = 16)

cluster2.data <- NULL
cluster2.data$id <- as.character(df$id)
cluster2.data$Satisfaction <- as.integer(components$OverallSatisfaction)
cluster2.data$PC1 <- components$PC1
cluster2.data$PC2 <- components$PC2
cluster2.data$kclust <- as.factor(k$clust)
cluster2.data <- data.frame(cluster2.data)


df$cluster
df$cluster <- k$cluster
df



