dominanceAnalysis
=================

Dominance Analysis (Azen and Bodescu, 2003, 2006; Azen and Traxel, 2009;Luo and Azen, 2013), for multiple regression models: OLS, GLM and HLM.

Features:
- Provides complete, conditional and general dominance analysis for lm, lmer, glm(family=binomial) and correlation matrix based regression
- You could use multiple criteria as fit indexes (useful for HLM)

With lm (see Azen and Bodescu, 2003) 

    dominanceAnalysis(lm(y~x1+x2+x3))
    
For hierarchinal linear models using lmer. You should provide a null model. Requires https://github.com/clbustos/r-glmmextra (see Luo and Azen, 2013).

    dominanceAnalysis(lmer(y~x1+x2+x3+(1|g)), null.model=lmer(y~(1|g)))

For logistic regression (experimental) (see Azen and Traxel, 2009).
    
    dominanceAnalysis(glm(y~x1+x2+xx3,family=binomial))
    

Using correlation matrix based on a data.frame

    lwith<-lmWithCov(y~x1+x2+x3+x4,cor(d.f))
    dominanceAnalysis(lwith)

Bootstrap analysis (Azen and Bodescu, 2006)

    bootDominanceAnalysis(lm(y~x1+x2+x3))

References
==========
- Azen, R. & Budescu, D. (2003). The Dominance Analysis Approach for Comparing Predictors in Multiple Regression. Psychological Methods, 8 (2), 129-148.
- Azen, R. & Budescu, D. (2006). Comparing predictors in Multivariate Regression Models: an extension of Dominance Analysis, 31(2), 157-180.
- Azen, R. & Traxel, N. (2009). Using Dominance Analysis to Determine Predictor Importance in Logistic Regression. Journal of Educational and Behavioral Statistics,34(3), 319-347.
- Luo, W. & Azen, R. (2013). Determining Predictor Importance in Hierarchical Linear Models Using Dominance Analysis. Journal of Educational and Behavioral Statistics, 38(1), 3-31.

