context("da with esoph example (glm)")

data(esoph)
glm.esoph.0 <- glm(cbind(ncases,ncontrols) ~ 1, data=esoph, family = "binomial")

glm.esoph <- glm(cbind(ncases,ncontrols) ~ agegp + alcgp + tobgp, data=esoph, family = "binomial")
da.esoph <- dominanceAnalysis(glm.esoph)

test_that("should have correct predictors", {
  expect_equal(da.esoph$predictors, c("agegp","alcgp","tobgp"))
})

test_that("should constants be null", {
  expect_null(da.esoph$constants)
})

test_that("should terms be null", {
  expect_null(da.esoph$terms)
})

test_that("should fit.functions be 'r2'", {
  expect_equal(da.esoph$fit.functions,c("r2.m","r2.cs","r2.n","r2.e"))
})

test_that("base fits should be correct",{
  base.fits<-da.esoph$fits$base.fits
  expect_equal(base.fits["1",c("r2.m","r2.cs","r2.n")], c(r2.m=0,r2.cs=0,r2.n=0), tolerance=0.001)
  expect_equal(base.fits["agegp+alcgp+tobgp",c("r2.m","r2.cs","r2.n")], c(r2.m=0.462,r2.cs=0.860,r2.n=0.872), tolerance=0.001)
})
