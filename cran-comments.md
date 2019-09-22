## New version: 1.0.2
This is a new version, that covers changes on 1.0.1 (only on github) and some urgent bug fixes. The changes from 1.0.0 are:

- Bug fix: Logistic regression indexes failed on some models. Null model likehood is now correctly calculated using update(x,~1). Report by Daniel Schlaepfer.
- Added (basic) support for dynamic linear models, using dynlm package.  Suggestion by Xiong Zhang.
- Support named terms in bootDominanceAnalysis and bootAverageDominanceAnalysis
- Added dominanceBriefing()

## Test environments
* local Ubuntu 16.04.1 install, R 3.6.1
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit (on rhub), R 3.6.1
* Ubuntu Linux 16.04 LTS, R-release (on rhub), R 3.6.1
* Fedora Linux, R-devel, clang, gfortran (on rhub), R 3.6.1

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs on local, Windows Server,  Ubuntu Linux 16.04 LTS (remote), 



## Downstream dependencies
There are currently no downstream dependencies for this package
