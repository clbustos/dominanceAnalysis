
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
#> * Fit index:  r2 
#>                            complete              conditional
#> complaints prvl,lrnn,rass,crtc,advn prvl,lrnn,rass,crtc,advn
#> privileges                     crtc                     crtc
#> learning        prvl,rass,crtc,advn      prvl,rass,crtc,advn
#> raises                         crtc                     crtc
#> critical                                                    
#> advance                                                     
#>                             general
#> complaints prvl,lrnn,rass,crtc,advn
#> privileges                crtc,advn
#> learning        prvl,rass,crtc,advn
#> raises               prvl,crtc,advn
#> critical                           
#> advance                        crtc
#> 
#> Average contribution:
#>  complaints  privileges    learning      raises    critical     advance 
#> 0.370816194 0.050903793 0.155765990 0.120345079 0.006588723 0.028182213
  summary(da.attitude)
#> 
#> * Fit index:  r2 
#> 
#> Average contribution of each variable:
#> 
#>  complaints  privileges    learning      raises    critical     advance 
#> 0.370816194 0.050903793 0.155765990 0.120345079 0.006588723 0.028182213 
#> 
#> Dominance Analysis matrix:
#>                                                   model level   fit
#>                                                       1     0     0
#>                                              complaints     1 0.681
#>                                              privileges     1 0.182
#>                                                learning     1 0.389
#>                                                  raises     1 0.348
#>                                                critical     1 0.024
#>                                                 advance     1 0.024
#>                                         Average level 1     1      
#>                                   complaints+privileges     2 0.683
#>                                     complaints+learning     2 0.708
#>                                       complaints+raises     2 0.684
#>                                     complaints+critical     2 0.681
#>                                      complaints+advance     2 0.682
#>                                     privileges+learning     2 0.408
#>                                       privileges+raises     2 0.382
#>                                     privileges+critical     2 0.191
#>                                      privileges+advance     2 0.182
#>                                         learning+raises     2 0.451
#>                                       learning+critical     2 0.396
#>                                        learning+advance     2 0.432
#>                                         raises+critical     2 0.353
#>                                          raises+advance     2 0.399
#>                                        critical+advance     2 0.038
#>                                         Average level 2     2      
#>                          complaints+privileges+learning     3 0.715
#>                            complaints+privileges+raises     3 0.686
#>                          complaints+privileges+critical     3 0.683
#>                           complaints+privileges+advance     3 0.683
#>                              complaints+learning+raises     3 0.708
#>                            complaints+learning+critical     3 0.708
#>                             complaints+learning+advance     3 0.726
#>                              complaints+raises+critical     3 0.684
#>                               complaints+raises+advance     3  0.69
#>                             complaints+critical+advance     3 0.682
#>                              privileges+learning+raises     3 0.459
#>                            privileges+learning+critical     3 0.413
#>                             privileges+learning+advance     3 0.458
#>                              privileges+raises+critical     3 0.386
#>                               privileges+raises+advance     3 0.443
#>                             privileges+critical+advance     3 0.191
#>                                learning+raises+critical     3 0.451
#>                                 learning+raises+advance     3 0.552
#>                               learning+critical+advance     3 0.453
#>                                 raises+critical+advance     3 0.401
#>                                         Average level 3     3      
#>                   complaints+privileges+learning+raises     4 0.715
#>                 complaints+privileges+learning+critical     4 0.715
#>                  complaints+privileges+learning+advance     4 0.729
#>                   complaints+privileges+raises+critical     4 0.686
#>                    complaints+privileges+raises+advance     4  0.69
#>                  complaints+privileges+critical+advance     4 0.684
#>                     complaints+learning+raises+critical     4 0.708
#>                      complaints+learning+raises+advance     4 0.729
#>                    complaints+learning+critical+advance     4 0.727
#>                      complaints+raises+critical+advance     4  0.69
#>                     privileges+learning+raises+critical     4 0.459
#>                      privileges+learning+raises+advance     4 0.563
#>                    privileges+learning+critical+advance     4 0.476
#>                      privileges+raises+critical+advance     4 0.445
#>                        learning+raises+critical+advance     4 0.553
#>                                         Average level 4     4      
#>          complaints+privileges+learning+raises+critical     5 0.715
#>           complaints+privileges+learning+raises+advance     5 0.732
#>         complaints+privileges+learning+critical+advance     5 0.731
#>           complaints+privileges+raises+critical+advance     5 0.691
#>             complaints+learning+raises+critical+advance     5 0.729
#>             privileges+learning+raises+critical+advance     5 0.564
#>                                         Average level 5     5      
#>  complaints+privileges+learning+raises+critical+advance     6 0.733
#>  complaints privileges learning raises critical advance
#>       0.681      0.182    0.389  0.348    0.024   0.024
#>                  0.002    0.027  0.003        0   0.001
#>       0.501               0.226    0.2    0.009       0
#>       0.319      0.019           0.062    0.007   0.043
#>       0.336      0.033    0.102           0.005    0.05
#>       0.657      0.166    0.372  0.329            0.013
#>       0.658      0.158    0.408  0.375    0.014        
#>       0.494      0.076    0.227  0.194    0.007   0.021
#>                           0.032  0.003        0       0
#>                  0.007               0        0   0.018
#>                  0.002    0.024               0   0.006
#>                  0.002    0.027  0.003            0.001
#>                  0.001    0.043  0.007        0        
#>       0.307                      0.051    0.005    0.05
#>       0.305               0.077           0.004   0.061
#>       0.493               0.222  0.195                0
#>       0.502               0.276  0.261    0.009        
#>       0.258      0.008                        0   0.102
#>       0.312      0.016           0.055            0.057
#>       0.293      0.026            0.12    0.021        
#>       0.331      0.033    0.098                   0.048
#>       0.291      0.044    0.154           0.003        
#>       0.645      0.153    0.416  0.363                 
#>       0.374      0.029    0.137  0.106    0.004   0.034
#>                                      0        0   0.014
#>                           0.029               0   0.004
#>                           0.032  0.003                0
#>                           0.046  0.007        0        
#>                  0.007                        0    0.02
#>                  0.007               0            0.019
#>                  0.004           0.003    0.002        
#>                  0.002    0.024                   0.005
#>                  0.001    0.039               0        
#>                  0.001    0.045  0.007                 
#>       0.257                                   0   0.104
#>       0.302                      0.046            0.063
#>       0.271                      0.105    0.018        
#>       0.301               0.073                   0.059
#>       0.247                0.12           0.002        
#>       0.493               0.285  0.254                 
#>       0.257      0.008                            0.102
#>       0.176      0.011                    0.001        
#>       0.274      0.022             0.1                 
#>       0.288      0.044    0.152                        
#>       0.287      0.011    0.084  0.052    0.002   0.039
#>                                               0   0.017
#>                                      0            0.016
#>                                  0.002    0.002        
#>                           0.029                   0.004
#>                           0.041               0        
#>                           0.047  0.007                 
#>                  0.007                            0.021
#>                  0.003                    0.001        
#>                  0.004           0.002                 
#>                  0.001     0.04                        
#>       0.256                                       0.105
#>       0.169                               0.001        
#>       0.255                      0.088                 
#>       0.246               0.119                        
#>       0.176      0.011                                 
#>        0.22      0.005    0.055   0.02    0.001   0.033
#>                                                   0.017
#>                                           0.001        
#>                                  0.002                 
#>                           0.042                        
#>                  0.003                                 
#>       0.169                                            
#>       0.169      0.003    0.042  0.002    0.001   0.017
#> 
```

To evaluate the robustness of our results, we could use bootstrap analysis (Azen and Bodescu, 2006). We could see that complete dominance of complaints over all other variables is fairly robust, but complete dominance of learning isn't.

``` r
  bda.attitude=bootDominanceAnalysis(lm.attitude, R=100)
  summary(bda.attitude)
#> Dominance Analysis
#> ==================
#> Fit index: r2 
#>      dominance          i          j Dij  mDij            SE.Dij.  Pij
#> 1     complete complaints privileges   1 0.965  0.128216199988121 0.93
#> 2     complete complaints   learning   1  0.91  0.193061459832685 0.82
#> 3     complete complaints     raises   1  0.97  0.119341628287971 0.94
#> 4     complete complaints   critical   1  0.97  0.119341628287971 0.94
#> 5     complete complaints    advance   1  0.97  0.119341628287971 0.94
#> 6     complete privileges   learning   0  0.32  0.261309831967395 0.02
#> 7     complete privileges     raises 0.5 0.475  0.148647097502641 0.02
#> 8     complete privileges   critical   1   0.5  0.174077655955698 0.06
#> 9     complete privileges    advance 0.5  0.51 0.0703526470681448 0.02
#> 10    complete   learning     raises   1  0.63  0.252462618495043 0.29
#> 11    complete   learning   critical   1 0.725  0.259904799975886 0.46
#> 12    complete   learning    advance   1 0.685  0.242618293546955 0.37
#> 13    complete     raises   critical   1 0.555   0.17254775360093 0.12
#> 14    complete     raises    advance 0.5  0.52 0.0984731927834662 0.04
#> 15    complete   critical    advance 0.5   0.5  0.158910431540932 0.05
#> 16 conditional complaints privileges   1 0.975  0.109521456778795 0.95
#> 17 conditional complaints   learning   1  0.94  0.163299316185545 0.88
#> 18 conditional complaints     raises   1  0.99 0.0703526470681448 0.98
#> 19 conditional complaints   critical   1  0.98 0.0984731927834662 0.96
#> 20 conditional complaints    advance   1 0.975  0.109521456778795 0.95
#> 21 conditional privileges   learning   0 0.225  0.287579589334883 0.04
#> 22 conditional privileges     raises 0.5  0.36  0.275973941091575 0.05
#> 23 conditional privileges   critical   1  0.59  0.296273147243853 0.28
#> 24 conditional privileges    advance 0.5  0.54    0.1836773631599 0.11
#> 25 conditional   learning     raises   1 0.665  0.326095666696729 0.43
#> 26 conditional   learning   critical   1  0.82  0.251460381039088 0.65
#> 27 conditional   learning    advance   1 0.765  0.250806779023296 0.53
#> 28 conditional     raises   critical   1  0.64  0.247002228755331  0.3
#> 29 conditional     raises    advance 0.5  0.62  0.214617347995464 0.24
#> 30 conditional   critical    advance 0.5  0.45  0.297294195005282 0.13
#> 31     general complaints privileges   1     1                  0    1
#> 32     general complaints   learning   1  0.98   0.14070529413629 0.98
#> 33     general complaints     raises   1  0.99                0.1 0.99
#> 34     general complaints   critical   1     1                  0    1
#> 35     general complaints    advance   1     1                  0    1
#> 36     general privileges   learning   0  0.08  0.272659924344291 0.08
#> 37     general privileges     raises   0  0.14  0.348735088019777 0.14
#> 38     general privileges   critical   1  0.79  0.409360180740332 0.79
#> 39     general privileges    advance   1  0.76  0.429234695990928 0.76
#> 40     general   learning     raises   1  0.64  0.482418151324422 0.64
#> 41     general   learning   critical   1  0.97  0.171446607997765 0.97
#> 42     general   learning    advance   1     1                  0    1
#> 43     general     raises   critical   1  0.94  0.238683256575942 0.94
#> 44     general     raises    advance   1  0.99                0.1 0.99
#> 45     general   critical    advance   0  0.36  0.482418151324422 0.36
#>     Pji Pnoij  Rep
#> 1     0  0.07 0.93
#> 2     0  0.18 0.82
#> 3     0  0.06 0.94
#> 4     0  0.06 0.94
#> 5     0  0.06 0.94
#> 6  0.38   0.6 0.38
#> 7  0.07  0.91 0.91
#> 8  0.06  0.88 0.06
#> 9     0  0.98 0.98
#> 10 0.03  0.68 0.29
#> 11 0.01  0.53 0.46
#> 12    0  0.63 0.37
#> 13 0.01  0.87 0.12
#> 14    0  0.96 0.96
#> 15 0.05   0.9  0.9
#> 16    0  0.05 0.95
#> 17    0  0.12 0.88
#> 18    0  0.02 0.98
#> 19    0  0.04 0.96
#> 20    0  0.05 0.95
#> 21 0.59  0.37 0.59
#> 22 0.33  0.62 0.62
#> 23  0.1  0.62 0.28
#> 24 0.03  0.86 0.86
#> 25  0.1  0.47 0.43
#> 26 0.01  0.34 0.65
#> 27    0  0.47 0.53
#> 28 0.02  0.68  0.3
#> 29    0  0.76 0.76
#> 30 0.23  0.64 0.64
#> 31    0     0    1
#> 32 0.02     0 0.98
#> 33 0.01     0 0.99
#> 34    0     0    1
#> 35    0     0    1
#> 36 0.92     0 0.92
#> 37 0.86     0 0.86
#> 38 0.21     0 0.79
#> 39 0.24     0 0.76
#> 40 0.36     0 0.64
#> 41 0.03     0 0.97
#> 42    0     0    1
#> 43 0.06     0 0.94
#> 44 0.01     0 0.99
#> 45 0.64     0 0.64
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
#> * Fit index:  r2 
#>          complete         conditional             general
#> picture      maze                maze                maze
#> blocks  pctr,maze      pctr,maze,vocb      pctr,maze,vocb
#> maze                                                     
#> reading maze,vocb pctr,blck,maze,vocb pctr,blck,maze,vocb
#> vocab                                           pctr,maze
#> 
#> Average contribution:
#>  picture   blocks     maze  reading    vocab 
#> 2.248179 3.066392 1.056265 3.739114 2.374326
summary(da.cov)
#> 
#> * Fit index:  r2 
#> 
#> Average contribution of each variable:
#> 
#>  picture   blocks     maze  reading    vocab 
#> 2.248179 3.066392 1.056265 3.739114 2.374326 
#> 
#> Dominance Analysis matrix:
#>                              model level    fit picture blocks  maze
#>                                  1     0      0   5.357  7.499 2.854
#>                            picture     1  5.357          2.972 1.603
#>                             blocks     1  7.499    0.83        0.276
#>                               maze     1  2.854   4.106  4.921      
#>                            reading     1  8.189   2.621  3.403   1.4
#>                              vocab     1   6.52   3.078  3.829 1.342
#>                    Average level 1     1          2.659  3.781 1.155
#>                     picture+blocks     2  8.329                0.365
#>                       picture+maze     2   6.96          1.733      
#>                    picture+reading     2  10.81          1.351 0.897
#>                      picture+vocab     2  9.599          1.446 0.825
#>                        blocks+maze     2  7.775   0.919             
#>                     blocks+reading     2 11.592   0.569        0.213
#>                       blocks+vocab     2 10.349   0.696        0.164
#>                       maze+reading     2  9.589   2.119  2.217      
#>                         maze+vocab     2  7.863    2.56   2.65      
#>                      reading+vocab     2  8.412   2.548  3.232 1.286
#>                    Average level 2     2          1.568  2.105 0.625
#>                picture+blocks+maze     3  8.694                     
#>             picture+blocks+reading     3 12.161                 0.28
#>               picture+blocks+vocab     3 11.045                 0.23
#>               picture+maze+reading     3 11.707          0.734      
#>                 picture+maze+vocab     3 10.423          0.852      
#>              picture+reading+vocab     3  10.96          1.261 0.825
#>                blocks+maze+reading     3 11.806   0.636             
#>                  blocks+maze+vocab     3 10.513   0.762             
#>               blocks+reading+vocab     3 11.644   0.577        0.199
#>                 maze+reading+vocab     3  9.698   2.088  2.145      
#>                    Average level 3     3          1.016  1.248 0.384
#>        picture+blocks+maze+reading     4 12.442                     
#>          picture+blocks+maze+vocab     4 11.276                     
#>       picture+blocks+reading+vocab     4 12.221                0.263
#>         picture+maze+reading+vocab     4 11.786          0.698      
#>          blocks+maze+reading+vocab     4 11.844   0.641             
#>                    Average level 4     4          0.641  0.698 0.263
#>  picture+blocks+maze+reading+vocab     5 12.484                     
#>  reading vocab
#>    8.189  6.52
#>    5.453 4.242
#>    4.093  2.85
#>    6.735 5.009
#>          0.223
#>    1.892      
#>    4.543 3.081
#>    3.832 2.716
#>    4.747 3.463
#>           0.15
#>    1.362      
#>    4.031 2.738
#>          0.052
#>    1.295      
#>          0.109
#>    1.835      
#>               
#>     2.85 1.538
#>    3.748 2.582
#>           0.06
#>    1.176      
#>          0.078
#>    1.363      
#>               
#>          0.038
#>     1.33      
#>               
#>               
#>    1.904  0.69
#>          0.043
#>    1.209      
#>               
#>               
#>               
#>    1.209 0.043
#> 
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
#> Constants: ( 1 | block ) 
#> Fit-indexes: rb.r2.1, rb.r2.2, sb.r2.1, sb.r2.2 
#> 
#> * Fit index:  rb.r2.1 
#>   complete conditional general
#> N      P,K         P,K     P,K
#> P                             
#> K        P           P       P
#> 
#> Average contribution:
#>           N           P           K 
#>  0.34084333 -0.02966148  0.14813494 
#> * Fit index:  rb.r2.2 
#>   complete conditional general
#> N                             
#> P      N,K         N,K     N,K
#> K        N           N       N
#> 
#> Average contribution:
#>           N           P           K 
#> -0.25853075  0.02249829 -0.11236083 
#> * Fit index:  sb.r2.1 
#>   complete conditional general
#> N      P,K         P,K     P,K
#> P                             
#> K        P           P       P
#> 
#> Average contribution:
#>           N           P           K 
#>  0.19226322 -0.01673148  0.08356009 
#> * Fit index:  sb.r2.2 
#>   complete conditional general
#> N                          P,K
#> P                             
#> K                            P
#> 
#> Average contribution:
#>             N             P             K 
#>  5.963033e-09 -2.249891e-08  1.160901e-09
summary(da.lmer)
#> 
#> * Fit index:  rb.r2.1 
#> 
#> Average contribution of each variable:
#> 
#>           N           P           K 
#>  0.34084333 -0.02966148  0.14813494 
#> 
#> Dominance Analysis matrix:
#>                model level    fit     N      P     K
#>        ( 1 | block )     0      0 0.317 -0.042  0.13
#>      ( 1 | block )+N     1  0.317       -0.025 0.158
#>      ( 1 | block )+P     1 -0.042 0.334        0.136
#>      ( 1 | block )+K     1   0.13 0.345 -0.037      
#>      Average level 1     1         0.34 -0.031 0.147
#>    ( 1 | block )+N+P     2  0.292              0.167
#>    ( 1 | block )+N+K     2  0.475       -0.016      
#>    ( 1 | block )+P+K     2  0.094 0.366             
#>      Average level 2     2        0.366 -0.016 0.167
#>  ( 1 | block )+N+P+K     3  0.459                   
#> 
#> * Fit index:  rb.r2.2 
#> 
#> Average contribution of each variable:
#> 
#>           N           P           K 
#> -0.25853075  0.02249829 -0.11236083 
#> 
#> Dominance Analysis matrix:
#>                model level    fit      N     P      K
#>        ( 1 | block )     0      0 -0.241 0.032 -0.099
#>      ( 1 | block )+N     1 -0.241        0.019  -0.12
#>      ( 1 | block )+P     1  0.032 -0.254       -0.103
#>      ( 1 | block )+K     1 -0.099 -0.262 0.028       
#>      Average level 1     1        -0.258 0.024 -0.111
#>    ( 1 | block )+N+P     2 -0.222              -0.127
#>    ( 1 | block )+N+K     2 -0.361        0.012       
#>    ( 1 | block )+P+K     2 -0.071 -0.277             
#>      Average level 2     2        -0.277 0.012 -0.127
#>  ( 1 | block )+N+P+K     3 -0.348                    
#> 
#> * Fit index:  sb.r2.1 
#> 
#> Average contribution of each variable:
#> 
#>           N           P           K 
#>  0.19226322 -0.01673148  0.08356009 
#> 
#> Dominance Analysis matrix:
#>                model level    fit     N      P     K
#>        ( 1 | block )     0      0 0.179 -0.024 0.073
#>      ( 1 | block )+N     1  0.179       -0.014 0.089
#>      ( 1 | block )+P     1 -0.024 0.189        0.077
#>      ( 1 | block )+K     1  0.073 0.195 -0.021      
#>      Average level 1     1        0.192 -0.018 0.083
#>    ( 1 | block )+N+P     2  0.165              0.094
#>    ( 1 | block )+N+K     2  0.268       -0.009      
#>    ( 1 | block )+P+K     2  0.053 0.206             
#>      Average level 2     2        0.206 -0.009 0.094
#>  ( 1 | block )+N+P+K     3  0.259                   
#> 
#> * Fit index:  sb.r2.2 
#> 
#> Average contribution of each variable:
#> 
#>             N             P             K 
#>  5.963033e-09 -2.249891e-08  1.160901e-09 
#> 
#> Dominance Analysis matrix:
#>                model level fit N P K
#>        ( 1 | block )     0   0 0 0 0
#>      ( 1 | block )+N     1   0   0 0
#>      ( 1 | block )+P     1   0 0   0
#>      ( 1 | block )+K     1   0 0 0  
#>      Average level 1     1     0 0 0
#>    ( 1 | block )+N+P     2   0     0
#>    ( 1 | block )+N+K     2   0   0  
#>    ( 1 | block )+P+K     2   0 0    
#>      Average level 2     2     0 0 0
#>  ( 1 | block )+N+P+K     3   0
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
#> * Fit index:  r2.m 
#>       complete conditional   general
#> agegp     tbgp        tbgp alcg,tbgp
#> alcgp     tbgp        tbgp      tbgp
#> tobgp                               
#> 
#> Average contribution:
#>      agegp      alcgp      tobgp 
#> 0.36305016 0.33855396 0.06087984 
#> * Fit index:  r2.cs 
#>       complete conditional   general
#> agegp     tbgp        tbgp alcg,tbgp
#> alcgp     tbgp        tbgp      tbgp
#> tobgp                               
#> 
#> Average contribution:
#>     agegp     alcgp     tobgp 
#> 2.1288386 2.0225780 0.4462756 
#> * Fit index:  r2.n 
#>       complete conditional   general
#> agegp     tbgp        tbgp alcg,tbgp
#> alcgp     tbgp        tbgp      tbgp
#> tobgp                               
#> 
#> Average contribution:
#>    agegp    alcgp    tobgp 
#> 2.302945 2.187994 0.482774 
#> * Fit index:  r2.e 
#>       complete conditional   general
#> agegp     tbgp        tbgp alcg,tbgp
#> alcgp     tbgp        tbgp      tbgp
#> tobgp                               
#> 
#> Average contribution:
#>     agegp     alcgp     tobgp 
#> 1.3721220 1.2876291 0.2461135
summary(da.esoph)
#> 
#> * Fit index:  r2.m 
#> 
#> Average contribution of each variable:
#> 
#>      agegp      alcgp      tobgp 
#> 0.36305016 0.33855396 0.06087984 
#> 
#> Dominance Analysis matrix:
#>              model level    fit agegp alcgp tobgp
#>                  1     0 -0.649 0.388 0.389 0.078
#>              agegp     1 -0.261       0.328 0.084
#>              alcgp     1  -0.26 0.327       0.032
#>              tobgp     1 -0.571 0.394 0.343      
#>    Average level 1     1        0.361 0.336 0.058
#>        agegp+alcgp     2  0.067             0.047
#>        agegp+tobgp     2 -0.177       0.291      
#>        alcgp+tobgp     2 -0.228 0.341            
#>    Average level 2     2        0.341 0.291 0.047
#>  agegp+alcgp+tobgp     3  0.113                  
#> 
#> * Fit index:  r2.cs 
#> 
#> Average contribution of each variable:
#> 
#>     agegp     alcgp     tobgp 
#> 2.1288386 2.0225780 0.4462756 
#> 
#> Dominance Analysis matrix:
#>              model level    fit agegp alcgp tobgp
#>                  1     0 -4.344 3.381 3.388 0.974
#>              agegp     1 -0.963       1.121 0.383
#>              alcgp     1 -0.956 1.114       0.156
#>              tobgp     1  -3.37 2.789  2.57      
#>    Average level 1     1        1.952 1.845  0.27
#>        agegp+alcgp     2  0.159             0.095
#>        agegp+tobgp     2  -0.58       0.834      
#>        alcgp+tobgp     2   -0.8 1.054            
#>    Average level 2     2        1.054 0.834 0.095
#>  agegp+alcgp+tobgp     3  0.254                  
#> 
#> * Fit index:  r2.n 
#> 
#> Average contribution of each variable:
#> 
#>    agegp    alcgp    tobgp 
#> 2.302945 2.187994 0.482774 
#> 
#> Dominance Analysis matrix:
#>              model level    fit agegp alcgp tobgp
#>                  1     0 -4.699 3.657 3.665 1.054
#>              agegp     1 -1.042       1.213 0.414
#>              alcgp     1 -1.034 1.205       0.169
#>              tobgp     1 -3.645 3.017  2.78      
#>    Average level 1     1        2.111 1.996 0.292
#>        agegp+alcgp     2  0.171             0.103
#>        agegp+tobgp     2 -0.628       0.902      
#>        alcgp+tobgp     2 -0.865  1.14            
#>    Average level 2     2         1.14 0.902 0.103
#>  agegp+alcgp+tobgp     3  0.275                  
#> 
#> * Fit index:  r2.e 
#> 
#> Average contribution of each variable:
#> 
#>     agegp     alcgp     tobgp 
#> 1.3721220 1.2876291 0.2461135 
#> 
#> Dominance Analysis matrix:
#>              model level    fit agegp alcgp tobgp
#>                  1     0 -2.639 1.818 1.823 0.428
#>              agegp     1 -0.821       0.984 0.297
#>              alcgp     1 -0.815 0.979       0.117
#>              tobgp     1 -2.211 1.687 1.513      
#>    Average level 1     1        1.333 1.248 0.207
#>        agegp+alcgp     2  0.164             0.104
#>        agegp+tobgp     2 -0.524       0.791      
#>        alcgp+tobgp     2 -0.698 0.965            
#>    Average level 2     2        0.965 0.791 0.104
#>  agegp+alcgp+tobgp     3  0.267
```

Installation
------------

You can install the github version of dominanceanalysis from [github](https://github.com/clbustos/dominanceanalysis) with:

``` r
install_github("clbustos/dominanceanalysis")
```
