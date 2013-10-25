test_that("values report almost the same as Azen and Bodescu(2003)", {
nam<-c("y","x1","x2","x3","x4")
cor.m<-matrix(c(
1.0	,	0.6	,  	0.3,  	0.4,  	0.5,
0.6	,	1.0	,	0.8,	0.1,	0.3,
0.3	,	0.8	,	1.0,	0.1,	0.1,
0.4	,	0.1	,	0.1,	1.0,	0.5,
0.5	,	0.3	,	0.1,	0.5,	1.0)	
,5,5,byrow=T,
dimnames=list(nam,nam)
)
lwith<-lmWithCov(y~x1+x2+x3+x4,cor.m)
rawR<-daRawResults(lwith)
#print(rawR)
daA<-daAverageContributionByLevel(rawR)$r2
expected<-matrix(c(
0, 0.360,0.090,	0.160,0.250,
1, 0.300,0.074, 0.095,0.152,
2, 0.263,0.069, 0.063,0.073,
3, 0.246,0.071, 0.061,0.010
),
4,5,byrow=T,dimnames=list(
c(1,2,3,4),
c("level","x1","x2","x3","x4")
))

expect_equal(expected,as.matrix(daA),tolerance=0.002)
total<-sum(colMeans(daA[,-1]))
expect_equal(total,lwith$r.squared)
complete.dominance<-daCompleteDominance(rawR)
expected.complete.dominance<-matrix(
c(0,1,1,1,
0,0,0,0,
0,0,0,0,
0,0,0,0),
4,4,byrow=T)
expect_equivalent(expected.complete.dominance,complete.dominance$r2)
expected.conditional.dominance<-matrix(c(
0,1,1,1,
0,0,0,0,
0,0,0,0,
0,0,0,0
),
4,4,byrow=T
)
conditional.dominance<-daConditionalDominance(rawR)
expect_equivalent(expected.conditional.dominance,conditional.dominance$r2)
expected.general.dominance<-matrix(c(
0,1,1,1,
0,0,0,0,
0,1,0,0,
0,1,1,0
),4,4,byrow=T)
general.dominance<-daGeneralDominance(rawR)
expect_equivalent(expected.general.dominance,general.dominance$r2)
print(dominanceAnalysis(lwith))
})
