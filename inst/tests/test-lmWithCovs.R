test_that("lmWithCovs works fine", {
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
expect_equal(lwith$coef,c(0.500,0.416,0.009),tolerance=0.001,scale=1)
expect_equal(lwith$r.squared,0.496,tolerance=0.001,scale=1)
	})


