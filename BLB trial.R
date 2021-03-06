#input data here
data <- rnorm(10000,0,1)

#parameters 
n <- length(data)
b <- n^.5
s <- 100
r <- 10000

subsamples <- matrix(,nrow=s,ncol=trunc(b))
subsamples.means <- c()
quality.estimates <- matrix(,nrow=s,ncol=2)
stats.matrix <- matrix(,nrow=s,ncol=r)

for (i in 1:s) {
  subsamples[i,] <- sample(data, b,replace=F)
  subsamples.means[i] <- mean(subsamples[i,])
  stats <- c()
  for (j in 1:r) {
    resample.vector <- rmultinom(1,n,rep(1/b,b))
    stats[j] <- sum(resample.vector*subsamples[i,])/n
  }
  stats.matrix[i,] <- stats
  quality.estimates[i,] <- quantile(stats,c(.025,.975))
}

final.quality.estimate <- c(mean(quality.estimates[,1]),mean(quality.estimates[,2]))
final.quality.estimate

#plotting histograms from each subsample
par(mfrow=c(3,5))
for (i in 1:s) {
  hist(stats.matrix[i,])
  abline(v=c(quality.estimates[i,1],quality.estimates[i,2],mean(stats.matrix[i,])),col='blue')
  abline(v=subsamples.means[i],col='red')
  print(abs(subsamples.means[i]-mean(stats.matrix[i,])))
}



#using the known sampling distribution of mean
#redrawing random samples
stats.known <- c()
for (i in 1:r) {
  data.test <- rnorm(10000,0,1)
  stats.known[i] <- mean(data.test)
}
hist(stats.known)
quantile(stats.known,c(0.025,.975))

#regular bootstrap with n=100
stats.known <- c()
data.test <- rnorm(10000,0,1)
for (i in 1:r) {
  data.boot <- sample(data.test,10000,replace=T)
  stats.known[i] <- mean(data.boot)
}
hist(stats.known)
quantile(stats.known,c(0.025,.975))
