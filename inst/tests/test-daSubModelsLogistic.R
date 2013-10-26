test_that("Correct submodels for standard logistic LM", {
	x1<-rnorm(1000)
	x2<-rnorm(1000)
	x3<-rnorm(1000)
	y1<-x1+x2+x3
	y.binom<-rbinom(1000,1,exp(y1)/(1+exp(y1)))
	
	d.f<-data.frame(xa=x1,xb=x2,xc=x3,y=y.binom)
	pred.matrix<-matrix(
	  c(0,0,0,
	    1,0,0,
	    0,1,0,
	    0,0,1,
	    1,1,0,
	    1,0,1,
	    0,1,1,
	    1,1,1),8,3,byrow=T)
	predictors<-c("xa","xb","xc")
	level<-c(0,1,1,1,2,2,2,3)
	response<-c("y")
	constants<-c("")
	lm.1<-glm(y~xa+xb+xc,d.f,family=binomial)
	#print(lm.1)
	ds<-daSubmodels(lm.1)
	
	expect_that(as.numeric(ds$pred.matrix),equals(as.numeric(pred.matrix)))
	expect_that(ds$predictors,equals(predictors))
	expect_that(ds$response,equals(response))
	expect_that(ds$level,equals(level))
	})
