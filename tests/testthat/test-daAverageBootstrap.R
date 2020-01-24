context("Average bootstrap")

test_that("should have correct sample values for lm", {
  x1      <- rnorm(1000)
  x2      <- rnorm(1000)
  x3      <- rnorm(1000)
  x4      <- rnorm(1000)
  y1      <- 10*x1+8*x2+6*x3+4*x4+rnorm(1000)
  y2      <- x1+x2+x3+x4+rnorm(1000)

  d.f     <<- data.frame(xa=x1,xb=x2,xc=x3,xd=x4,y=y1,y2=y2)
  lm.1    <- lm(y~xa+xb+xc+xd, data = d.f)
  set.seed(12345)
  bs.da.1 <- bootAverageDominanceAnalysis(lm.1, R=2)
  expect_equivalent(names(bs.da.1),c("boot","preds","fit.functions","R","eg","terms"))
  expect_equivalent(bs.da.1$R,2)
  expect_gt(abs(bs.da.1$boot$t[1,1]-bs.da.1$boot$t[2,1]),0)
  sum.bs.da.1<-summary(bs.da.1)
  expect_equal(colnames(sum.bs.da.1$r2),c("Var","Fit.Index","original","bs.E","bias","bs.SE"))
  expect_equal(sum.bs.da.1$r2$Var, c("xa","xb","xc","xd"))
  expect_output(print(sum.bs.da.1),"Resamples:  2")
})

test_that("should work for glm", {
  x1      <- rnorm(1000)
  x2      <- rnorm(1000)
  x3      <- rnorm(1000)
  x4      <- rnorm(1000)
  y1      <- (2*x1+8*x2+2*x3+1.5*x4)/10
  y<-exp(y1)/(1+exp(y1))

  d.f     <<- data.frame(xa=x1,xb=x2,xc=x3,xd=x4,y=as.numeric(runif(1000)<y))
  glm.1    <- glm(y~xa+xb+xc+xd, data = d.f, family=binomial)
  set.seed(12345)
  bs.da.1 <- bootAverageDominanceAnalysis(glm.1, R=2)
  expect_gt(sum(apply(bs.da.1$boot$t,2,sd)),0)

})


test_that("should have correct values using terms",{

  lm.mtcars<-lm(mpg~.,mtcars)
  terms<-c(motor='cyl+disp+hp+carb',trans='drat+am+gear',other='wt+qsec+vs+am')
  da.mtcars<-bootAverageDominanceAnalysis(lm.mtcars,R=2,terms=terms)
  expect_equal(da.mtcars$terms,terms)
  expect_equal(as.character(da.mtcars$eg[,1])   ,as.character(terms))

  s.da<-summary(da.mtcars)
  expect_equal(as.character(s.da$r2[,1]), as.character(names(terms)))
})