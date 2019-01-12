context("Bootstrap samples")




test_that("Bootstrap should have correct sample values", {
  x1<-rnorm(1000)
  x2<-rnorm(1000)
  x3<-rnorm(1000)
  x4<-rnorm(1000)
  y1<-10*x1+8*x2+6*x3+4*x4+rnorm(1000)
  y2<-x1+x2+x3+x4+rnorm(1000)
  d.f<-data.frame(xa=x1,xb=x2,xc=x3,xd=x4,y=y1,y2=y2)
  lm.1<-lm(y~xa+xb+xc+xd,data=d.f)
  da<-dominanceAnalysis(lm.1)
  cdom<-dominanceMatrix(da,"complete",fit.function = "r2")
  expect_equivalent(rowSums(cdom),c(3.5,2.5,1.5,0.5))
  set.seed(1234)
  bs.da.1 <- bootDominanceAnalysis(lm.1, R=3)
  expect_equal(sum(summary(bs.da.1)$r2[,4]==1),18)
  lm.2<-lm(y2~xa+xb+xc+xd,data=d.f)

  da.2<-dominanceAnalysis(lm.2)
  da.2.gen<-da.2$general$r2
  set.seed(1234)
  bs.da.2 <- bootDominanceAnalysis(lm.2, R=2)
  sum.bs.da.2<-summary(bs.da.2)$r2
  res.gen<-as.numeric(as.character(sum.bs.da.2[sum.bs.da.2$dominance=="general","Dij"]))
  da.2.gen.bs<-matrix(c(0.5, res.gen[1], res.gen[2], res.gen[3],
                      1-res.gen[1], 0.5, res.gen[4], res.gen[5],
                      1-res.gen[2], 1-res.gen[4], 0.5, res.gen[6],
                      1-res.gen[3], 1-res.gen[5], 1-res.gen[6],0.5 ), 4,4,byrow=T)
  expect_equivalent(da.2.gen,da.2.gen.bs)
  expect_output(print(summary(bs.da.2)),"complete xa xb")
})
