## New version: 2.1.0

This is a minor release, to provide a version of dominanceAnalysis that complies
with current requirements of CRAN.

## Test environments
* local Ubuntu 22.04 install, R 4.3.2
* remote macOS (r-release-macosx-arm64|4.3.0|macosx|macOS 13.3.1 (22E261)|Mac mini|Apple M1||en_US.UTF-8|macOS 11.3|clang-1403.0.22.14.1|GNU Fortran (GCC) 12.2.0 )
* remote R-hub Windows Server 2022, R-devel, 64 bit
* remote R-hub Fedora Linux, R-devel, clang, gfortran
* remote winbuilder R devel (2024-01-31) x86_64-w64-mingw32
* remote winbuilder R release R 4.3.2 (2023-10-31 ucrt)

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs on Ubuntu 22.04 local, for R 4.3.2 and for remote macOS 11.3, for R 4.3.0

There is a common 1 WARNING in remote winbuilder R devel, remote winbuilder R release ,R-hub Windows Server 2022, R-devel, and remote R-hub Fedora Linux, R-devel, clang, gfortran: 

  Possibly misspelled words in DESCRIPTION:
    Azen (12:14, 16:14, 17:14, 18:25)
    Budescu (11:14, 12:26, 16:26)
    Luo (18:14)
    Traxel (17:26)
  
This WARNING addresses alleged misspellings of four authors' names in the DESCRIPTION; however, this is a bogus issue as the names are indeed correctly spelled.

There were no ERRORs or NOTEs for remote winbuilder R devel and remote winbuilder R release.

There were 1 WARNING (already explained) and one NOTE on remote R-hub Fedora Linux, R-devel, clang, gfortran. The NOTE relate to examples with CPU (user + system) or elapsed time > 5s.

There was 1 WARNING (already explained) and 3 NOTES for R-hub Windows Server 2022, R-devel. The NOTES relate to (1) the unavailability of the V8 package for the HTML manual version, (2) an extra directory in the check directory, and (3) an additional 'lastMiKTeXException' file. These NOTES are not directly related to the package's features but are specific to issues on the remote platform

## Downstream dependencies
There are currently no downstream dependencies for this package
