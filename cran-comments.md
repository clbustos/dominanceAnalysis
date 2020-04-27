## New version: 1.3.0
This is a new version, that covers both new features and bug fixes, being backward compatible. The changes from 1.2.0 are:
- Added plot() method for dominanceAnalysis object.
- Added support for beta regression, using betareg package.
- Added 'ordered' parameter to dominanceMatrix() method
- Bug fix: Fixed some mistakes on logistic regression vignette commited on v1.2.0.

## Test environments
* local Ubuntu 16.04.1 install, R 3.6.2
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit (rhub)
* Ubuntu Linux 16.04 LTS, R-release, GCC (rhub)
* Fedora Linux, R-devel, clang, gfortran (rhub)
* Windows, R-devel, 2019-12-29 r77627 (winbuilder)
* Windows, R-release, R 3.6.2 (winbuilder)

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs on local, winbuilder and rhub, except for Fedora build.
On Fedora, R-devel, a possible mis-spelling of some authors' surnames was NOTEd, but they are incorporated in   inst/WORDLIST, so appears to be a mistake on this build. 

## Downstream dependencies
There are currently no downstream dependencies for this package
