
<!-- README.md is generated from README.Rmd. Please edit that file -->
dominanceanalysis
=================

[![Build Status](https://travis-ci.org/clbustos/dominanceAnalysis.svg?branch=master)](https://travis-ci.org/clbustos/dominanceAnalysis) [![codecov](https://codecov.io/gh/clbustos/dominanceAnalysis/branch/master/graph/badge.svg)](https://codecov.io/gh/clbustos/dominanceAnalysis)

Dominance Analysis (Azen and Budescu, 2003, 2006; Azen and Traxel, 2009; Budescu, 1993; Luo and Azen, 2013), for multiple regression models: Ordinary Least Squares, Generalized Linear Models and Hierarchical Linear Models.

**Features**:

-   Provides complete, conditional and general dominance analysis for *lm* (univariate and multivariate), *lmer* and *glm* (family=binomial) models.
-   Covariance / correlation matrixes could be used as input for OLS dominance analysis, using `lmWithCov()` and `mlmWithCov()` methods, respectively.
-   Multiple criteria can be used as fit indexes, which is useful especially for HLM.

Examples
========

Linear regression
-----------------

We could apply dominance analysis directly on the data, using *lm* (see Azen and Budescu, 2003).

The *attitude* data is composed of six predictors of the overall rating of 35 clerical employees of a large financial organization: complaints, privileges, learning, raises, critical and advancement. The method `dominanceAnalysis()` can retrieve all necessary information directly from a *lm* model.

``` r
  library(dominanceanalysis)
  lm.attitude<-lm(rating~.,attitude)
  da.attitude<-dominanceAnalysis(lm.attitude)
```

Using `print()` method on the *dominanceAnalysis* object, we can see that *complaints* completely dominates all other predictors, followed by *learning* (lrnn). The remaining 4 variables (prvl,rass,crtc,advn) don't show a consistent pattern for complete and conditional dominance.

The `print()` method uses `abbreviate`, to allow complex models to be visualized at a glance.

``` r
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
```

The `summary()` method provides the average contribution of each variable. This contribution defines general dominance. Also, shows the complete dominance analysis matrix, that presents all fit differences between levels.

``` r
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

To evaluate the robustness of our results, we can use bootstrap analysis (Azen and Budescu, 2006).

We applied a bootstrap analysis using `bootDominanceAnalysis()` method with *R*<sup>2</sup> as a fit index and 100 permutations. For precise results, you need to run at least 1000 replications.

``` r
  bda.attitude=bootDominanceAnalysis(lm.attitude, R=100)
```

The `summary()` method presents the results for the bootstrap analysis. *Dij* shows the original result, and *mDij*, the mean for Dij on bootstrap samples and *SE.Dij* its standard error. *Pij* is the proportion of bootstrap samples where *i* dominantes *j*, *Pji* is the proportion of bootstrap samples where *j* dominates *i* and *Pnoij* is the proportion of samples where no dominance can be asserted. *Rep* is the proportion of samples where original dominance is replicated.

We can see that the value of complete dominance for *complaints* is fairly robust over all variables (Dij almost equal to mDij, and small SE), contrarily to *learning* (Dij differs from mDij, and bigger SE).

``` r
  summary(bda.attitude)
#> Dominance Analysis
#> ==================
#> Fit index: r2 
#>      dominance          i          j Dij  mDij            SE.Dij.  Pij
#> 1     complete complaints privileges   1  0.98 0.0984731927834662 0.96
#> 2     complete complaints   learning   1  0.95  0.150755672288882  0.9
#> 3     complete complaints     raises   1 0.955  0.143811745632331 0.91
#> 4     complete complaints   critical   1 0.985 0.0857233039988826 0.97
#> 5     complete complaints    advance   1 0.955  0.143811745632331 0.91
#> 6     complete privileges   learning   0  0.31  0.263810461498326 0.02
#> 7     complete privileges     raises 0.5  0.45  0.166666666666667 0.01
#> 8     complete privileges   critical   1 0.535  0.191419471688264 0.11
#> 9     complete privileges    advance 0.5   0.5 0.0710669054518702 0.01
#> 10    complete   learning     raises   1  0.56  0.238683256575942 0.18
#> 11    complete   learning   critical   1  0.72  0.268929790694955 0.46
#> 12    complete   learning    advance   1 0.635  0.223098021669237 0.27
#> 13    complete     raises   critical   1  0.57  0.188293774338254 0.15
#> 14    complete     raises    advance 0.5  0.51 0.0703526470681448 0.02
#> 15    complete   critical    advance 0.5 0.515  0.132096536478043 0.05
#> 16 conditional complaints privileges   1 0.995               0.05 0.99
#> 17 conditional complaints   learning   1 0.955  0.143811745632331 0.91
#> 18 conditional complaints     raises   1 0.995               0.05 0.99
#> 19 conditional complaints   critical   1  0.99 0.0703526470681448 0.98
#> 20 conditional complaints    advance   1  0.97  0.119341628287971 0.94
#> 21 conditional privileges   learning   0 0.205  0.293833939221431 0.05
#> 22 conditional privileges     raises 0.5 0.335  0.284755787624867 0.05
#> 23 conditional privileges   critical   1  0.62  0.310750151352588 0.34
#> 24 conditional privileges    advance 0.5  0.52   0.14070529413629 0.06
#> 25 conditional   learning     raises   1  0.62  0.356186309210063  0.4
#> 26 conditional   learning   critical   1  0.85  0.261116483933547 0.73
#> 27 conditional   learning    advance   1 0.775               0.25 0.55
#> 28 conditional     raises   critical   1  0.73  0.260341655863555 0.47
#> 29 conditional     raises    advance 0.5 0.615  0.211476292340825 0.23
#> 30 conditional   critical    advance 0.5 0.485  0.250806779023296 0.11
#> 31     general complaints privileges   1     1                  0    1
#> 32     general complaints   learning   1  0.98   0.14070529413629 0.98
#> 33     general complaints     raises   1     1                  0    1
#> 34     general complaints   critical   1     1                  0    1
#> 35     general complaints    advance   1     1                  0    1
#> 36     general privileges   learning   0  0.15  0.358870281282637 0.15
#> 37     general privileges     raises   0   0.1  0.301511344577764  0.1
#> 38     general privileges   critical   1  0.74  0.440844002276808 0.74
#> 39     general privileges    advance   1  0.75  0.435194139889245 0.75
#> 40     general   learning     raises   1  0.56  0.498887651569859 0.56
#> 41     general   learning   critical   1  0.93  0.256432399976243 0.93
#> 42     general   learning    advance   1  0.99                0.1 0.99
#> 43     general     raises   critical   1  0.95   0.21904291355759 0.95
#> 44     general     raises    advance   1  0.99                0.1 0.99
#> 45     general   critical    advance   0  0.44  0.498887651569859 0.44
#>     Pji Pnoij  Rep
#> 1     0  0.04 0.96
#> 2     0   0.1  0.9
#> 3     0  0.09 0.91
#> 4     0  0.03 0.97
#> 5     0  0.09 0.91
#> 6   0.4  0.58  0.4
#> 7  0.11  0.88 0.88
#> 8  0.04  0.85 0.11
#> 9  0.01  0.98 0.98
#> 10 0.06  0.76 0.18
#> 11 0.02  0.52 0.46
#> 12    0  0.73 0.27
#> 13 0.01  0.84 0.15
#> 14    0  0.98 0.98
#> 15 0.02  0.93 0.93
#> 16    0  0.01 0.99
#> 17    0  0.09 0.91
#> 18    0  0.01 0.99
#> 19    0  0.02 0.98
#> 20    0  0.06 0.94
#> 21 0.64  0.31 0.64
#> 22 0.38  0.57 0.57
#> 23  0.1  0.56 0.34
#> 24 0.02  0.92 0.92
#> 25 0.16  0.44  0.4
#> 26 0.03  0.24 0.73
#> 27    0  0.45 0.55
#> 28 0.01  0.52 0.47
#> 29    0  0.77 0.77
#> 30 0.14  0.75 0.75
#> 31    0     0    1
#> 32 0.02     0 0.98
#> 33    0     0    1
#> 34    0     0    1
#> 35    0     0    1
#> 36 0.85     0 0.85
#> 37  0.9     0  0.9
#> 38 0.26     0 0.74
#> 39 0.25     0 0.75
#> 40 0.44     0 0.56
#> 41 0.07     0 0.93
#> 42 0.01     0 0.99
#> 43 0.05     0 0.95
#> 44 0.01     0 0.99
#> 45 0.56     0 0.56
```

Another way to perform the dominance analysis is by using a correlation or covariance matrix. As an example, we use the *ability.cov* matrix which is composed of five specific skills that might explain *general intelligence* (general). The biggest average contribution is for predictor *reading* (3.739). Nevertheless, in the ouput of `summary()` method on level 1, we can see that *picture* (3.078) dominates over *reading* (1.892) on 'vocab' submodel.

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

For Hierarchical Linear Models using *lme4*, you should provide a null model (see Luo and Azen, 2013).

As an example, we use *npk* dataset, which contains information about a classical N, P, K (nitrogen, phosphate, potassium) factorial experiment on the growth of peas conducted on 6 blocks.

``` r
library(lme4)
#> Loading required package: Matrix
lmer.npk.1<-lmer(yield~N+P+K+(1|block),npk)
lmer.npk.0<-lmer(yield~1+(1|block),npk)
da.lmer<-dominanceAnalysis(lmer.npk.1,null.model=lmer.npk.0)
```

Using `print()` method, we can see that random effects are modeled as a constant (1 | block).

``` r
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
```

The fit indexes used in the analysis were *rb.r2.1* (R&B *R*<sub>1</sub><sup>2</sup>: Level-1 variance component explained by predictors), *rb.r2.2* (R&B *R*<sub>2</sub><sup>2</sup>: Level-2 variance component explained by predictors), *sb.r2.1* (S&B *R*<sub>1</sub><sup>2</sup>: Level-1 proportional reduction in error predicting scores at Level-1), and *sb.r2.2* (S&B *R*<sub>2</sub><sup>2</sup>: Level-2 proportional reduction in error predicting scores at Level-1). We can see that using *rb.r2.1* and *sb.r2.1* index, that shows influence of predictors on Level-1 variance, clearly *nitrogen* dominates over *potassium* and *phosphate*, and *potassium* dominates over *phosphate*.

``` r
s.da.lmer=summary(da.lmer)
s.da.lmer
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
sm.rb.r2.1=s.da.lmer$rb.r2.1$summary.matrix
# Nitrogen completely dominates  potassium
as.logical(na.omit(sm.rb.r2.1$N > sm.rb.r2.1$K))
#> [1] TRUE TRUE TRUE TRUE
# Nitrogen completely dominates  phosphate
as.logical(na.omit(sm.rb.r2.1$N > sm.rb.r2.1$P))
#> [1] TRUE TRUE TRUE TRUE
# Potassium completely dominates phosphate
as.logical(na.omit(sm.rb.r2.1$K > sm.rb.r2.1$P))
#> [1] TRUE TRUE TRUE TRUE
```

Logistic regression
-------------------

Dominance analysis can be used in logistic regression (see Azen and Traxel, 2009).

As an example, we used the *esoph* dataset, that contains information about a case-control study of (o)esophageal cancer in Ille-et-Vilaine, France.

Looking at the report for standard glm summary method, we can see that the linear effect of each variable was significant (*p* &lt; 0.05 for *agegp.L*, *alcgp.L* and *tobgp.L*), such as the quadratic effect of predictor age (*p* &lt; 0.05 for *agegp.Q*). Even so,it is hard to identify which variable is more important to predict esophageal cancer.

``` r
glm.esoph<-glm(cbind(ncases,ncontrols)~agegp+alcgp+tobgp, esoph,family="binomial")
summary(glm.esoph)
#> 
#> Call:
#> glm(formula = cbind(ncases, ncontrols) ~ agegp + alcgp + tobgp, 
#>     family = "binomial", data = esoph)
#> 
#> Deviance Residuals: 
#>     Min       1Q   Median       3Q      Max  
#> -1.6891  -0.5618  -0.2168   0.2314   2.0642  
#> 
#> Coefficients:
#>             Estimate Std. Error z value Pr(>|z|)    
#> (Intercept) -1.77997    0.19796  -8.992  < 2e-16 ***
#> agegp.L      3.00534    0.65215   4.608 4.06e-06 ***
#> agegp.Q     -1.33787    0.59111  -2.263  0.02362 *  
#> agegp.C      0.15307    0.44854   0.341  0.73291    
#> agegp^4      0.06410    0.30881   0.208  0.83556    
#> agegp^5     -0.19363    0.19537  -0.991  0.32164    
#> alcgp.L      1.49185    0.19935   7.484 7.23e-14 ***
#> alcgp.Q     -0.22663    0.17952  -1.262  0.20680    
#> alcgp.C      0.25463    0.15906   1.601  0.10942    
#> tobgp.L      0.59448    0.19422   3.061  0.00221 ** 
#> tobgp.Q      0.06537    0.18811   0.347  0.72823    
#> tobgp.C      0.15679    0.18658   0.840  0.40071    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> (Dispersion parameter for binomial family taken to be 1)
#> 
#>     Null deviance: 227.241  on 87  degrees of freedom
#> Residual deviance:  53.973  on 76  degrees of freedom
#> AIC: 225.45
#> 
#> Number of Fisher Scoring iterations: 6
```

We performed dominance analysis on this dataset and the results are shown below. The fit indexes were *r2.m* (*R*<sub>*M*</sub><sup>2</sup>: McFadden's measure), *r2.cs* (*R*<sub>*C**S*</sub><sup>2</sup>: Cox and Snell's measure), *r2.n* (*R*<sub>*N*</sub><sup>2</sup>: Nagelkerke's measure) and *r2.e* (*R*<sub>*E*</sub><sup>2</sup>: Estrella's measure). For all fit indexes, we can conclude that *age* and *alcohol* completely dominate *tobacco*, while *age* shows general dominance over both *alcohol* and *tobacco.*

``` r
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

Then, we performed a bootstrap analysis. Using McFadden's measure (*r2.m*), we can see that bootstrap dominance of *age* over *tobacco*, and of *alcohol* over *tobacco* have standard errors (*SE.Dij*) of 0 and reproducibility (*Rep*) equal to 1, so are fairly robust on all levels.Dominance values of *age* over *alcohol* are not easily reproducible and require more research

``` r
da.b.esoph<-bootDominanceAnalysis(glm.esoph,R = 200)
summary(da.b.esoph)$r2.m
#>     dominance     i     j Dij  mDij           SE.Dij.   Pij   Pji Pnoij
#> 1    complete agegp alcgp 0.5  0.65 0.434099310129925  0.57  0.27  0.16
#> 2    complete agegp tobgp   1     1                 0     1     0     0
#> 3    complete alcgp tobgp   1     1                 0     1     0     0
#> 4 conditional agegp alcgp 0.5  0.65 0.434099310129925  0.57  0.27  0.16
#> 5 conditional agegp tobgp   1     1                 0     1     0     0
#> 6 conditional alcgp tobgp   1     1                 0     1     0     0
#> 7     general agegp alcgp   1 0.655 0.476561174209376 0.655 0.345     0
#> 8     general agegp tobgp   1     1                 0     1     0     0
#> 9     general alcgp tobgp   1     1                 0     1     0     0
#>     Rep
#> 1  0.16
#> 2     1
#> 3     1
#> 4  0.16
#> 5     1
#> 6     1
#> 7 0.655
#> 8     1
#> 9     1
```

Set of predictors
-----------------

Budescu (1993) shows that dominance analysis can be applied to groups or set of inseparable predictors.

``` r
m.budescu.5=matrix(c(1,.30,.41,.33,
                .30,1,.16,.57,
                .41,.16,1,.50,
                .33,.57,.50,1), nrow = 4,ncol = 4,byrow = T,
              dimnames = list(c('SES','IQ','nAch','GPA'),
                              c('SES','IQ','nAch','GPA')))
lmCov.b5<-lmWithCov(GPA~SES+IQ+nAch,m.budescu.5)
da.b5<-dominanceAnalysis(lmCov.b5)
print(da.b5)
#> 
#> Dominance analysis
#> Predictors: SES, IQ, nAch 
#> Fit-indexes: r2 
#> 
#> * Fit index:  r2 
#>      complete conditional  general
#> SES                               
#> IQ   SES,nAch    SES,nAch SES,nAch
#> nAch      SES         SES      SES
#> 
#> Average contribution:
#>        SES         IQ       nAch 
#> 0.04408243 0.26589530 0.18649580
summary(da.b5)
#> 
#> * Fit index:  r2 
#> 
#> Average contribution of each variable:
#> 
#>        SES         IQ       nAch 
#> 0.04408243 0.26589530 0.18649580 
#> 
#> Dominance Analysis matrix:
#>            model level   fit   SES    IQ  nAch
#>                1     0     0 0.109 0.325  0.25
#>              SES     1 0.109       0.244  0.16
#>               IQ     1 0.325 0.028       0.172
#>             nAch     1  0.25 0.019 0.246      
#>  Average level 1     1       0.024 0.245 0.166
#>           SES+IQ     2 0.353             0.144
#>         SES+nAch     2 0.269       0.228      
#>          IQ+nAch     2 0.496     0            
#>  Average level 2     2           0 0.228 0.144
#>      SES+IQ+nAch     3 0.496
da.b5.g<-dominanceAnalysis(lmCov.b5,terms = c("SES","IQ+nAch"))
print(da.b5.g)
#> 
#> Dominance analysis
#> Predictors: SES, IQ+nAch 
#> Fit-indexes: r2 
#> 
#> * Fit index:  r2 
#>         complete conditional general
#> SES                                 
#> IQ+nAch      SES         SES     SES
#> 
#> Average contribution:
#>        SES    IQ+nAch 
#> 0.05448274 0.44199079
summary(da.b5.g)
#> 
#> * Fit index:  r2 
#> 
#> Average contribution of each variable:
#> 
#>        SES    IQ+nAch 
#> 0.05448274 0.44199079 
#> 
#> Dominance Analysis matrix:
#>            model level   fit   SES IQ.nAch
#>                1     0     0 0.109   0.496
#>              SES     1 0.109         0.388
#>          IQ+nAch     1 0.496     0        
#>  Average level 1     1           0   0.388
#>      SES+IQ+nAch     2 0.496
```

Installation
------------

You can install the github version of dominanceanalysis from [github](https://github.com/clbustos/dominanceanalysis) with:

``` r
install_github("clbustos/dominanceanalysis")
```

Authors
-------

-   Claudio Bustos Navarrete: Creator and maintainer
-   Filipa Coutinho Soares: Documentation and testing

References
----------

-   Budescu, D. V. (1993). Dominance analysis: A new approach to the problem of relative importance of predictors in multiple regression. Psychological Bulletin, 114(3), 542-551. <doi:10.1037/0033-2909.114.3.542>

-   Azen, R., & Budescu, D. V. (2003). The dominance analysis approach for comparing predictors in multiple regression. Psychological Methods, 8(2), 129-148. <doi:10.1037/1082-989X.8.2.129>

-   Azen, R., & Budescu, D. V. (2006). Comparing Predictors in Multivariate Regression Models: An Extension of Dominance Analysis. Journal of Educational and Behavioral Statistics, 31(2), 157-180. <doi:10.3102/10769986031002157>

-   Azen, R., & Traxel, N. (2009). Using Dominance Analysis to Determine Predictor Importance in Logistic Regression. Journal of Educational and Behavioral Statistics, 34(3), 319-347. <doi:10.3102/1076998609332754>

-   Luo, W., & Azen, R. (2013). Determining Predictor Importance in Hierarchical Linear Models Using Dominance Analysis. Journal of Educational and Behavioral Statistics, 38(1), 3-31. <doi:10.3102/1076998612458319>
