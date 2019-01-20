## Resubmission
This is a resubmission. In this version I have:

* Converted the word 'Analysis' to 'analysis' in the  DESCRIPTION title.

* Added references describing the methods in the Description field of the DESCRIPTION file. 

* Replaced all \dontrun{} by \donttest{} for examples with execution times longer that
  5 secs. 
  
*  Deleted \dontrun{} tags for examples with shorter execution times

## Test environments
* local Ubuntu 16.04.1 install, R 3.4.4
* ubuntu Ubuntu 14.04.5 LTS (on travis-ci), R 3.5.2
* win-builder (devel and release)

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs on local and travis-ci 

In win-builder, there is one NOTE
* This is a new submission


## Downstream dependencies
There are currently no downstream dependencies for this package
