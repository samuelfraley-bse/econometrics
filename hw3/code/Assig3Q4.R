set.seed(1010)
M<-100
lower <- numeric(M) 
upper <- numeric(M)
x2<-runif(50,0,20)

for(i in 1:M) {
  y <- 10+5*x2+rnorm(50, mean = 0, sd = 6) 
  model<-lm(y~x2)
  b2<-coef(model)[[2]]
  varb2 <- vcov(model)[2, 2]
  se2<-sqrt(  varb2)
  lower[i] <- b2 - qt(0.025,48, lower.tail = F) * se2 
  upper[i] <- b2 + qt(0.025,48, lower.tail = F) * se2
}
CIs <- cbind(lower, upper)

IDg <- which((CIs[1:M, 1] <= 5 & 5 <= CIs[1:M, 2]))
length(IDg)
IDb <- which(!(CIs[1:M, 1] <= 5 & 5 <= CIs[1:M, 2]))

ratiog<-(length(IDg)/M)*100
ratiog

plot(0,
     xlim = c(4, 6),
     ylim = c(1, 100),
     ylab = "Samples",
     xlab = expression(beta[2]),
     main = "Confidence Intervals")
abline(v = 5, lty = 2)

colors <- rep(gray(0.6), 100) 
colors[IDb] <- "red"

for(j in 1:100) {
  lines(c(CIs[j, 1], CIs[j, 2]), c(j, j),
        col = colors[j],
        lwd = 2)
}


