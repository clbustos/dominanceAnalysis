context("da with attitudes example")

lm.attitude<-lm(rating~complaints+privileges+learning+raises+critical+advance,attitude)
da.attitude<-dominanceAnalysis(lm.attitude)

test_that("should have correct predictors", {
  expect_equal(da.attitude$predictors, c("complaints","privileges","learning","raises","critical","advance"))
})

test_that("should constants be null", {
  expect_null(da.attitude$constants)
})

test_that("should terms be null", {
  expect_null(da.attitude$terms)
})

test_that("should fit.functions be 'r2'", {
  expect_equal(da.attitude$fit.functions,"r2")
})

test_that("should complete dominance matrix be complete",{
  cdm<-complete.dominance.matrix<-dominanceMatrix(da.attitude,type = "complete")
  expect_equal(cdm[1,],c(complaints=0.5,privileges=1,learning=1,raises=1,critical=1,advance=1))
})
