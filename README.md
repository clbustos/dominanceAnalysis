dominanceAnalysis
=================

Dominance Analysis (Azen and Bodescu), for multiple regression models: OLS, GLM and HLM
Features:
- Provides complete, conditional and general dominance analysis for lm, lmer and correlation matrix based regression
- You could use multiple criteria for fitting (useful for HLM)

With lm and lmer:
  dominanceAnalysis(lm(y~x1+x2+x3))  
  dominanceAnalysis(lmer(y~x1+x2+x3+(1|g)))

Using correlation matrix based on a data.frame

  lwith<-lmWithCov(y~x1+x2+x3+x4,cor(d.f))
  dominanceAnalysis(lwith)

