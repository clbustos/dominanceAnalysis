#' Dominance analysis for OLS, GLM and LMM models
#'
#' Dominance analysis Based on Azen and Bodescu(1993) and all their derivations.
#' The dominance of one variable over another is defined by the improvement on
#' prediction over all the subset of other variables, based on one or more fit indexes.
#' The original paper (Azen & Bodescu, 1993) defines that variable \eqn{X_1} dominates \eqn{X_2} when the contribution of \eqn{X_1} are higher on every submodel of predictors that not include \eqn{X_1} or \eqn{X_2}
#' Later, Azen & Bodescu (2003), define two other types of dominance. The original dominance is called complete dominance. Conditional dominance is calculated for average contribution on each level, and general dominance is calculated for the mean of average contribution on each level.
#'
#' Based on the class of model, the method run the function \code{da.<model>.fit}. Currently, four models are implemented:
#' \describe{
#' \item{lm}{ Provides \eqn{R^2} or coefficient of determination. See \code{\link{da.lm.fit}}}
#' \item{glm}{ Provides three of the four fit indexes recommended by Azen & Traxel (2009):  McFadden (1974), Nagelkerke (1991), and Estrella (1998). See \code{\link{da.glm.fit}} }
#' \item{lmerMod}{ Provides  four fit indexes recommended by Lou & Azen (2012). See \code{\link{da.lmerMod}}}
#' \item{lmWithCov}{Provides \eqn{R^2} for a correlation/covariance matrix. See \code{\link{lmWithCov}} to create the model and \code{\link{da.lmWithCov.fit}} for the fit index function}
#' }
#' @param x lm, glm, lmer model
#' @param constants vector of variables to remain unchanged between models
#' @param fit.functions list of functions which provides fit indexes for model.
#' @param data optional data.frame to which fit the formulas
#' @param null.model for mixel models, null model against to test the submodels
#' @param ... Other arguments provided to lm or lmer (not implemented yet)
#' @return
#' \item{predictors}{Vector of predictors}
#' \item{constants}{Vector constant variables}
#' \item{fit.functions}{Name of method used to provide fit indexes}
#' \item{fits}{raw fits indexes \code{\link{daRaw}}}
#' \item{contribution.by.level}{Mean contribution by level}
#' \item{contribution.average}{List with mean contribution for all levels, for each fit index}
#' \item{complete}{Matrix for complete dominance.}
#' \item{conditional}{Matrix for conditional dominance.}
#' \item{general}{Matrix for general dominance. }
#' @references
#' \itemize{
#' \item Azen, R., & Budescu, D. V. (2003). The dominance analysis approach for comparing predictors in multiple regression. Psychological Methods, 8(2), 129-148. doi:10.1037/1082-989X.8.2.129
#' \item Azen, R., & Traxel, N. (2009). Using Dominance Analysis to Determine Predictor Importance in Logistic Regression. Journal of Educational and Behavioral Statistics, 34(3), 319-347. doi:10.3102/1076998609332754
#' \item Budescu, D. V. (1993). Dominance analysis: A new approach to the problem of relative importance of predictors in multiple regression. Psychological Bulletin, 114(3), 542-551. doi:10.1037/0033-2909.114.3.542
#' \item Luo, W., & Azen, R. (2012). Determining Predictor Importance in Hierarchical Linear Models Using Dominance Analysis. Journal of Educational and Behavioral Statistics, 38(1), 3-31. doi:10.3102/1076998612458319
#' }
#' @examples
#' lm.1<-lm(Employed~.,longley)
#' da<-dominanceAnalysis(lm.1)
#' # Maintain Year constant
#' da.no.year<-dominanceAnalysis(lm.1,constants='Year')
#' @export
dominanceAnalysis <-
  function(x,
           constants = c(),
           fit.functions = "default",
           data = NULL,
           null.model = NULL,
           ...) {
    daModels <- daSubmodels(x, constants)
    daRaw <- daRawResults(x, constants, fit.functions, data, null.model, ...)
    daAverageByLevel <- daAverageContributionByLevel(daRaw)
    daAverageGeneral <-
      lapply(daAverageByLevel, function(x) {
        colMeans(x[, -1])
      })
    list(
      predictors = daModels$predictors,
      constants = daModels$constants,
      fit.functions = daRaw$fit.functions,
      fits = daRaw,
      contribution.by.level = daAverageByLevel,
      contribution.average = daAverageGeneral,
      complete = daCompleteDominance(daRaw),
      conditional = daConditionalDominance(daRaw),
      general = daGeneralDominance(daRaw)
    )
  }
