context("dominanceMatrix method")

test_that("should fail on a matrix without colnames", {
  mm<-matrix(c(3,2,1,
               5,4,2,
               7,5,1),3,3,byrow = T)
  expect_error(dominanceMatrix(mm),"should have colnames")
})
test_that("calculates dominance on a matrix", {
  mm<-matrix(c(3,2,1,
               5,4,2,
               7,5,1),3,3,byrow = T)
  colnames(mm)<-c("a","b","c")
  dm<-dominanceMatrix(mm)
  expected<-matrix(c(0.5,1,1,0,0.5,1,0,0,0.5),3,3,byrow=T,dimnames = list(c("a","b","c"),c("a","b","c")))
  expect_equal(dm,expected)
})

test_that("calculates dominance on data.frame", {
  df.1<-data.frame(a=c(3,5,6),b=c(2,4,5),c=c(1,2,1))
  dm<-dominanceMatrix(df.1)
  expected<-matrix(c(0.5,1,1,0,0.5,1,0,0,0.5),3,3,byrow=T,dimnames = list(c("a","b","c"),c("a","b","c")))
  expect_equal(dm,expected)
})

test_that("retrieve correct dominance for a DominanceAnalysis object", {
  xa<-rnorm(1000)
  xb<-rnorm(1000)
  xc<-rnorm(1000)
  y<-xa*10+xb*5+xc+rnorm(1000)
  df.1<<-data.frame(y=y,a=xa,b=xb,c=xc)
  lm.1<-lm(y~a+b+c,df.1)
  da<-dominanceAnalysis(lm.1)
  cdm<-dominanceMatrix(da,type="complete")
  expected<-matrix(c(0.5,1,1,0,0.5,1,0,0,0.5),3,3,byrow=T,dimnames = list(c("a","b","c"),c("a","b","c")))
  expect_equal(cdm, expected)

  expect_error(dominanceMatrix(da,type="non_existant"),"type is incorrect")
})
