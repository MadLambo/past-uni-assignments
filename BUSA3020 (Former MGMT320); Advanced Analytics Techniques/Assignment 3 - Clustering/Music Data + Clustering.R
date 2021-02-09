library(dplyr)      # for data manipulation
library(ggplot2)    # for pretty charts
library(ggcorrplot) # unnecessary but pretty correlation plot
library(NbClust)    # helps estimate optimum number of clusters

### Read the data 
df <-- read.csv("clustering.csv")
head(df)

### Extract the music data away from the main data
music.data <- data.frame (df$Music, df$Slow.songs.or.fast.songs, df$Dance, df$Folk, df$Country, df$Classical.music, df$Musical, df$Rock, df$Metal.or.Hardrock, df$Punk, df$Hiphop..Rap, df$Reggae..Ska, df$Swing..Jazz, df$Rock.n.roll, df$Alternative, df$Latino, df$Techno..Trance, df$Opera, df$Pop)

### Question 1

### Generate a correlation plot 
cormat <- round(cor(music.data), 2)
ggcorrplot(cormat, hc.order = TRUE, type = "lower",  lab = FALSE)

#PCA
musicdata.pr <- prcomp(music.data, center = TRUE, scale = TRUE)
summary(musicdata.pr)

  ### Scree plot
  
  ```{r scree}
  screeplot(musicdata.pr,
            type = "l",
            npcs = 12,
            main = "Screeplot of PCs - Just for Music Data")
  abline(h = 1, col = "red", lty = 5)
  legend(
    "topright",
    legend = c("Eigenvalue = 1"),
    col = c("red"),
    lty = 5,
    cex = 0.6
  )
```

# Calculate cumulative proportion for charting
cumpro <- cumsum(musicdata.pr$sdev ^ 2 / sum(musicdata.pr$sdev ^ 2))

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

# extract only the first two principal components
components <- data.frame(musicdata.pr$x[, 1:2])

head(components)

plot(components, pch = 19, col = rgb(0,0,0,0.5))

```{r plotPCs}

plot(
  musicdata.pr$rotation[, 1],
  musicdata.pr$rotation[, 2],
  col = "lightblue", pch = 19, cex = 2,
  xlab = "PC1 (74.3%)",
  ylab = "PC2 (15.7%)",
  main = "Unrotated PC1 / PC2 - plot",
  text(musicdata.pr$rotation, labels = rownames(musicdata.pr$rotation), cex = 0.75, font = 1)
)


######## - Question 2

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
nClust = NbClust(music.data, 
                 distance = "euclidean", 
                 method = "kmeans", 
                 min.nc = 2, 
                 max.nc = 15)

# Apply k-means with k=3
k <- kmeans(music.data,
            centers = 3,
            nstart = 25,
            iter.max = 1000)

plot(components, col = k$clust, pch = 16, main = "Music Data Clusters")


cluster1.data <- NULL
cluster1.data$id <- as.character(df$id)
cluster1.data$Satisfaction <- as.integer(music.data$OverallSatisfaction)
cluster1.data$PC1 <- components$PC1
cluster1.data$PC2 <- components$PC2
cluster1.data$kclust <- as.factor(k$clust)
cluster1.data <- data.frame(cluster1.data)


music.data$cluster
music.data$cluster <- k$cluster


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

#Cross Tabulation  of the results
table(cluster1.data$hclust, cluster1.data$kclust)  

#plotting the results 
music.data$Pc1 <- cluster1.data$PC1
music.data$Pc2 <- cluster1.data$PC2

music.data$kclust <- cluster1.data$kclust
music.data$hclust <- cluster1.data$hclust



ggplot(data = music.data, aes(Pc1, Pc2)) + 
  geom_point(shape = music.data$kclust, colour = music.data$hclust) +
  theme_classic()

write.csv(music.data, "Music.csv")



