context("Bootstrap dominance analysis")

test_that("Bootstrap should have correct sample values", {
  x1<-rnorm(1000)
  x2<-rnorm(1000)
  x3<-rnorm(1000)
  x4<-rnorm(1000)
  y1<-10*x1+8*x2+6*x3+4*x4+rnorm(1000)
  y2<-x1+x2+x3+x4+rnorm(1000)
  # This should be fixed
  d.f11<<-data.frame(xa=x1,xb=x2,xc=x3,xd=x4,y=y1,y2=y2)
  lm.1<-lm(y~xa+xb+xc+xd,data=d.f11)
  da<-dominanceAnalysis(lm.1)
  cdom<-dominanceMatrix(da,"complete",fit.function = "r2")
  expect_equivalent(rowSums(cdom),c(3.5,2.5,1.5,0.5))
  set.seed(1245)
  bs.da.1 <- bootDominanceAnalysis(lm.1, R=3)
  #expect_gt(sum(apply(bs.da.1$boot$t,1,sd)),0)
  expect_equal(sum(summary(bs.da.1)$r2[,4]==1),18)
  lm.2<-lm(y2~xa+xb+xc+xd,data=d.f11)

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


test_that("should have correct values using terms",{

  lm.mtcars<-lm(mpg~.,mtcars)
  terms<-c(motor='cyl+disp+hp+carb',trans='drat+am+gear',other='wt+qsec+vs+am')
  da.mtcars<-bootDominanceAnalysis(lm.mtcars,R=2,terms=terms)
  expect_equal(da.mtcars$terms,terms)
  expected.m.names<-matrix(
    c(terms[1], terms[2], terms[1], terms[3], terms[2], terms[3]),
    3,2, byrow = TRUE
  )
  expect_equal(da.mtcars$m.names, expected.m.names)
  s.da<-summary(da.mtcars)
  expect_equal(as.character(s.da$r2$i),rep(c("motor","motor","trans"),3))
  expect_equal(as.character(s.da$r2$k),rep(c("trans","other","other"),3))

})
