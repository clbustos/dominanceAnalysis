context("da with esoph example (glm)")

data(esoph)
esoph.1<-esoph
# Esoph controls are corrected based on PR#17964. Here I provide a correct version for older R

esoph.1$ncontrols<-c(40,10,6,5,27,7,4,7,2,1,2,1,0,1,2,60,13,7,8,35,20,13,8,11,6,2,1,1,3,2,45,18,10,4,32,17,10,2,13,8,4,2,0,1,1,0,47,19,9,2,31,15,13,3,9,7,3,0,5,1,1,1,43,10,5,2,17,7,4,7,8,1,0,1,1,0,0,17,4,2,3,2,3,0,0,0,0,0)

glm.esoph.0 <- glm(cbind(ncases,ncontrols) ~ 1, data=esoph.1, family = "binomial")

glm.esoph <- glm(cbind(ncases,ncontrols) ~ agegp + alcgp + tobgp, data=esoph.1, family = "binomial")
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
  expect_equal(base.fits["agegp+alcgp+tobgp",c("r2.m","r2.cs","r2.n")], c(r2.m=0.591,r2.cs=0.961, r2.n=0.965), tolerance=0.001)
})
