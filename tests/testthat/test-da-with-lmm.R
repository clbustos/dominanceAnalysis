context("Dominance analysis with lmer")

library(lme4)

lmer.npk.1<-lmer(yield~N+P+K+(1|block),npk)
lmer.npk.0<-lmer(yield~1+(1|block),npk)
da.lmer<-dominanceAnalysis(lmer.npk.1,null.model=lmer.npk.0)

test_that("contribution by level are correct", {
  cbyl<-da.lmer$contribution.by.level
  expect_equal(sum(cbyl$rb.r2.1$N>cbyl$rb.r2.1$P),3L)
  expect_equal(sum(cbyl$rb.r2.1$K>cbyl$rb.r2.1$P),3L)
})

test_that("contribution.average are correct",{
  ca<-da.lmer$contribution.average
  expect_equal(ca$rb.r2.1,c(N=0.34,P=-0.03, K=.15),tolerance=0.005)

})