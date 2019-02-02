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

test_that("Contribution by level have correct names",{
  expect_equal(names(contributionByLevel(da.mtcars)$r2),c('level','motor','trans','other'))
})


test_that("getFits have correct colnames and rownames",{
  expected.colnames<-c("motor","trans","other")
  expected.rownames<-c("1","motor","trans","other","motor+trans","motor+other","trans+other","motor+trans+other")
  da.fits<-getFits(da.mtcars)$r2
  expect_equal(as.character(colnames(da.fits)),expected.colnames)
  expect_equal(rownames(da.fits),expected.rownames)

})

test_that("dominanceMatrix have correct colnames and rownames",{
  da.dm<-dominanceMatrix(da.mtcars,"complete",fit.functions = "r2")
  expected.names<-c("motor","trans","other")
  expect_equal(as.character(colnames(da.dm)), expected.names)
  expect_equal(as.character(rownames(da.dm)), expected.names)
})

test_that("dominanceBriefing have correct colnames and rownames",{
  da.dm<-dominanceBriefing(da.mtcars,abbrev = FALSE)
  expected=data.frame(complete     = c("trans","","motor,trans"),
                      conditional  = c("trans","","motor,trans"),
                      general      = c("trans","","motor,trans"),
                      row.names=c("motor","trans","other"))
  expect_named(da.dm,"r2")
  expect_equal(da.dm$r2, expected)
})
