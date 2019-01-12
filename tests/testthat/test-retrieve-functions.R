context("testing retrieve functions")

lm.attitude<-lm(rating~complaints+privileges+learning,attitude)
da.attitude<-dominanceAnalysis(lm.attitude)

test_that("retrieve functions doesn't work on anything but dominanceAnalysis objects",{
  x<-list()
  expect_error(getFits(x),"should be a dominanceAnalysis")
  expect_error(contributionByLevel(x),"should be a dominanceAnalysis")
  expect_error(averageContribution(x),"should be a dominanceAnalysis")
})
test_that("getFits retrieve fits", {
  expected<-matrix(c(0.681, 0.182 ,  0.389,
                     NA   , 0.002 ,  0.027,
                     0.501, NA    ,  0.226,
                     0.319, 0.019 ,  NA   ,
                     NA   , NA    ,  0.032,
                     NA   , 0.007 ,  NA   ,
                     0.307, NA    ,  NA   ,
                     NA   , NA    , NA
                     ), 8,3,byrow = T,
                   dimnames = list(c("1","complaints","privileges","learning",
                                     "complaints+privileges",
                                     "complaints+learning",
                                     "privileges+learning",
                                     "complaints+privileges+learning"),
                                   c("complaints","privileges","learning")))
  fits<-getFits(da.attitude)
  expect_named(fits,"r2")
  expect_equal(fits$r2,expected,tolerance=0.001)
})

test_that("print for a getFits object", {
  fits<-getFits(da.attitude)
  expect_output(print(fits),"Dominance analysis fit matrices")
  expect_output(print(fits),"r2")
  expect_output(print(fits),"0.681.+0.182.+0.389")
})

test_that("contributionByLevel retrieve average contributions", {
  cbl<-contributionByLevel(da.attitude)
  expect_named(cbl,"r2")
  expected<-data.frame(level = c(0, 1, 2), complaints = c(0.681, 0.410, 0.307), privileges = c(0.182, 0.0101, 0.007), learning = c(0.389, 0.126, 0.0320))
  expect_equal(cbl$r2,expected,tolerance=0.01)
})

test_that("print for a daContributionByLevel object", {
  cbl<-contributionByLevel(da.attitude)
  expect_output(print(cbl),"Contribution by level")
  expect_output(print(cbl),"0.+0.681.+0.182.+0.389")
})

test_that("averageContribution retrieve average contributions", {
  ac<-averageContribution(da.attitude)
  expect_named(ac,"r2")
  expect_equal(ac$r2,c(complaints=0.466,privileges=0.066, learning=0.182),tolerance=0.001)
})

test_that("print for a daAverageContribution object", {
  ac<-averageContribution(da.attitude)
  expect_output(print(ac),"Average Contribution by predictor")
  expect_output(print(ac),"r2.+0.466.+0.066.+0.182")
})
