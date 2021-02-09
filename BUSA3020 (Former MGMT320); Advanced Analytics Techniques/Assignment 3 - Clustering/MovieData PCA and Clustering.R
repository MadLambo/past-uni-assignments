library(dplyr)      # for data manipulation
library(ggplot2)    # for pretty charts
library(ggcorrplot) # unnecessary but pretty correlation plot
library(NbClust)    # helps estimate optimum number of clusters

### Read the data 
df <-- read.csv("clustering.csv")
head(df)

movie.data <- data.frame(df$Movies, df$Horror, df$Thriller, df$Comedy, df$Romantic, df$Sci.fi, df$War, df$Fantasy.Fairy.tales, df$Animated, df$Documentary, df$Western, df$Action)

### Generate a correlation plot 
cormat <- round(cor(movie.data), 2)
ggcorrplot(cormat, hc.order = TRUE, type = "lower",  lab = TRUE)

#PCA
moviedata.pr <- prcomp(movie.data, center = TRUE, scale = TRUE)
summary(moviedata.pr)

### Scree plot

```{r scree}
screeplot(moviedata.pr,
          type = "l",
          npcs = 12,
          main = "Screeplot of PCs - Just for Movie Data")
abline(h = 1, col = "red", lty = 5)
legend(
  "topright",
  legend = c("Eigenvalue = 1"),
  col = c("red"),
  lty = 5,
  cex = 0.
  
  # Calculate cumulative proportion for charting
  cumpro <- cumsum(moviedata.pr$sdev ^ 2 / sum(moviedata.pr$sdev ^ 2))
  
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
  moviecomponents <- data.frame(moviedata.pr$x[, 1:2])
  
  head(moviecomponents)
  
  plot(moviecomponents, pch = 19, col = rgb(0,0,0,0.5))
  
  
  ```{r plotPCs}
  
  plot(
    moviedata.pr$rotation[, 1],
    moviedata.pr$rotation[, 2],
    col = "lightblue", pch = 19, cex = 2,
    xlab = "PC1 (74.3%)",
    ylab = "PC2 (15.7%)",
    main = "Unrotated PC1 / PC2 - plot"
  )
  
  ######## - Question 2
  
  # Determine number of clusters
  wss <- (nrow(movie.data) - 1) * sum(apply(movie.data, 2, var))
  for (i in 2:15)
    wss[i] <-
    sum(kmeans(
      movie.data,
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
  
  nClust = NbClust(movie.data, 
                   distance = "euclidean", 
                   method = "kmeans", 
                   min.nc = 2, 
                   max.nc = 15)
  
  # Apply k-means with k=3
  k <- kmeans(movie.data,
              centers = 3,
              nstart = 25,
              iter.max = 1000)
  
  plot(moviecomponents, col = k$clust, pch = 16, main = "Movie Data Clusters")
  
  cluster2.data <- NULL
  cluster2.data$id <- as.character(df$id)
  cluster2.data$Satisfaction <- as.integer(moviecomponents$OverallSatisfaction)
  cluster2.data$PC1 <- moviecomponents$PC1
  cluster2.data$PC2 <- moviecomponents$PC2
  cluster2.data$kclust <- as.factor(k$clust)
  cluster2.data <- data.frame(cluster2.data)
  
  
  movie.data$cluster
  movie.data$cluster <- k$cluster
  movie.data
  
  summary(cluster2.data)
  
  distances <- dist(movie.data)
  
  str(distances)
  
  h <- hclust(distances, method = "ward.D2")
  plot(h) #the dendrogram
  
  hclust <- cutree(h, 3)
  
  summary(hclust)
  
  
  cluster2.data$hclust <- as.factor(hclust)
  
  summary(cluster2.data)
  
  #### Compare Solutions 
  
  #Cross Tabulation  of the results
  table(cluster2.data$hclust, cluster2.data$kclust)  
  
  
  movie.data$Pc1 <- cluster2.data$PC1
  movie.data$Pc2 <- cluster2.data$PC2
  
  movie.data$kclust <- cluster2.data$kclust
  movie.data$hclust <- cluster2.data$hclust
  
  
  
  ggplot(data = movie.data, aes(Pc1, Pc2)) + 
    geom_point(shape = movie.data$kclust, colour = movie.data$hclust) +
    theme_classic()
  
  write.csv(movie.data, "Movies.csv")
  
  
  