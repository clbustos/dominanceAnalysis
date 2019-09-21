context("Dominance analysis with dynlm")

library(dynlm)

histfm <- dynlm(d(logm1) ~ d(L(loggnp, 2)) + d(interest) + season(logm1, ref = 4),
                data = M1Germany, start = c(1961, 1), end = c(1990, 2))


test_that("retrieves a dominanceAnalysis object", {
  expect_s3_class(dominanceAnalysis(histfm), "dominanceAnalysis")

})