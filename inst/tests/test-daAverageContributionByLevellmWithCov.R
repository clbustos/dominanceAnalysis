test_that("Correct average contribution by level using lmWithCovs", {
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
daA<-daAverageContributionByLevel(rawR)$r2
expected<-matrix(c(
0, 0.3249000, 0.2500000,1.089000e-01,
1, 0.2450947, 0.1656952,2.328181e-02,
2, 0.2276912, 0.1437922, 6.548709e-05),
3,4,byrow=T,dimnames=list(
c(1,2,3),
c("level","IQ","nAch","SES")
))
expect_equal(expected,as.matrix(daA),tolerance=0.001)
total<-sum(colMeans(daA[,-1]))
expect_equal(total,lwith$r.squared)
})
