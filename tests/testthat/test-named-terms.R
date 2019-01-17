context("da with named terms")

lm.mtcars<-lm(mpg~.,mtcars)
terms<-c(motor='cyl+disp+hp+carb',trans='drat+am+gear',other='wt+qsec+vs+am')
da.mtcars<-dominanceAnalysis(lm.mtcars,terms=terms)

test_that("should have correct predictors", {
  expect_equal(da.mtcars$predictors, terms)
})

test_that("should have correct terms", {
  expect_equal(da.mtcars$terms, terms)
})

test_that("Average contribution have correct names",{
  expected<-c(motor=0.328,trans=0.178, other=0.363)
  expect_equal(averageContribution(da.mtcars)$r2,expected,tolerance=0.01)
})