context("lmWithCov raw results")
test_that("Correct raw results using lmWithCov", {
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
rawR<-daRawResults(lwith)
base.fits<-c("1"=0.0000000,SES=0.1089000, "IQ"=0.3249000, nAch=0.2500000, "SES+IQ"=0.3526813, "SES+nAch"=0.2687823, "IQ+nAch"=0.4964080, "SES+IQ+nAch"=0.4964735)
expect_equal(rawR$base.fits[,1], base.fits,tolerance=0.0001)
})
