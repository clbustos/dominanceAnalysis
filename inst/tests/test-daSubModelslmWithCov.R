test_that("Correct submodels for standard data.frame and lmWithCov", {
	nam<-c("SES","IQ","nAch","GPA")
cor.m<-matrix(c(
1   ,.3  ,.41   ,.33,
.3  ,1   , .16  ,  .57 ,
.41 , .16, 1    ,  .50 ,
.33 , .57, .50  ,  1
),4,4,byrow=T,
dimnames=list(nam,nam)
)
lwith<-lmWithCov(GPA~SES+IQ+nAch,cor.m)

	pred.matrix<-matrix(
	  c(0,0,0,
	    1,0,0,
	    0,1,0,
	    0,0,1,
	    1,1,0,
	    1,0,1,
	    0,1,1,
	    1,1,1),8,3,byrow=T)
	predictors<-c("IQ","nAch","SES")
	level<-c(0,1,1,1,2,2,2,3)
	response<-c("GPA")
	constants<-c("")
	#print(as.formula(lwith))
	ds<-daSubmodels(lwith)
	#print(ds)
	expect_that(as.numeric(ds$pred.matrix),equals(as.numeric(pred.matrix)))
	expect_that(ds$predictors,equals(predictors))
	expect_that(ds$response,equals(response))
	expect_that(ds$level,equals(level))
	})
