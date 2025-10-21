#Data for slide3(33)
n<- 35
set.seed(1234)
x2<-runif(n,0,30)
x3<-runif(n,0,30)
x4<-x3
y<-10+0.5*x2+0.5*x3+0.5*x4+rnorm(n,0,4)
