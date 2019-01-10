#' Dominance analysis for OLS (univariate and multivariate), GLM and LMM models
#'
#' @section Definition of Dominance Analysis:
#' Budescu (1993) developed a clear and intuitive definition of importance
#' in regression models, that states that a predictor's
#' importance reflects its contribution in the prediction of the criterion
#' and that one predictor is 'more important than another' if it contributes
#' more to the prediction of the criterion than does its competitor
#' at a given level of analysis.
#' @section Types of dominance:
#' The original paper (Bodescu, 1993) defines that variable \eqn{X_1} dominates
#' \eqn{X_2} when \eqn{X_1} is chosen over \eqn{X_2} in all possible subset of models
#' where only one of these two predictors is to be entered.
#' Later, Azen & Bodescu (2003), name the previously definition as 'complete dominance'
#' and  two other types of dominance: conditional and general dominance.
#' Conditional dominance is calculated as the average of the additional contributions
#' to all subset of models of a given model size. General dominance is calculated
#' as the mean of average contribution on each level.
#' @section Fit indexes availables:
#' To obtain the fit-indexes for each model, a function called \code{da.<model>.fit}
#' is executed. For example, for a lm model, function \code{\link{da.lm.fit}} provides
#' \eqn{R^2} values.
#' Currently, five models are implemented:
#' \describe{
#' \item{lm}{ Provides \eqn{R^2} or coefficient of determination. See \code{\link{da.lm.fit}}}
#' \item{glm}{ Provides three of the four fit indexes recommended by Azen & Traxel (2009):  McFadden (1974), Nagelkerke (1991), and Estrella (1998). See \code{\link{da.glm.fit}} }
#' \item{lmerMod}{ Provides  four fit indexes recommended by Lou & Azen (2012). See \code{\link{da.lmerMod.fit}}}
#' \item{lmWithCov}{Provides \eqn{R^2} for a correlation/covariance matrix. See \code{\link{lmWithCov}} to create the model and \code{\link{da.lmWithCov.fit}} for the fit index function.}
#' \item{mlmWithCov}{Provides both \eqn{R^2_{XY}} and \eqn{P^2_{XY}} for multivariate regression models using a correlation/covariance matrix. See \code{\link{mlmWithCov}} to create the model and \code{\link{da.mlmWithCov.fit}} for the fit index function }
#' }
#' @param x lm, glm, lmer model
#' @param constants vector of predictors to remain unchanged between models
#' @param terms     vector of terms to be analyzed. By default, obtained from the model
#' @param fit.functions Name of the method used to provide fit indexes
#' @param data optional data.frame
#' @param null.model for mixel models, null model against to test the submodels
#' @param ... Other arguments provided to lm or lmer (not implemented yet)
#' @return
#' \item{predictors}{Vector of predictors.}
#' \item{constants}{Vector of constant variables.}
#' \item{terms}{Vector of terms to be analyzed.}
#' \item{fit.functions}{Vector of fit indexes names.}
#' \item{fits}{List with raw fits indexes. See \code{\link{daRawResults}}.}
#' \item{contribution.by.level}{List of mean contribution of each predictor by level for each fit index. Each element is a data.frame, with levels as rows and predictors as columns, for each fit index.}
#' \item{contribution.average}{List with mean contribution of each predictor for all levels. These values are obtained for every fit index considered in the analysis. Each element is a vector of mean contributions for a given fit index.}
#' \item{complete}{Matrix for complete dominance.}
#' \item{conditional}{Matrix for conditional dominance.}
#' \item{general}{Matrix for general dominance. }
#' @references
#' \itemize{
#' \item Azen, R., & Budescu, D. V. (2003). The dominance analysis approach for comparing predictors in multiple regression. Psychological Methods, 8(2), 129-148. doi:10.1037/1082-989X.8.2.129
#' \item Azen, R., & Budescu, D. V. (2006). Comparing Predictors in Multivariate Regression Models: An Extension of Dominance Analysis. Journal of Educational and Behavioral Statistics, 31(2), 157-180. doi:10.3102/10769986031002157
#' \item Azen, R., & Traxel, N. (2009). Using Dominance Analysis to Determine Predictor Importance in Logistic Regression. Journal of Educational and Behavioral Statistics, 34(3), 319-347. doi:10.3102/1076998609332754
#' \item Budescu, D. V. (1993). Dominance analysis: A new approach to the problem of relative importance of predictors in multiple regression. Psychological Bulletin, 114(3), 542-551. doi:10.1037/0033-2909.114.3.542
#' \item Luo, W., & Azen, R. (2012). Determining Predictor Importance in Hierarchical Linear Models Using Dominance Analysis. Journal of Educational and Behavioral Statistics, 38(1), 3-31. doi:10.3102/1076998612458319
#' }
#' @examples
#' data(longley)
#' lm.1<-lm(Employed~.,longley)
#' da<-dominanceAnalysis(lm.1)
#' print(da)
#' summary(da)
#' # Maintaining year as a constant on all submodels
#' da.no.year<-dominanceAnalysis(lm.1,constants='Year')
#' print(da.no.year)
#' summary(da.no.year)
#' # Parameter terms could be used to group variables
#' da.terms=c('GNP.deflator+GNP',
#'            'Unemployed+Armed.Forces+Population+Unemployed',
#'            'Year')
#' da.grouped<-dominanceAnalysis(lm.1,terms=da.terms)
#' print(da.grouped)
#' summary(da.grouped)
#' @export
dominanceAnalysis <-
  function(x,
           constants = c(),
           terms = NULL,
           fit.functions = "default",
           data = NULL,
           null.model = NULL,
           ...) {
    daModels <- daSubmodels(x = x, constants = constants, terms=terms)
    daRaw <- daRawResults(x = x, constants = constants,terms = terms, fit.functions = fit.functions, data = data, null.model = null.model, ...)
    daAverageByLevel <- daAverageContributionByLevel(daRaw)
    daAverageGeneral <-
      lapply(daAverageByLevel, function(x) {
        colMeans(x[, -1])
      })
    z<-list(
      predictors   = daModels$predictors,
      constants    = daModels$constants,
      terms        = daModels$terms,
      fit.functions = daRaw$fit.functions,
      fits = daRaw,
      contribution.by.level = daAverageByLevel,
      contribution.average = daAverageGeneral,
      complete = daCompleteDominance(daRaw),
      conditional = daConditionalDominance(daRaw),
      general = daGeneralDominance(daRaw)
    )
    class(z)<-c("dominanceAnalysis","list")
    z
  }
#' @keywords internal
#' @export
print.dominanceAnalysis<-function(x,...) {
  cat("\nDominance analysis\n")
  cat("Predictors:", paste0(x$predictors,collapse=", "),"\n")
  if(!is.null(x$constants)) {
    cat("Constants:", paste0(x$constants,collapse=", "),"\n")
  }
  cat("Fit-indexes:", paste0(x$fit.functions,collapse=", "), "\n\n")

  abbrev.matrix<-function(m) {
    n=rownames(m)
    n=abbreviate(n)
    rownames(m)<-n
    colnames(m)<-n
    m
  }

  for(fit in x$fit.functions) {
    cat("* Fit index: ", fit,"\n")
    rank.complete    =rankUsingMatrix(abbrev.matrix(x$complete[[fit]]))
    rank.conditional =rankUsingMatrix(abbrev.matrix(x$conditional[[fit]]))
    rank.general     =rankUsingMatrix(abbrev.matrix(x$general[[fit]]))
    out<-data.frame(complete=rank.complete,conditional=rank.conditional, general=rank.general)
    rownames(out)<-x$predictors
    print(out)
    cat("\nAverage contribution:\n")
    print(round(sort(x$contribution.average[[fit]], decreasing = T),3))
  }
  invisible(x)
}
