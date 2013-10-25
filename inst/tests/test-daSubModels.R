test_that("Correct submodels for standard data.frame and lm", {
	x1<-rnorm(1000)
	x2<-rnorm(1000)
	x3<-rnorm(1000)
	y1<-x1+x2+x3+rnorm(1000)
	d.f<-data.frame(xa=x1,xb=x2,xc=x3,y=y1)
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
	lm.1<-lm(y~xa+xb+xc,d.f)
	ds<-daSubmodels(lm.1)
	
	expect_that(as.numeric(ds$pred.matrix),equals(as.numeric(pred.matrix)))
	expect_that(ds$predictors,equals(predictors))
	expect_that(ds$response,equals(response))
	expect_that(ds$level,equals(level))
	})


test_that("Correct submodels for standard data.frame and lmer", {
	require(lme4)
	x1<-rnorm(1000)
	x2<-rnorm(1000)
	x3<-rnorm(1000)
	g<-factor(gl(50,20))
	y1<-x1+x2+x3+rnorm(1000)
	d.f<-data.frame(xa=x1,xb=x2,xc=x3,y=y1)
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
	constants<-c("( 1 | g )")
	lm.1<-lmer(y~xa+xb+xc+(1|g),d.f)
	ds<-daSubmodels(lm.1)
	
	expect_that(as.numeric(ds$pred.matrix),equals(as.numeric(pred.matrix)))
	expect_that(ds$predictors,equals(predictors))
	expect_that(ds$response,equals(response))
	expect_that(ds$constants,equals(constants))

	expect_that(ds$level,equals(level))
	})



test_that("Correct submodels for standard data.frame with constants", {
	x1<-rnorm(1000)
	x2<-rnorm(1000)
	x3<-rnorm(1000)
	x4<-rnorm(1000)
	y1<-x1+x2+x3+x4+rnorm(1000)
	d.f<-data.frame(xa=x1,xb=x2,xc=x3,xd=x4,y=y1)
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
	response<-c("y")
	constants<-c("xd")
	level<-c(0,1,1,1,2,2,2,3)
	lm.1<-lm(y~xa+xb+xc+xd,d.f)
	ds<-daSubmodels(lm.1,constants="xd")
	expect_that(as.numeric(ds$pred.matrix),equals(as.numeric(pred.matrix)))
	expect_that(ds$predictors,equals(predictors))
	expect_that(ds$response,equals(response))
	expect_that(ds$constants,equals(constants))
	expect_that(ds$level,equals(level))

	})
