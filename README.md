
<!-- README.md is generated from README.Rmd. Please edit that file -->
dominanceanalysis
=================

[![Build Status](https://travis-ci.org/clbustos/dominanceAnalysis.svg?branch=master)](https://travis-ci.org/clbustos/dominanceAnalysis)

Dominance Analysis (Azen and Bodescu, 2003, 2006; Azen and Traxel, 2009;Luo and Azen, 2013), for multiple regression models: OLS, GLM and HLM.

Features:

-   Provides complete, conditional and general dominance analysis for lm, lmer, glm(family=binomial) and correlation matrix based regression.
-   You could use multiple criteria as fit indexes (useful for HLM).

Examples
========

Linear regression
-----------------

We could apply dominance analysis directly on data, using lm (see Azen and Bodescu, 2003).

On attitude data, we could see that complaints dominates completely all others variables, and learning comes second. The other 4 variables doesn't show a consistent pattern for complete and conditional dominance.

``` r
  library(dominanceanalysis)
  lm.attitude<-lm(rating~.,attitude)
  da.attitude<-dominanceAnalysis(lm.attitude)
  print(da.attitude)
#> 
#> Dominance analysis
#> Predictors: complaints, privileges, learning, raises, critical, advance 
#> Fit-indexes: r2 
#> 
#> * Fit:  r2 
#>                            complete              conditional
#> complaints prvl,lrnn,rass,crtc,advn prvl,lrnn,rass,crtc,advn
#> privileges                     crtc                     crtc
#> learning        prvl,rass,crtc,advn      prvl,rass,crtc,advn
#> raises                         crtc                     crtc
#> critical                                                    
#> advance                                                     
#>                        rank.general
#> complaints prvl,lrnn,rass,crtc,advn
#> privileges                crtc,advn
#> learning        prvl,rass,crtc,advn
#> raises               prvl,crtc,advn
#> critical                           
#> advance                        crtc
  summary(da.attitude)
#> $r2
#>                                                                             model
#> 1                                                                               1
#> cmpl                                                                   complaints
#> prvl                                                                   privileges
#> lrnn                                                                     learning
#> rass                                                                       raises
#> crtc                                                                     critical
#> advn                                                                      advance
#> Avl1                                                              Average level 1
#> cmplnts+p                                                   complaints+privileges
#> cmplnts+l                                                     complaints+learning
#> cmplnts+r                                                       complaints+raises
#> cmplnts+c                                                     complaints+critical
#> cmplnts+d                                                      complaints+advance
#> prvlgs+l                                                      privileges+learning
#> prvlgs+r                                                        privileges+raises
#> prvlgs+c                                                      privileges+critical
#> prvlgs+d                                                       privileges+advance
#> lrnng+r                                                           learning+raises
#> lrnng+c                                                         learning+critical
#> lrnng+d                                                          learning+advance
#> rss+c                                                             raises+critical
#> rss+d                                                              raises+advance
#> crt+                                                             critical+advance
#> Avl2                                                              Average level 2
#> cmplnts+prvlgs+l                                   complaints+privileges+learning
#> cmplnts+prvlgs+r                                     complaints+privileges+raises
#> cmplnts+prvlgs+c                                   complaints+privileges+critical
#> cmplnts+prvlgs+d                                    complaints+privileges+advance
#> cmplnts+lrnng+r                                        complaints+learning+raises
#> cmplnts+lrnng+c                                      complaints+learning+critical
#> cmplnts+lrnng+d                                       complaints+learning+advance
#> cmplnts+rss+c                                          complaints+raises+critical
#> cmplnts+rss+d                                           complaints+raises+advance
#> cmplnts+c+                                            complaints+critical+advance
#> prvlgs+lrnng+r                                         privileges+learning+raises
#> prvlgs+lrnng+c                                       privileges+learning+critical
#> prvlgs+lrnng+d                                        privileges+learning+advance
#> prvlgs+rss+c                                           privileges+raises+critical
#> prvlgs+rss+d                                            privileges+raises+advance
#> prvlgs+c+                                             privileges+critical+advance
#> lrnng+rss+c                                              learning+raises+critical
#> lrnng+rss+d                                               learning+raises+advance
#> lrnng+c+                                                learning+critical+advance
#> rs++                                                      raises+critical+advance
#> Avl3                                                              Average level 3
#> cmplnts+prvlgs+lrnng+r                      complaints+privileges+learning+raises
#> cmplnts+prvlgs+lrnng+c                    complaints+privileges+learning+critical
#> cmplnts+prvlgs+lrnng+d                     complaints+privileges+learning+advance
#> cmplnts+prvlgs+rss+c                        complaints+privileges+raises+critical
#> cmplnts+prvlgs+rss+d                         complaints+privileges+raises+advance
#> cmplnts+prvlgs+c+                          complaints+privileges+critical+advance
#> cmplnts+lrnng+rss+c                           complaints+learning+raises+critical
#> cmplnts+lrnng+rss+d                            complaints+learning+raises+advance
#> cmplnts+lrnng+c+                             complaints+learning+critical+advance
#> cmplnts+r++                                    complaints+raises+critical+advance
#> prvlgs+lrnng+rss+c                            privileges+learning+raises+critical
#> prvlgs+lrnng+rss+d                             privileges+learning+raises+advance
#> prvlgs+lrnng+c+                              privileges+learning+critical+advance
#> prvlgs+r++                                     privileges+raises+critical+advance
#> l+++                                             learning+raises+critical+advance
#> Avl4                                                              Average level 4
#> cmplnts+prvlgs+lrnng+rss+c         complaints+privileges+learning+raises+critical
#> cmplnts+prvlgs+lrnng+rss+d          complaints+privileges+learning+raises+advance
#> cmplnts+prvlgs+lrnng+c+           complaints+privileges+learning+critical+advance
#> cmplnts+prvlgs+r++                  complaints+privileges+raises+critical+advance
#> cmplnts+l+++                          complaints+learning+raises+critical+advance
#> p++++                                 privileges+learning+raises+critical+advance
#> Avl5                                                              Average level 5
#> c+++++                     complaints+privileges+learning+raises+critical+advance
#>                            level        fit complaints privileges learning
#> 1                              0 0.00000000     0.6810     0.1820   0.3890
#> cmpl                           1 0.68131416         NA     0.0020   0.0270
#> prvl                           1 0.18157559     0.5010         NA   0.2260
#> lrnn                           1 0.38897445     0.3190     0.0190       NA
#> rass                           1 0.34826403     0.3360     0.0330   0.1020
#> crtc                           1 0.02447321     0.6570     0.1660   0.3720
#> advn                           1 0.02405175     0.6580     0.1580   0.4080
#> Avl1                           1         NA     0.4942     0.0756   0.2270
#> cmplnts+p                      2 0.68306390         NA         NA   0.0320
#> cmplnts+l                      2 0.70801520         NA     0.0070       NA
#> cmplnts+r                      2 0.68389794         NA     0.0020   0.0240
#> cmplnts+c                      2 0.68131649         NA     0.0020   0.0270
#> cmplnts+d                      2 0.68228010         NA     0.0010   0.0430
#> prvlgs+l                       2 0.40751383     0.3070         NA       NA
#> prvlgs+r                       2 0.38150183     0.3050         NA   0.0770
#> prvlgs+c                       2 0.19054994     0.4930         NA   0.2220
#> prvlgs+d                       2 0.18166343     0.5020         NA   0.2760
#> lrnng+r                        2 0.45067032     0.2580     0.0080       NA
#> lrnng+c                        2 0.39614609     0.3120     0.0160       NA
#> lrnng+d                        2 0.43238637     0.2930     0.0260       NA
#> rss+c                          2 0.35333723     0.3310     0.0330   0.0980
#> rss+d                          2 0.39864217     0.2910     0.0440   0.1540
#> crt+                           2 0.03781193     0.6450     0.1530   0.4160
#> Avl2                           2         NA     0.3737     0.0292   0.1369
#> cmplnts+prvlgs+l               3 0.71500445         NA         NA       NA
#> cmplnts+prvlgs+r               3 0.68620999         NA         NA   0.0290
#> cmplnts+prvlgs+c               3 0.68307764         NA         NA   0.0320
#> cmplnts+prvlgs+d               3 0.68348685         NA         NA   0.0460
#> cmplnts+lrnng+r                3 0.70829161         NA     0.0070       NA
#> cmplnts+lrnng+c                3 0.70801569         NA     0.0070       NA
#> cmplnts+lrnng+d                3 0.72559500         NA     0.0040       NA
#> cmplnts+rss+c                  3 0.68418747         NA     0.0020   0.0240
#> cmplnts+rss+d                  3 0.68952873         NA     0.0010   0.0390
#> cmplnts+c+                     3 0.68237356         NA     0.0010   0.0450
#> prvlgs+lrnng+r                 3 0.45871386     0.2570         NA       NA
#> prvlgs+lrnng+c                 3 0.41253836     0.3020         NA       NA
#> prvlgs+lrnng+d                 3 0.45800104     0.2710         NA       NA
#> prvlgs+rss+c                   3 0.38595140     0.3010         NA   0.0730
#> prvlgs+rss+d                   3 0.44300032     0.2470         NA   0.1200
#> prvlgs+c+                      3 0.19077017     0.4930         NA   0.2850
#> lrnng+rss+c                    3 0.45089766     0.2570     0.0080       NA
#> lrnng+rss+d                    3 0.55237629     0.1760     0.0110       NA
#> lrnng+c+                       3 0.45332646     0.2740     0.0220       NA
#> rs++                           3 0.40130627     0.2880     0.0440   0.1520
#> Avl3                           3         NA     0.2866     0.0107   0.0845
#> cmplnts+prvlgs+lrnng+r         4 0.71522371         NA         NA       NA
#> cmplnts+prvlgs+lrnng+c         4 0.71503039         NA         NA       NA
#> cmplnts+prvlgs+lrnng+d         4 0.72934125         NA         NA       NA
#> cmplnts+prvlgs+rss+c           4 0.68647898         NA         NA   0.0290
#> cmplnts+prvlgs+rss+d           4 0.69044600         NA         NA   0.0410
#> cmplnts+prvlgs+c+              4 0.68356926         NA         NA   0.0470
#> cmplnts+lrnng+rss+c            4 0.70834737         NA     0.0070       NA
#> cmplnts+lrnng+rss+d            4 0.72851428         NA     0.0030       NA
#> cmplnts+lrnng+c+               4 0.72726509         NA     0.0040       NA
#> cmplnts+r++                    4 0.68967437         NA     0.0010   0.0400
#> prvlgs+lrnng+rss+c             4 0.45903073     0.2560         NA       NA
#> prvlgs+lrnng+rss+d             4 0.56315483     0.1690         NA       NA
#> prvlgs+lrnng+c+                4 0.47557329     0.2550         NA       NA
#> prvlgs+r++                     4 0.44494455     0.2460         NA   0.1190
#> l+++                           4 0.55329226     0.1760     0.0110       NA
#> Avl4                           4         NA     0.2204     0.0052   0.0552
#> cmplnts+prvlgs+lrnng+rss+c     5 0.71535493         NA         NA       NA
#> cmplnts+prvlgs+lrnng+rss+d     5 0.73180937         NA         NA       NA
#> cmplnts+prvlgs+lrnng+c+        5 0.73101872         NA         NA       NA
#> cmplnts+prvlgs+r++             5 0.69059450         NA         NA   0.0420
#> cmplnts+l+++                   5 0.72923413         NA     0.0030       NA
#> p++++                          5 0.56392478     0.1690         NA       NA
#> Avl5                           5         NA     0.1690     0.0030   0.0420
#> c+++++                         6 0.73260199         NA         NA       NA
#>                            raises critical advance
#> 1                          0.3480   0.0240  0.0240
#> cmpl                       0.0030   0.0000  0.0010
#> prvl                       0.2000   0.0090  0.0000
#> lrnn                       0.0620   0.0070  0.0430
#> rass                           NA   0.0050  0.0500
#> crtc                       0.3290       NA  0.0130
#> advn                       0.3750   0.0140      NA
#> Avl1                       0.1938   0.0070  0.0214
#> cmplnts+p                  0.0030   0.0000  0.0000
#> cmplnts+l                  0.0000   0.0000  0.0180
#> cmplnts+r                      NA   0.0000  0.0060
#> cmplnts+c                  0.0030       NA  0.0010
#> cmplnts+d                  0.0070   0.0000      NA
#> prvlgs+l                   0.0510   0.0050  0.0500
#> prvlgs+r                       NA   0.0040  0.0610
#> prvlgs+c                   0.1950       NA  0.0000
#> prvlgs+d                   0.2610   0.0090      NA
#> lrnng+r                        NA   0.0000  0.1020
#> lrnng+c                    0.0550       NA  0.0570
#> lrnng+d                    0.1200   0.0210      NA
#> rss+c                          NA       NA  0.0480
#> rss+d                          NA   0.0030      NA
#> crt+                       0.3630       NA      NA
#> Avl2                       0.1058   0.0042  0.0343
#> cmplnts+prvlgs+l           0.0000   0.0000  0.0140
#> cmplnts+prvlgs+r               NA   0.0000  0.0040
#> cmplnts+prvlgs+c           0.0030       NA  0.0000
#> cmplnts+prvlgs+d           0.0070   0.0000      NA
#> cmplnts+lrnng+r                NA   0.0000  0.0200
#> cmplnts+lrnng+c            0.0000       NA  0.0190
#> cmplnts+lrnng+d            0.0030   0.0020      NA
#> cmplnts+rss+c                  NA       NA  0.0050
#> cmplnts+rss+d                  NA   0.0000      NA
#> cmplnts+c+                 0.0070       NA      NA
#> prvlgs+lrnng+r                 NA   0.0000  0.1040
#> prvlgs+lrnng+c             0.0460       NA  0.0630
#> prvlgs+lrnng+d             0.1050   0.0180      NA
#> prvlgs+rss+c                   NA       NA  0.0590
#> prvlgs+rss+d                   NA   0.0020      NA
#> prvlgs+c+                  0.2540       NA      NA
#> lrnng+rss+c                    NA       NA  0.1020
#> lrnng+rss+d                    NA   0.0010      NA
#> lrnng+c+                   0.1000       NA      NA
#> rs++                           NA       NA      NA
#> Avl3                       0.0525   0.0023  0.0390
#> cmplnts+prvlgs+lrnng+r         NA   0.0000  0.0170
#> cmplnts+prvlgs+lrnng+c     0.0000       NA  0.0160
#> cmplnts+prvlgs+lrnng+d     0.0020   0.0020      NA
#> cmplnts+prvlgs+rss+c           NA       NA  0.0040
#> cmplnts+prvlgs+rss+d           NA   0.0000      NA
#> cmplnts+prvlgs+c+          0.0070       NA      NA
#> cmplnts+lrnng+rss+c            NA       NA  0.0210
#> cmplnts+lrnng+rss+d            NA   0.0010      NA
#> cmplnts+lrnng+c+           0.0020       NA      NA
#> cmplnts+r++                    NA       NA      NA
#> prvlgs+lrnng+rss+c             NA       NA  0.1050
#> prvlgs+lrnng+rss+d             NA   0.0010      NA
#> prvlgs+lrnng+c+            0.0880       NA      NA
#> prvlgs+r++                     NA       NA      NA
#> l+++                           NA       NA      NA
#> Avl4                       0.0198   0.0008  0.0326
#> cmplnts+prvlgs+lrnng+rss+c     NA       NA  0.0170
#> cmplnts+prvlgs+lrnng+rss+d     NA   0.0010      NA
#> cmplnts+prvlgs+lrnng+c+    0.0020       NA      NA
#> cmplnts+prvlgs+r++             NA       NA      NA
#> cmplnts+l+++                   NA       NA      NA
#> p++++                          NA       NA      NA
#> Avl5                       0.0020   0.0010  0.0170
#> c+++++                         NA       NA      NA
```

To evaluate the robustness of our results, we could use bootstrap analysis (Azen and Bodescu, 2006). We could see that complete dominance of complaints over all other variables is fairly robust, but complete dominance of learning isn't.

``` r
  bda.attitude=bootDominanceAnalysis(lm.attitude, R=100)
  summary(bda.attitude)
#> Dominance Analysis
#> ==================
#> Fit index: r2 
#>      dominance          i          j Dij  mDij            SE.Dij.  Pij
#> 1     complete complaints privileges   1  0.98 0.0984731927834662 0.96
#> 2     complete complaints   learning   1 0.935  0.168998834494816 0.87
#> 3     complete complaints     raises   1 0.985 0.0857233039988826 0.97
#> 4     complete complaints   critical   1  0.99 0.0703526470681448 0.98
#> 5     complete complaints    advance   1  0.98 0.0984731927834662 0.96
#> 6     complete privileges   learning   0 0.295  0.247155535211855    0
#> 7     complete privileges     raises 0.5  0.46  0.136329962172145    0
#> 8     complete privileges   critical   1  0.49  0.141778031094419 0.03
#> 9     complete privileges    advance 0.5  0.51 0.0703526470681448 0.02
#> 10    complete   learning     raises   1 0.625   0.26944574611786  0.3
#> 11    complete   learning   critical   1 0.725               0.25 0.45
#> 12    complete   learning    advance   1  0.65  0.230283093235919  0.3
#> 13    complete     raises   critical   1 0.565  0.168998834494816 0.13
#> 14    complete     raises    advance 0.5 0.535  0.128216199988121 0.07
#> 15    complete   critical    advance 0.5 0.495  0.132859004781442 0.03
#> 16 conditional complaints privileges   1  0.99 0.0703526470681448 0.98
#> 17 conditional complaints   learning   1  0.95  0.150755672288882  0.9
#> 18 conditional complaints     raises   1 0.995               0.05 0.99
#> 19 conditional complaints   critical   1  0.99 0.0703526470681448 0.98
#> 20 conditional complaints    advance   1 0.985 0.0857233039988826 0.97
#> 21 conditional privileges   learning   0 0.175  0.239686242720551    0
#> 22 conditional privileges     raises 0.5  0.36  0.257022578892606 0.03
#> 23 conditional privileges   critical   1  0.58  0.315588275441214 0.29
#> 24 conditional privileges    advance 0.5 0.565  0.209074439404058 0.16
#> 25 conditional   learning     raises   1 0.675  0.350864732633619 0.48
#> 26 conditional   learning   critical   1  0.79  0.258003210378585 0.59
#> 27 conditional   learning    advance   1 0.785  0.248784925978122 0.57
#> 28 conditional     raises   critical   1 0.675               0.25 0.36
#> 29 conditional     raises    advance 0.5 0.595  0.197138622201831 0.19
#> 30 conditional   critical    advance 0.5 0.505  0.279745555384846 0.16
#> 31     general complaints privileges   1     1                  0    1
#> 32     general complaints   learning   1  0.97  0.171446607997765 0.97
#> 33     general complaints     raises   1     1                  0    1
#> 34     general complaints   critical   1     1                  0    1
#> 35     general complaints    advance   1     1                  0    1
#> 36     general privileges   learning   0  0.08  0.272659924344291 0.08
#> 37     general privileges     raises   0  0.06  0.238683256575942 0.06
#> 38     general privileges   critical   1  0.76  0.429234695990928 0.76
#> 39     general privileges    advance   1  0.71  0.456048021572069 0.71
#> 40     general   learning     raises   1  0.65  0.479372485441102 0.65
#> 41     general   learning   critical   1  0.93  0.256432399976243 0.93
#> 42     general   learning    advance   1  0.98   0.14070529413629 0.98
#> 43     general     raises   critical   1  0.97  0.171446607997765 0.97
#> 44     general     raises    advance   1  0.98   0.14070529413629 0.98
#> 45     general   critical    advance   0  0.41   0.49431107042371 0.41
#>     Pji Pnoij  Rep
#> 1     0  0.04 0.96
#> 2     0  0.13 0.87
#> 3     0  0.03 0.97
#> 4     0  0.02 0.98
#> 5     0  0.04 0.96
#> 6  0.41  0.59 0.41
#> 7  0.08  0.92 0.92
#> 8  0.05  0.92 0.03
#> 9     0  0.98 0.98
#> 10 0.05  0.65  0.3
#> 11    0  0.55 0.45
#> 12    0   0.7  0.3
#> 13    0  0.87 0.13
#> 14    0  0.93 0.93
#> 15 0.04  0.93 0.93
#> 16    0  0.02 0.98
#> 17    0   0.1  0.9
#> 18    0  0.01 0.99
#> 19    0  0.02 0.98
#> 20    0  0.03 0.97
#> 21 0.65  0.35 0.65
#> 22 0.31  0.66 0.66
#> 23 0.13  0.58 0.29
#> 24 0.03  0.81 0.81
#> 25 0.13  0.39 0.48
#> 26 0.01   0.4 0.59
#> 27    0  0.43 0.57
#> 28 0.01  0.63 0.36
#> 29    0  0.81 0.81
#> 30 0.15  0.69 0.69
#> 31    0     0    1
#> 32 0.03     0 0.97
#> 33    0     0    1
#> 34    0     0    1
#> 35    0     0    1
#> 36 0.92     0 0.92
#> 37 0.94     0 0.94
#> 38 0.24     0 0.76
#> 39 0.29     0 0.71
#> 40 0.35     0 0.65
#> 41 0.07     0 0.93
#> 42 0.02     0 0.98
#> 43 0.03     0 0.97
#> 44 0.02     0 0.98
#> 45 0.59     0 0.59
```

We could also use only the correlation or covariance matrix. As example, we use ability.cov matrix to show dominance of 5 specific skills over general intelligence. The bigger average contribution is for reading, but we can see on level 1, vocab, that picture and blocks dominates reading. So, reading dominates completely only maze and vocabulary, blocks dominates picture and maze and picture dominates maze.

``` r
lmwithcov<-lmWithCov(general~picture+blocks+maze+reading+vocab, ability.cov$cov)
da.cov<-dominanceAnalysis(lmwithcov)
print(da.cov)
#> 
#> Dominance analysis
#> Predictors: picture, blocks, maze, reading, vocab 
#> Fit-indexes: r2 
#> 
#> * Fit:  r2 
#>          complete         conditional        rank.general
#> picture      maze                maze                maze
#> blocks  pctr,maze      pctr,maze,vocb      pctr,maze,vocb
#> maze                                                     
#> reading maze,vocb pctr,blck,maze,vocb pctr,blck,maze,vocb
#> vocab                                           pctr,maze
summary(da.cov)
#> $r2
#>                                             model level       fit picture
#> 1                                               1     0  0.000000 5.35700
#> pctr                                      picture     1  5.357027      NA
#> blck                                       blocks     1  7.499052 0.83000
#> maze                                         maze     1  2.853948 4.10600
#> rdng                                      reading     1  8.188921 2.62100
#> vocb                                        vocab     1  6.520337 3.07800
#> Avl1                              Average level 1     1        NA 2.65875
#> pctr+b                             picture+blocks     2  8.328904      NA
#> pctr+m                               picture+maze     2  6.960447      NA
#> pctr+r                            picture+reading     2 10.810415      NA
#> pctr+v                              picture+vocab     2  9.598604      NA
#> blcks+m                               blocks+maze     2  7.775123 0.91900
#> blcks+r                            blocks+reading     2 11.592318 0.56900
#> blcks+v                              blocks+vocab     2 10.349156 0.69600
#> mz+r                                 maze+reading     2  9.588688 2.11900
#> mz+v                                   maze+vocab     2  7.862802 2.56000
#> rdn+                                reading+vocab     2  8.412198 2.54800
#> Avl2                              Average level 2     2        NA 1.56850
#> pctr+blcks+m                  picture+blocks+maze     3  8.693833      NA
#> pctr+blcks+r               picture+blocks+reading     3 12.161278      NA
#> pctr+blcks+v                 picture+blocks+vocab     3 11.045098      NA
#> pctr+mz+r                    picture+maze+reading     3 11.707443      NA
#> pctr+mz+v                      picture+maze+vocab     3 10.423243      NA
#> pctr+r+                     picture+reading+vocab     3 10.960495      NA
#> blcks+mz+r                    blocks+maze+reading     3 11.805668 0.63600
#> blcks+mz+v                      blocks+maze+vocab     3 10.513223 0.76200
#> blcks+r+                     blocks+reading+vocab     3 11.644463 0.57700
#> mz++                           maze+reading+vocab     3  9.698091 2.08800
#> Avl3                              Average level 3     3        NA 1.01575
#> pctr+blcks+mz+r       picture+blocks+maze+reading     4 12.441511      NA
#> pctr+blcks+mz+v         picture+blocks+maze+vocab     4 11.275507      NA
#> pctr+blcks+r+        picture+blocks+reading+vocab     4 12.221094      NA
#> pctr+m++               picture+maze+reading+vocab     4 11.785860      NA
#> b+++                    blocks+maze+reading+vocab     4 11.843586 0.64100
#> Avl4                              Average level 4     4        NA 0.64100
#> p++++           picture+blocks+maze+reading+vocab     5 12.484276      NA
#>                   blocks    maze  reading  vocab
#> 1               7.499000 2.85400 8.189000 6.5200
#> pctr            2.972000 1.60300 5.453000 4.2420
#> blck                  NA 0.27600 4.093000 2.8500
#> maze            4.921000      NA 6.735000 5.0090
#> rdng            3.403000 1.40000       NA 0.2230
#> vocb            3.829000 1.34200 1.892000     NA
#> Avl1            3.781250 1.15525 4.543250 3.0810
#> pctr+b                NA 0.36500 3.832000 2.7160
#> pctr+m          1.733000      NA 4.747000 3.4630
#> pctr+r          1.351000 0.89700       NA 0.1500
#> pctr+v          1.446000 0.82500 1.362000     NA
#> blcks+m               NA      NA 4.031000 2.7380
#> blcks+r               NA 0.21300       NA 0.0520
#> blcks+v               NA 0.16400 1.295000     NA
#> mz+r            2.217000      NA       NA 0.1090
#> mz+v            2.650000      NA 1.835000     NA
#> rdn+            3.232000 1.28600       NA     NA
#> Avl2            2.104833 0.62500 2.850333 1.5380
#> pctr+blcks+m          NA      NA 3.748000 2.5820
#> pctr+blcks+r          NA 0.28000       NA 0.0600
#> pctr+blcks+v          NA 0.23000 1.176000     NA
#> pctr+mz+r       0.734000      NA       NA 0.0780
#> pctr+mz+v       0.852000      NA 1.363000     NA
#> pctr+r+         1.261000 0.82500       NA     NA
#> blcks+mz+r            NA      NA       NA 0.0380
#> blcks+mz+v            NA      NA 1.330000     NA
#> blcks+r+              NA 0.19900       NA     NA
#> mz++            2.145000      NA       NA     NA
#> Avl3            1.248000 0.38350 1.904250 0.6895
#> pctr+blcks+mz+r       NA      NA       NA 0.0430
#> pctr+blcks+mz+v       NA      NA 1.209000     NA
#> pctr+blcks+r+         NA 0.26300       NA     NA
#> pctr+m++        0.698000      NA       NA     NA
#> b+++                  NA      NA       NA     NA
#> Avl4            0.698000 0.26300 1.209000 0.0430
#> p++++                 NA      NA       NA     NA
```

Hierarchical Linear Models
--------------------------

For Hierarchical Linear Models using lme4, you should provide a null model (see Luo and Azen, 2013).

Using npk dataset, we could see that using rb.r2.1 and sb.r2.1 index, that shows influence of predictors on individual data, clearly phosphate dominates over potassium and nitrogen, and potassium dominates over nitrogen.

``` r
library(lme4)
#> Loading required package: Matrix
lmer.npk.1<-lmer(yield~N+P+K+(1|block),npk)
lmer.npk.0<-lmer(yield~1+(1|block),npk)
da.lmer<-dominanceAnalysis(lmer.npk.1,null.model=lmer.npk.0)
print(da.lmer)
#> 
#> Dominance analysis
#> Predictors: N, P, K 
#> Fit-indexes: rb.r2.1, rb.r2.2, sb.r2.1, sb.r2.2 
#> 
#> * Fit:  rb.r2.1 
#>   complete conditional rank.general
#> N      P,K         P,K          P,K
#> P                                  
#> K        P           P            P
#> * Fit:  rb.r2.2 
#>   complete conditional rank.general
#> N                                  
#> P      N,K         N,K          N,K
#> K        N           N            N
#> * Fit:  sb.r2.1 
#>   complete conditional rank.general
#> N      P,K         P,K          P,K
#> P                                  
#> K        P           P            P
#> * Fit:  sb.r2.2 
#>   complete conditional rank.general
#> N                               P,K
#> P                                  
#> K                                 P
summary(da.lmer)
#> $rb.r2.1
#>                          model level         fit      N      P     K
#> (1|bl)           ( 1 | block )     0  0.00000000 0.3170 -0.042 0.130
#> (1|bl)+N       ( 1 | block )+N     1  0.31714188     NA -0.025 0.158
#> (1|bl)+P       ( 1 | block )+P     1 -0.04213549 0.3340     NA 0.136
#> (1|b)+K        ( 1 | block )+K     1  0.13027315 0.3450 -0.037    NA
#> Avl1           Average level 1     1          NA 0.3395 -0.031 0.147
#> (1|bl)+N+P   ( 1 | block )+N+P     2  0.29219427     NA     NA 0.167
#> (1|b)+N+K    ( 1 | block )+N+K     2  0.47537847     NA -0.016    NA
#> (1|b)+P+     ( 1 | block )+P+K     2  0.09364624 0.3660     NA    NA
#> Avl2           Average level 2     2          NA 0.3660 -0.016 0.167
#> (1|b)+N+P+ ( 1 | block )+N+P+K     3  0.45931679     NA     NA    NA
#> 
#> $rb.r2.2
#>                          model level         fit      N      P       K
#> (1|bl)           ( 1 | block )     0  0.00000000 -0.241 0.0320 -0.0990
#> (1|bl)+N       ( 1 | block )+N     1 -0.24055315     NA 0.0190 -0.1200
#> (1|bl)+P       ( 1 | block )+P     1  0.03195977 -0.254     NA -0.1030
#> (1|b)+K        ( 1 | block )+K     1 -0.09881260 -0.262 0.0280      NA
#> Avl1           Average level 1     1          NA -0.258 0.0235 -0.1115
#> (1|bl)+N+P   ( 1 | block )+N+P     2 -0.22163027     NA     NA -0.1270
#> (1|b)+N+K    ( 1 | block )+N+K     2 -0.36057613     NA 0.0120      NA
#> (1|b)+P+     ( 1 | block )+P+K     2 -0.07103097 -0.277     NA      NA
#> Avl2           Average level 2     2          NA -0.277 0.0120 -0.1270
#> (1|b)+N+P+ ( 1 | block )+N+P+K     3 -0.34839330     NA     NA      NA
#> 
#> $sb.r2.1
#>                          model level         fit     N       P     K
#> (1|bl)           ( 1 | block )     0  0.00000000 0.179 -0.0240 0.073
#> (1|bl)+N       ( 1 | block )+N     1  0.17889368    NA -0.0140 0.089
#> (1|bl)+P       ( 1 | block )+P     1 -0.02376786 0.189      NA 0.077
#> (1|b)+K        ( 1 | block )+K     1  0.07348460 0.195 -0.0210    NA
#> Avl1           Average level 1     1          NA 0.192 -0.0175 0.083
#> (1|bl)+N+P   ( 1 | block )+N+P     2  0.16482122    NA      NA 0.094
#> (1|b)+N+K    ( 1 | block )+N+K     2  0.26815191    NA -0.0090    NA
#> (1|b)+P+     ( 1 | block )+P+K     2  0.05282406 0.206      NA    NA
#> Avl2           Average level 2     2          NA 0.206 -0.0090 0.094
#> (1|b)+N+P+ ( 1 | block )+N+P+K     3  0.25909183    NA      NA    NA
#> 
#> $sb.r2.2
#>                          model level           fit  N  P  K
#> (1|bl)           ( 1 | block )     0  0.000000e+00  0  0  0
#> (1|bl)+N       ( 1 | block )+N     1 -2.575519e-09 NA  0  0
#> (1|bl)+P       ( 1 | block )+P     1 -7.510372e-08  0 NA  0
#> (1|b)+K        ( 1 | block )+K     1  1.751567e-09  0  0 NA
#> Avl1           Average level 1     1            NA  0  0  0
#> (1|bl)+N+P   ( 1 | block )+N+P     2  1.389686e-08 NA NA  0
#> (1|b)+N+K    ( 1 | block )+N+K     2 -1.563879e-08 NA  0 NA
#> (1|b)+P+     ( 1 | block )+P+K     2 -3.448619e-11  0 NA NA
#> Avl2           Average level 2     2            NA  0  0  0
#> (1|b)+N+P+ ( 1 | block )+N+P+K     3 -1.537498e-08 NA NA NA
```

Logistic regression
-------------------

For logistic regression (experimental), see Azen and Traxel, 2009.

As example, we use the esoph dataset. We could conclude that age and alcohol dominates completely tobacco, and age shows general dominance over alcohol and tobacco

``` r
glm.esoph<-glm(cbind(ncases,ncontrols)~agegp+alcgp+tobgp, esoph,family="binomial")
da.esoph<-dominanceAnalysis(glm.esoph)
print(da.esoph)
#> 
#> Dominance analysis
#> Predictors: agegp, alcgp, tobgp 
#> Fit-indexes: r2.m, r2.cs, r2.n, r2.e 
#> 
#> * Fit:  r2.m 
#>       complete conditional rank.general
#> agegp     tbgp        tbgp    alcg,tbgp
#> alcgp     tbgp        tbgp         tbgp
#> tobgp                                  
#> * Fit:  r2.cs 
#>       complete conditional rank.general
#> agegp     tbgp        tbgp    alcg,tbgp
#> alcgp     tbgp        tbgp         tbgp
#> tobgp                                  
#> * Fit:  r2.n 
#>       complete conditional rank.general
#> agegp     tbgp        tbgp    alcg,tbgp
#> alcgp     tbgp        tbgp         tbgp
#> tobgp                                  
#> * Fit:  r2.e 
#>       complete conditional rank.general
#> agegp     tbgp        tbgp    alcg,tbgp
#> alcgp     tbgp        tbgp         tbgp
#> tobgp
summary(da.esoph)
#> $r2.m
#>                    model level         fit  agegp  alcgp tobgp
#> 1                      1     0 -0.64900687 0.3880 0.3890 0.078
#> aggp               agegp     1 -0.26118844     NA 0.3280 0.084
#> alcg               alcgp     1 -0.25976618 0.3270     NA 0.032
#> tbgp               tobgp     1 -0.57107419 0.3940 0.3430    NA
#> Avl1     Average level 1     1          NA 0.3605 0.3355 0.058
#> aggp+l       agegp+alcgp     2  0.06683658     NA     NA 0.047
#> aggp+t       agegp+tobgp     2 -0.17720365     NA 0.2910    NA
#> alc+         alcgp+tobgp     2 -0.22761831 0.3410     NA    NA
#> Avl2     Average level 2     2          NA 0.3410 0.2910 0.047
#> ag++   agegp+alcgp+tobgp     3  0.11347709     NA     NA    NA
#> 
#> $r2.cs
#>                    model level        fit  agegp  alcgp  tobgp
#> 1                      1     0 -4.3436923 3.3810 3.3880 0.9740
#> aggp               agegp     1 -0.9629755     NA 1.1210 0.3830
#> alcg               alcgp     1 -0.9557794 1.1140     NA 0.1560
#> tbgp               tobgp     1 -3.3696064 2.7890 2.5700     NA
#> Avl1     Average level 1     1         NA 1.9515 1.8455 0.2695
#> aggp+l       agegp+alcgp     2  0.1585180     NA     NA 0.0950
#> aggp+t       agegp+tobgp     2 -0.5802598     NA 0.8340     NA
#> alc+         alcgp+tobgp     2 -0.7999772 1.0540     NA     NA
#> Avl2     Average level 2     2         NA 1.0540 0.8340 0.0950
#> ag++   agegp+alcgp+tobgp     3  0.2539999     NA     NA     NA
#> 
#> $r2.n
#>                    model level        fit agegp  alcgp  tobgp
#> 1                      1     0 -4.6989392 3.657 3.6650 1.0540
#> aggp               agegp     1 -1.0417320    NA 1.2130 0.4140
#> alcg               alcgp     1 -1.0339473 1.205     NA 0.1690
#> tbgp               tobgp     1 -3.6451881 3.017 2.7800     NA
#> Avl1     Average level 1     1         NA 2.111 1.9965 0.2915
#> aggp+l       agegp+alcgp     2  0.1714824    NA     NA 0.1030
#> aggp+t       agegp+tobgp     2 -0.6277161    NA 0.9020     NA
#> alc+         alcgp+tobgp     2 -0.8654030 1.140     NA     NA
#> Avl2     Average level 2     2         NA 1.140 0.9020 0.1030
#> ag++   agegp+alcgp+tobgp     3  0.2747731    NA     NA     NA
#> 
#> $r2.e
#>                    model level        fit agegp  alcgp tobgp
#> 1                      1     0 -2.6385557 1.818 1.8230 0.428
#> aggp               agegp     1 -0.8207153    NA 0.9840 0.297
#> alcg               alcgp     1 -0.8154179 0.979     NA 0.117
#> tbgp               tobgp     1 -2.2109579 1.687 1.5130    NA
#> Avl1     Average level 1     1         NA 1.333 1.2485 0.207
#> aggp+l       agegp+alcgp     2  0.1635838    NA     NA 0.104
#> aggp+t       agegp+tobgp     2 -0.5239075    NA 0.7910    NA
#> alc+         alcgp+tobgp     2 -0.6981907 0.965     NA    NA
#> Avl2     Average level 2     2         NA 0.965 0.7910 0.104
#> ag++   agegp+alcgp+tobgp     3  0.2673090    NA     NA    NA
```

Installation
------------

You can install the github version of dominanceanalysis from [github](https://github.com/clbustos/dominanceanalysis) with:

``` r
install_github("clbustos/dominanceanalysis")
```
