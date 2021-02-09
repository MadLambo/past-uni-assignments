library(dplyr)      # for data manipulation
library(ggplot2)    # for pretty charts
library(ggcorrplot) # unnecessary but pretty correlation plot
library(NbClust)    # helps estimate optimum number of clusters

### Read the data 
df <- read.csv("clustering.csv")
head(df)

cormat <- round(cor(df), 2)
ggcorrplot(cormat, hc.order = TRUE, type = "lower",  lab = FALSE)

#PCA
q1.pr <- prcomp(df, center = TRUE, scale = TRUE)
summary(q1.pr)

### Scree plot

```{r scree}
screeplot(q1.pr,
          type = "l",
          npcs = 12,"
          main = "Screeplot of PCs - The overall dataset")
abline(h = 1, col = "red", lty = 5)
legend(
  "topright",
  legend = c("Eigenvalue = 1"),
  col = c("red"),
  lty = 5,
  cex = 0.6
  )
)
```


# extract only the first four principal components
components <- data.frame(q1.pr$x[, 1:2])

head(components)

plot(components, pch = 19, col = rgb(0,0,0,0.5))

summary(components)


plot(
  q1.pr$rotation[, 1],
  q1.pr$rotation[, 2],
  col = "lightblue", pch = 19, cex = 2,
  xlab = "PC1 (74.3%)",
  ylab = "PC2 (15.7%)",
  main = "Unrotated PC1 / PC2 - plot",
  text(q1.pr$rotation, labels = rownames(q1.pr$rotation), cex = 0.75, font = 1)
)