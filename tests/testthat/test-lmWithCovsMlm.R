context("multivariate dominance analysis")
# Taken from Azen & Bodescu (2006)
library(car)
# Original data is available with:
#library(heplots)
#cor.m<-cor(Rohwer[Rohwer[,1]==1,2+c(7,8,1,2,3)])
cor.m<-matrix(c(
1.0000000, 0.7951377, 0.2617168, 0.6720053, 0.3390278,
0.7951377, 1.0000000, 0.3341037, 0.5876337, 0.3404206,
0.2617168, 0.3341037, 1.0000000, 0.3703162, 0.2114153,
0.6720053, 0.5876337, 0.3703162, 1.0000000, 0.3548077,
0.3390278, 0.3404206, 0.2114153, 0.3548077, 1.0000000),
5,5,
byrow = T,
dimnames = list(
  c("na","ss","SAT","PPVT","Raven"),
  c("na","ss","SAT","PPVT","Raven")))

lwith<-mlmWithCov(cbind(na,ss)~SAT+PPVT+Raven,cor.m)
da.mlm<-dominanceAnalysis(lwith)
test_that("mlmWithCov() returns correct results ", {
  # We use directly the data from Rohwer, as given by package heplots
  expect_equal(lwith$r.squared.xy,0.494,tolerance=0.001,scale=1)
  expect_equal(lwith$p.squared.yx,0.256,tolerance=0.001,scale=1)
})

test_that("a dominance analysis based on mlmWithCov gives correct results",{
  expected.r2.xy<-c(SAT=0.0583,PPVT=0.3705,Raven=0.0654)
  expected.p2.yx<-c(SAT=0.0331,PPVT=0.1895,Raven=0.0334)
  expect_equal(da.mlm$contribution.average$r.squared.xy, expected.r2.xy, tolerance=0.001, scale=1)
  expect_equal(da.mlm$contribution.average$p.squared.yx, expected.p2.yx, tolerance=0.001, scale=1)
})

test_that("report methods for multivariate dominance analysis are correct",{
  s.da.mlm<-summary(da.mlm)
  expect_output(print(da.mlm),"SAT,Ravn")
  expect_equal(length(s.da.mlm) ,2)
})
