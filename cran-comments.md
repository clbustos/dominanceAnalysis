## New version: 2.0.0

This is a new version, that provides an important change on API and provides bug fixes. The changes from 1.3.0 are:
- All submodels on fit functions are calculated using update(), so all settings on original model are used on dominance analysis. If R can't find the original dataset for update, just provide the dataset using the  *newdata* paramater on dominanceanalysis() method.
- Little modification on dominanceMatrix
- Added complete_flipped_axis parameter for plot() function. Added examples of flipped axis for plots
- Tests for bootstrap analysis (betareg, lmm, glm). 
- Added Nakagawa's indexes for linear mixed models. See README for examples.
- On beta regression test, on test we check that using different estimator generates differents results
- Bug fix: On R-devel, correct number of controls are provided for esoph dataset, breaking a test based on that example.
- Bug fix: sort.matrix replaced to .sort.matrix to avoid sorting a standard matrix when devtools are used. 
- Fixed documentation error on plot.dominanceAnalysis: default plot is for general dominance, no complete.

## Test environments
* local Ubuntu 18.04 install, R 3.6.3
* virtualized Ubuntu 18.04 install, R Under development (unstable) (2020-12-08 r79596) -- "Unsuffered Consequences"
* Windows, R-devel, R Under development (unstable) (2020-12-09 r79601) (winbuilder)
* Windows, R-release, R 4.0.3 (2020-10-10) (winbuilder)
* Windows, R-old-release, R version 3.6.3 (2020-02-29) (winbuilder)
* Ubuntu Linux 16.04 LTS, R-release, GCC (rhub)
* Fedora Linux, R-devel, clang, gfortran (rhub)

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs on Ubuntu 18.04 local and virtualized, for R 3.6.3 and R devel.

There are two notes on Ubuntu Linux 16.04 (rhub), Fedora Linux, R-devel (rhub), and 3 Windows version on winbuilder:

* Possibly mis-spelled words in DESCRIPTION -> There are names of 4 authors of papers related to dominance, included on WORDLIST.
* CRAN repository db overrides: X-CRAN-Comment: Archived on 2020-12-10 as check problems were not corrected in time -> This version fix the problem with test broken by new version of esoph data.


## Downstream dependencies
There are currently no downstream dependencies for this package
