context("da with GasolineYield example (betareg)")
library(betareg)
data("GasolineYield", package = "betareg")
gy_logit <- betareg(yield ~ batch + temp, data = GasolineYield, model=TRUE,link="loglog")


test_that("fit a beta regression without model=TRUE should fail", {
  expect_error(dominanceAnalysis(betareg(yield ~ batch + temp, data = GasolineYield, model=F) ),"model=TRUE")
})

da.gy <- dominanceAnalysis(gy_logit)


test_that("should have correct predictors", {
  expect_equal(da.gy$predictors, c("batch","temp"))
})

test_that("should constants be null", {
  expect_null(da.gy$constants)
})

test_that("should terms be null", {
  expect_null(da.gy$terms)
})

test_that("should fit.functions be 'r2'", {
  expect_equal(da.gy$fit.functions,c("r2.cs","r2.pseudo","r2.m"))
})

test_that("base fits should be correct",{
  base.fits<-da.gy$fits$base.fits
  expect_equal(base.fits["1",c("r2.cs","r2.pseudo","r2.m")], c(r2.cs=0,r2.pseudo=0,r2.m=0), tolerance=0.001)
  expect_equal(base.fits["batch+temp",c("r2.cs","r2.pseudo","r2.m")], c(r2.cs=.986,r2.pseudo=.985,r2.m=-2.387), tolerance=0.001)
})

test_that("using different estimator should provide different result",{
  gy_logit_2 <- betareg(yield ~ batch + temp, data = GasolineYield, model=TRUE,link="loglog",type = "BC")
  da.gy2 <- dominanceAnalysis(gy_logit_2)
  base.fits<-da.gy2$fits$base.fits
  expect_equal(base.fits["1",c("r2.cs","r2.pseudo","r2.m")], c(r2.cs=0,r2.pseudo=0,r2.m=0), tolerance=0.001)
  expect_equal(base.fits["batch+temp",c("r2.cs","r2.pseudo","r2.m")], c(r2.cs=.984,r2.pseudo=.985,r2.m=-2.332), tolerance=0.001)


})