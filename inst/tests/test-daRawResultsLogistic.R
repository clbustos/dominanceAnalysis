test_that("Correct raw results using glm(family=binomial)", {

	x1<-rnorm(1000)
	x2<-rnorm(1000)
	x3<-rnorm(1000)
	y1<-0.5*x1+2*x2-x3
	y.binom<-rbinom(1000,1,exp(y1)/(1+exp(y1)))
	
	d.f<-data.frame(xa=x1,xb=x2,xc=x3,y=y.binom)
	lm.1<-glm(y~xa+xb+xc,d.f,family=binomial)
	daRW<-daRawResults(lm.1)

	})

