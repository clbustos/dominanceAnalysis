#' Dominance analysis for OLS (univariate and multivariate), GLM (binary and multi-category logit), and LMM models
#'
#' @section Definition of Dominance Analysis:
#' Budescu (1993) developed a clear and intuitive definition of importance
#' in regression models, that states that a predictor's
#' importance reflects its contribution in the prediction of the criterion
#' and that one predictor is 'more important than another' if it contributes
#' more to the prediction of the criterion than does its competitor
#' at a given level of analysis.
#' @section Types of dominance:
#' The original paper (Budescu, 1993) defines that variable \eqn{X_1} dominates
#' \eqn{X_2} when \eqn{X_1} is chosen over \eqn{X_2} in all possible subset of models
#' where only one of these two predictors is to be entered.
#' Later, Azen & Bodescu (2003), name the previously definition as 'complete dominance'
#' and  two other types of dominance: conditional and general dominance.
#' Conditional dominance is calculated as the average of the additional contributions
#' to all subset of models of a given model size. General dominance is calculated
#' as the mean of average contribution on each level.
#' @section Fit indices availables:
#' To obtain the fit-indices for each model, a function called \code{da.<model>.fit}
#' is executed. For example, for a lm model, function \code{\link{da.lm.fit}} provides
#' \eqn{R^2} values.
#' Currently, nine models/approaches are implemented:
#' \describe{
#' \item{lm}{ Provides \eqn{R^2} or coefficient of determination. See \code{\link{da.lm.fit}}}
#' \item{glm}{ Provides four fit indices recommended by Azen & Traxel (2009): Cox and Snell (1989), McFadden (1974), Nagelkerke (1991), and Estrella (1998). See \code{\link{da.glm.fit}} }
#' \item{polr}{Provides two fit indices recommended by Luchman (2014): McFadden (1974) and Estrella (1998) as well as the Cox and Snell (1989) and Nagelkerke (1991),. See \code{\link{da.polr.fit}} }
#' \item{multinom}{Provides two fit indices recommended by Luchman (2014): McFadden (1974) and Estrella (1998) as well as the Cox and Snell (1989) and Nagelkerke (1991),. See \code{\link{da.multinom.fit}} }
#' \item{lmerMod}{ Provides  four fit indices recommended by Luo & Azen (2012). See \code{\link{da.lmerMod.fit}}}
#' \item{lmWithCov}{Provides \eqn{R^2} for a correlation/covariance matrix. See \code{\link{lmWithCov}} to create the model and \code{\link{da.lmWithCov.fit}} for the fit index function.}
#' \item{mlmWithCov}{Provides both \eqn{R^2_{XY}} and \eqn{P^2_{XY}} for multivariate regression models using a correlation/covariance matrix. See \code{\link{mlmWithCov}} to create the model and \code{\link{da.mlmWithCov.fit}} for the fit index function }
#' \item{dynlm}{Provides \eqn{R^2} for dynamic linear models. There is no literature reference about using dominance analysis on dynamic linear models, so you're warned!. See \code{\link{da.dynlm.fit}}}
#' \item{betareg}{Provides pseudo-\eqn{R^2}, Cox and Snell(1989), McFadden (1974), and Estrella (1998). You could set the link function using link.betareg if automatic detection of link function doesn't work.
#' } See \code{\link{da.betareg.fit}} 
#' }
#' @param x lm, glm, polr, multinom, lmer model
#' @param constants vector of predictors to remain unchanged between models
#' @param terms     vector of terms to be analyzed. By default, obtained from the model
#' @param fit.functions Name of the method used to provide fit indices
#' @param data optional data.frame
#' @param null.model for mixed models, null model against to test the submodels
#' @param link.betareg for betareg, link function to use.
#' @param ... Other arguments provided to lm or lmer (not implemented yet)
#' @return
#' \item{predictors}{Vector of predictors.}
#' \item{constants}{Vector of constant variables.}
#' \item{terms}{Vector of terms to be analyzed.}
#' \item{fit.functions}{Vector of fit indices names.}
#' \item{fits}{List with raw fits indices. See \code{\link{daRawResults}}.}
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
#' \item Luchman, J. N. (2014). Relative Importance Analysis With Multicategory Dependent Variables: An Extension and Review of Best Practices. Organizational Research Methods, 17(4), 452-471. doi:10.1177/1094428114544509
#' \item Luo, W., & Azen, R. (2012). Determining Predictor Importance in Hierarchical Linear Models Using Dominance Analysis. Journal of Educational and Behavioral Statistics, 38(1), 3-31. doi:10.3102/1076998612458319
#' }
#' @examples
#' data(longley)
#' lm.1<-lm(Employed~.,longley)
#' da<-dominanceAnalysis(lm.1)
#' print(da)
#' summary(da)
#' plot(da,which.graph='complete')
#' plot(da,which.graph='conditional')
#' plot(da,which.graph='general')
#'
#' # Maintaining year as a constant on all submodels
#' da.no.year<-dominanceAnalysis(lm.1,constants='Year')
#' print(da.no.year)
#' summary(da.no.year)
#' plot(da.no.year,which.graph='complete')
#'
#' # Parameter terms could be used to group variables
#' da.terms=c(GNP.rel='GNP.deflator+GNP',
#'            pop.rel='Unemployed+Armed.Forces+Population+Unemployed',
#'            year='Year')
#' da.grouped<-dominanceAnalysis(lm.1,terms=da.terms)
#' print(da.grouped)
#' summary(da.grouped)
#' plot(da.grouped, which.graph='complete')
#' @export
dominanceAnalysis <-
  function(x,
           constants = c(),
           terms = NULL,
           fit.functions = "default",
           data = NULL,
           null.model = NULL,
           link.betareg = NULL,
           ...) {
    if(is.list(terms)) {
      terms<-sapply(terms,paste0,collapse="+")
    }
    daModels        <- daSubmodels(x = x, constants = constants, terms = terms)

    daRaw           <- daRawResults(x = x, constants = constants, terms = terms, fit.functions = fit.functions, data = data, null.model = null.model, link.betareg= link.betareg,...)

    daAverageByLevel <- daAverageContributionByLevel(daRaw)
    daAverageGeneral <- lapply(daAverageByLevel, function(x) {colMeans(x[, -1])})
    z<-list(
      predictors   = daModels$predictors,
      constants    = daModels$constants,
      terms        = terms,
      fit.functions = daRaw$fit.functions,
      fits = daRaw,
      link.betareg=link.betareg,
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
  if(!is.null(x$terms)) {
    cat("Terms:", paste0(paste0(names(x$terms)," = ",as.character(x$terms)), collapse=" ; ")  ,"\n")
  }
  if(!is.null(x$constants)) {
    cat("Constants:", paste0(x$constants,collapse=", "),"\n")
  }
  cat("Fit-indices:", paste0(x$fit.functions,collapse=", "), "\n\n")

  for(fit in x$fit.functions) {
    cat("* Fit index: ", fit,"\n")
    dom.brief<-dominanceBriefing(x,fit.functions = fit,abbrev = TRUE)[[fit]]
    print(dom.brief)
    cat("\nAverage contribution:\n")
    print( round(sort(averageContribution(x)[[fit]], decreasing=T) ,3))
    #print(round(sort(x$contribution.average[[fit]], decreasing = T),3))
  }
  invisible(x)
}
