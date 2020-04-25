context("test-dominance-analysis-on-empty-set")

test_that("Model without predictors", {
  y<-rnorm(100)
  expect_error(dominanceAnalysis(lm(y~1)), "You should have at least two predictors in a dominance analysis")
})

test_that("Model with only one predictor", {
  y<-rnorm(100)
  x<-rnorm(100)
  expect_error(dominanceAnalysis(lm(y~x)), "You should have at least two predictors in a dominance analysis")}
)

test_that("Model with two grouped predictors", {
  y<-rnorm(100)
  x1<-rnorm(100)
  x2<-rnorm(100)
  expect_error(dominanceAnalysis(lm(y~x1+x2), terms=c("x1+x2")), "You should have at least two predictors in a dominance analysis")}
)
