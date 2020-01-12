context("Dominance analysis with dynlm")

library(dynlm)

histfm <- dynlm(d(logm1) ~ d(L(loggnp, 2)) + d(interest) + season(logm1, ref = 4),
                data = M1Germany, start = c(1961, 1), end = c(1990, 2))

da.dynlm<-dominanceAnalysis(histfm)

test_that("retrieves a dominanceAnalysis object", {
  expect_s3_class(dominanceAnalysis(histfm), "dominanceAnalysis")
})


test_that("should have correct predictors", {
  expect_equal(da.dynlm$predictors, c("d(L(loggnp, 2))", "d(interest)", "season(logm1, ref = 4)" ))
})

test_that("should constants be null", {
  expect_null(da.dynlm$constants)
})

test_that("should terms be null", {
  expect_null(da.dynlm$terms)
})

test_that("should fit.functions be 'r2'", {
  expect_equal(da.dynlm$fit.functions,c("r2"))
})

test_that("base fits should be correct",{
  base.fits<-da.dynlm$fits$base.fits
  expect_equal(base.fits["1",c("r2")], c(0), tolerance=0.001)
  expect_equal(base.fits["d(L(loggnp, 2))+d(interest)+season(logm1, ref = 4)",c("r2")], 0.89, tolerance=0.001)
})
