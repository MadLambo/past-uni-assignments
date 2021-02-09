library(dplyr)      # for data manipulation
library(ggplot2)    # for pretty charts
library(ggcorrplot) # unnecessary but pretty correlation plot
library(NbClust)    # helps estimate optimum number of clusters

### Read the data 
df <- read.csv("clustering.csv")
head(df)

musicsNdemo  <- df %>%select(1:19,32:41)
moviesNdemo  <- df %>%select(20:31,32:41)

### Generate a correlation plot 
cormat <- round(cor(musicsNdemo), 2)
ggcorrplot(cormat, hc.order = TRUE, type = "lower",  lab = FALSE)

#PCA
musicsNdemo.pr <- prcomp(musicsNdemo, center = TRUE, scale = TRUE)
summary(musicsNdemo.pr)

### Scree plot

```{r scree}
screeplot(musicsNdemo.pr,
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
cumpro <- cumsum(musicsNdemo.pr$sdev ^ 2 / sum(musicsNdemo.pr$sdev ^ 2))


# the plot
plot(cumpro[0:12],
     type = "b",
     xlab = "PC #",
     ylab = "Explained variance",
     main = "Cumulative variance")
abline(v = 4, col = "blue", lty = 5)
abline(h = 0.90, col = "blue", lty = 5)
legend(
  "topleft",
  legend = c("Cut-off @ PC4"),
  col = c("blue"),
  lty = 5,
  cex = 0.6
)

# extract only the first two principal components
components <- data.frame(musicsNdemo.pr$x[, 1:4])

head(components)

plot(components, pch = 19, col = rgb(0,0,0,0.5))

```{r plotPCs}

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



######## - Part 2

wsscomb <- (nrow(musicsNdemo) - 1) * sum(apply(musicsNdemo, 2, var))
for (i in 2:15)
  wsscomb[i] <-
  sum(kmeans(
    components,
    centers = i,
    nstart = 25,
    iter.max = 1000
  )$withinss)
plot(1:15,
     wsscomb,
     type = "b",
     xlab = "Number of Clusters",
     ylab = "Within groups sum of squares")

nClustcomb = NbClust(musicsNdemo, 
                     distance = "euclidean", 
                     method = "kmeans", 
                     min.nc = 2, 
                     max.nc = 15)

# Apply k-means with k=2
k <- kmeans(musicsNdemo,
            centers = 2,
            nstart = 25,
            iter.max = 1000)

plot(components, col = k$clust, pch = 16, main = "Music + Demographics Data Clusters")


cluster3.data <- NULL
cluster3.data$id <- as.character(df$id)
cluster3.data$Satisfaction <- as.integer(musicsNdemo$OverallSatisfaction)
cluster3.data$PC1 <- components$PC1
cluster3.data$PC2 <- components$PC2
cluster3.data$kclust <- as.factor(k$clust)
cluster3.data <- data.frame(cluster3.data)


musicsNdemo$cluster
musicsNdemo$cluster <- k$cluster



#### Movies + Demo 

### Generate a correlation plot 
cormat <- round(cor(moviesNdemo), 2)
ggcorrplot(cormat, hc.order = TRUE, type = "lower",  lab = FALSE)

#PCA
moviesNdemo.pr <- prcomp(moviesNdemo, center = TRUE, scale = TRUE)
summary(moviesNdemo.pr)

### Scree plot

```{r scree}
screeplot(moviesNdemo.pr,
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
cumpro <- cumsum(moviesNdemo.pr$sdev ^ 2 / sum(moviesNdemo.pr$sdev ^ 2))

# the plot
plot(cumpro[0:12],
     type = "b",
     xlab = "PC #",
     ylab = "Explained variance",
     main = "Cumulative variance")
abline(v = 4, col = "blue", lty = 5)
abline(h = 0.90, col = "blue", lty = 5)
legend(
  "topleft",
  legend = c("Cut-off @ PC4"),
  col = c("blue"),
  lty = 5,
  cex = 0.6
)


# extract only the first two principal components
components <- data.frame(moviesNdemo.pr$x[, 1:4])

head(components)

plot(components, pch = 19, col = rgb(0,0,0,0.5))


```{r plotPCs}

plot(
  moviesNdemo.pr$rotation[, 1],
  moviesNdemo.pr$rotation[, 2],
  col = "lightblue", pch = 19, cex = 2,
  xlab = "PC1 (74.3%)",
  ylab = "PC2 (15.7%)",
  main = "Unrotated PC1 / PC2 - plot",
  text(moviesNdemo.pr$rotation, labels = rownames(moviesNdemo.pr$rotation), cex = 0.75, font = 1)
)


######## - Part 2

# Determine number of clusters
wss <- (nrow(moviesNdemo) - 1) * sum(apply(moviesNdemo, 2, var))
for (i in 2:15)
  wss[i] <-
  sum(kmeans(
    moviesNdemo,
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
nClust = NbClust(moviesNdemo, 
                 distance = "euclidean", 
                 method = "kmeans", 
                 min.nc = 2, 
                 max.nc = 15)


k <- kmeans(music.data,
            centers = 3,
            nstart = 25,
            iter.max = 1000)

plot(components, col = k$clust, pch = 16, main = "Music Data Clusters")


cluster4.data <- NULL
cluster4.data$id <- as.character(df$id)
cluster4.data$Satisfaction <- as.integer(moviesNdemo$OverallSatisfaction)
cluster4.data$PC1 <- components$PC1
cluster4.data$PC2 <- components$PC2
cluster4.data$kclust <- as.factor(k$clust)
cluster4.data <- data.frame(cluster4.data)


moviesNdemo$cluster
moviesNdemo$cluster <- k$cluster

##Converting into CSV files
write.csv(musicsNdemo, "Music and Demographics.csv")


moviesNdemo
write.csv(moviesNdemo, "Movie and Demographics.csv")


