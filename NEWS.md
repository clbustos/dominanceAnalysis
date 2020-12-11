# dominanceanalysis 2.0.0


# dominanceanalysis 1.3.0

- Added plot() method for dominanceAnalysis object.
- Added support for beta regression, using betareg package. Suggestion by Maartje Hidalgo
- Added 'ordered' parameter to dominanceMatrix() method
- Bug fix: Fixed some mistakes on logistic regression vignette on v1.2.0. Added some plots, to compensate.

# dominanceanalysis 1.2.0

- Added documentation for da.dynlm.fit. 
- Test for esoph example. 
- New Acknowledgments section in README file
- Removed dependencies on caTools and heplots, because are used only for examples.
- Bug fix: Logistic regression indexes failed on some models. Null model likelihood is now correctly calculated using update(x,~1). . Report by Daniel Schlaepfer.
- Added (basic) support for dynamic linear models, using dynlm package.  Suggestion by Xiong Zhang.

# dominanceanalysis 1.1.0

- Support named terms in bootDominanceAnalysis and bootAverageDominanceAnalysis
- Added dominanceBriefing()

# dominanceanalysis 1.0.0

- First official version. Code coverage of 99% and complete documentation of all methods.
- Added vignette "Exploring predictors' importance in binomial logistic regressions", by Filipa Coutinho Soares. 
- Added dominanceMatrix() as a generic for matrix, data.frame and dominanceAnalysis methods
- New retrieval methods for dominanceAnalysis object: getFits(), contributionAverage() and contributionByLevel()
- Removed support for nlme (it never worked well)

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
