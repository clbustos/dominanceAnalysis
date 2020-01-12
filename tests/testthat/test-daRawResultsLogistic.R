context("Using logistic regression")
x1<-rnorm(1000)
x2<-rnorm(1000)
x3<-rnorm(1000)
y1<-0.5*x1+2*x2-x3
y.binom<-rbinom(1000,1,exp(y1)/(1+exp(y1)))

d.f1<<-data.frame(xa=x1,xb=x2,xc=x3,y=y.binom)
glm.1<-glm(y~xa+xb+xc,data=d.f1,family=binomial)
daRW<-daRawResults(glm.1)

test_that("Correct raw results using glm(family=binomial)", {

	base.fits<-daRW$base.fits
  # x2>x3>x1
  c.types=c("r2.m","r2.cs","r2.n","r2.e")
  for(coef.type in c.types) {
    expect_gt(base.fits["xb",coef.type],   base.fits["xc",coef.type] )
    expect_gt(base.fits["xc",coef.type],   base.fits["xa",coef.type] )
    expect_gt(base.fits["xb+xc",coef.type],   base.fits["xa+xb",coef.type] )

    }
})

