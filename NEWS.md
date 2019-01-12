# dominanceanalysis 1.0.0

- First official version. Code coverage of 99% and complete documentation of all methods.
- Vignette "Exploring predictors' importance in binomial logistic regressions", by Filipa Coutinho Soares
- Added dominanceMatrix() as a generic for matrix, data.frame and dominanceAnalysis methods
- New retrieval methods for dominanceAnalysis object: getFits(), contributionAverage() and contributionByLevel()
- Removed support for nlme (never worked right)

# dominanceanalysis 0.1.2

- Added parameter `terms` on dominanceAnalysis, to manually define set of variables
- Updated documentation, thanks to Filipa Coutinho Soares
- Test for all relevant functions

# dominance analysis 0.1.1

- Allowed multivariate regression with covariance matrix
- Added documentation for multivariate methods
- Added bootstrap analysis for average contribution
- Resolved bug on bootstrap analysis
- Resolved bug on glm.da.fit

# dominance analysis 0.1.0

- Complete support for OLS, logistic regression and HLM  
- Support for bootstrap analysis