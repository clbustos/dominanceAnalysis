context ("lmmR2 method for lme4")
library(lme4)
#library(nlme)
m<-250
reps.n1<-2
reps.n2<-2

# Big groups
x2.g<-rnorm(m)
e2.g<-rnorm(m)
gg2<-gl(m,reps.n1*reps.n2)

x2.g.i<-x2.g[gg2]
b2<-x2.g.i+e2.g[gg2] # theoretical variance: b2->2



# small groups
x.g<-rnorm(m*reps.n1)
e.g<-rnorm(m*reps.n1)
gg<-gl(m*reps.n1,reps.n2)
x.g.i<-x.g[gg]
b<- x.g.i+e.g[gg] # theoretical variance b->2


x.i<-rnorm(m*reps.n1*reps.n2)
e.i<-rnorm(m*reps.n1*reps.n2) # residual variance -> 1
y<-b+b2+x.i+e.i

m.null<-lmer(y~(1|gg2/gg)) # varianza de b=2, varianza del residuo=2
m.full<-lmer(y~(1|gg2/gg)+x.g.i+x.i) # varianza de b=1, residuo=1 -> predigo a nivel global y local

#m.null.lme<-lme(fixed=y~1,random=~1|gg2/gg)
#m.full.lme<-lme(fixed=y~1+x.g.i+x.i,random=~1+x.i|gg2/gg)


lmmR2.0<-lmmR2(m.null,m.null)

lmmR2.1<-lmmR2(m.null,m.full)
#lmmR2.2<-lmmR2(m.null.lme,m.full.lme)

#print(summary(lmmR2.2))

test_that("Report correct values for lmer comparing null model with itself", {
	expect_equal(lmmR2.0$rb.r2.1, expected=0,tolerance=0.15,scale=1)
	expect_equal(lmmR2.0$rb.r2.2, expected=0,tolerance=0.15,scale=1)
	expect_equal(lmmR2.0$sb.r2.1, expected=0,tolerance=0.15,scale=1)
	expect_equal(lmmR2.0$sb.r2.2, expected=0,tolerance=0.15,scale=1)

#	r2.1=rb.r2.1, rb.r2.2=rb.r2.2, sb.r2.1=sb.r2.1, sb.r2.2=sb.r2.2

})


test_that("Report correct values for lmer comparing both models", {
	expect_equal(lmmR2.1$rb.r2.1, expected=0.50,tolerance=0.15,scale=1)
	expect_equal(lmmR2.1$rb.r2.2, expected=0.30,tolerance=0.15,scale=1)
	expect_equal(lmmR2.1$sb.r2.1, expected=0.30,tolerance=0.15,scale=1)
	expect_equal(lmmR2.1$sb.r2.2, expected=0.25,tolerance=0.15,scale=1)

#	r2.1=rb.r2.1, rb.r2.2=rb.r2.2, sb.r2.1=sb.r2.1, sb.r2.2=sb.r2.2

})

test_that("summary methods works fine",{
  expect_output(print(summary(lmmR2.1)),"Explanatory power of Multilevel Model")
  expect_output(print(summary(lmmR2.1)),"R & B R1")

  })

test_that("group structure should be equal between models", {
  lmer.dif<-lmer(y~(1|gg))
  expect_error(lmmR2(m.null, lmer.dif),"Groups should be equal")
})
test_that("should raise an error if use an object that isn't created by lme4",{
  lm.1<-lm(y~x.i)
  expect_error(lmmR2(m.null, lm.1),"Not implemented")
  expect_error(lmmR2(lm.1,m.null),"Not implemented")
})
