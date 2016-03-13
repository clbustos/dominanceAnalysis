# Taken from Azen & Bodescu (2006)
test_that("mlmWithCov works fine (multivariate)", {
# We use directly the data from Rohwer, as given by package heplots
library(heplots)
cor.m<-cor(Rohwer[Rohwer[,1]==1,2+c(7,8,1,2,3)])
lwith<-mlmWithCov(cbind(na,ss)~SAT+PPVT+Raven,cor.m)
expect_equal(lwith$r.squared.xy,0.494,tolerance=0.001,scale=1)
expect_equal(lwith$p.squared.yx,0.256,tolerance=0.001,scale=1)

})
