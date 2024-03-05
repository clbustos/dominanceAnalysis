# dominanceanalysis (development version)

# dominanceanalysis 2.1.0

* Support only for R >= 4.0.0
* Updated README
* Added support for ordinal regression, using *clm*

# dominanceanalysis 2.0.0

**Important API Change:**

* All submodels in fit functions are now calculated using update(), ensuring that all settings of the original model are used in the dominance analysis. If R cannot find the original dataset for update, provide the dataset using the *newdata* parameter in the dominanceanalysis() method.

Minor Updates:
- Minor modification in dominanceMatrix.
- Added complete_flipped_axis parameter for the plot() function. Included examples of flipped axis for plots.
- Tests for bootstrap analysis (betareg, lmm, glm).
- Added Nakagawa's indexes for linear mixed models. Refer to README for examples.
- In the beta regression test, we check that using different estimators generates different results.

Bug Fixes:
- On R-devel, corrected the number of controls provided for the esoph dataset, fixing a test based on that example.
- Replaced sort.matrix with .sort.matrix to prevent sorting a standard matrix when devtools are used.
- Fixed documentation error in plot.dominanceAnalysis: the default plot is for general dominance, not for complete dominance.

# dominanceanalysis 1.3.0

- Added plot() method for dominanceAnalysis objects.
- Added support for beta regression using the betareg package. Suggested by Maartje Hidalgo.
- Added 'ordered' parameter to the dominanceMatrix() method.
- Bug fix: Corrected errors in the logistic regression vignette from v1.2.0 and added some plots for clarification.

# dominanceanalysis 1.2.0

- Added documentation for da.dynlm.fit.
- Test for the esoph example.
- New Acknowledgments section in the README file.
- Removed dependencies on caTools and heplots, as they are only used in examples.
- Bug fix: Fixed issue where logistic regression indexes failed in some models. Null model likelihood is now correctly calculated using update(x, ~1). Reported by Daniel Schlaepfer.
- Added basic support for dynamic linear models using the dynlm package. Suggested by Xiong Zhang.

# dominanceanalysis 1.1.0

- Support for named terms in bootDominanceAnalysis and bootAverageDominanceAnalysis.
- Added dominanceBriefing().

# dominanceanalysis 1.0.0

- First official version. Code coverage of 99% and complete documentation for all methods.
- Added vignette "Exploring Predictors' Importance in Binomial Logistic Regressions" by Filipa Coutinho Soares.
- Introduced dominanceMatrix() as a generic for matrix, data.frame, and dominanceAnalysis methods.
- New retrieval methods for the dominanceAnalysis object: getFits(), contributionAverage(), and contributionByLevel().
- Removed support for nlme (it never worked well).

# dominanceanalysis 0.1.2

- Added `terms` parameter in dominanceAnalysis to manually define a set of variables.
- Updated documentation, thanks to Filipa Coutinho Soares.
- Test for all relevant functions.

# dominanceanalysis 0.1.1

- Allowed multivariate regression with a covariance matrix.
- Added documentation for multivariate methods.
- Added bootstrap analysis for average contribution.
- Resolved bugs in bootstrap analysis and glm.da.fit.

# dominanceanalysis 0.1.0

- Complete support for OLS, logistic regression, and HLM.
- Support for bootstrap analysis.
