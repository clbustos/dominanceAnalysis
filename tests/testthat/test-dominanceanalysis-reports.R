context("test-dominanceanalysis-reports")
x1<-rnorm(100)
x2<-0.5*x1+rnorm(100)
x3<-2*x1+x2+rnorm(100)
y<-x1+x2+x3+rnorm(100)

test_that("dominanceAnalysis print and summary methods words", {
  da<-dominanceAnalysis(lm(y~x3+x2+x1))
  expect_output(print(da),"x2,x1")
  expect_equal(length(summary(da)$r2$average.contribution), 3)
  expect_equal(dim(summary(da)$r2$summary.matrix), c(10,6))
})

test_that("dominanceAnalysis print and summary methods words when constants used", {
  da<-dominanceAnalysis(lm(y~x3+x2+x1),constants = "x3")
  s.da<-summary(da)
  expect_output(print(da),"Constants: x3")
  expect_equal(dim(s.da$r2$summary.matrix), c(5,5))
  expect_output(print(s.da),"Average level 1")
})
