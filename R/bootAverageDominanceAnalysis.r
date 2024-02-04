#' Bootstrap Average Values for Dominance Analysis
#'
#' Bootstrap average values and corresponding standard errors for each predictor
#' in the dominance analysis. These values are used for assessing general dominance.
#'
#' Use \code{summary()} to obtain a nicely formatted \code{data.frame} object.
#'
#' @param x A model object, like `lm`, `glm`, or `lmer`.
#' @param R An integer indicating the number of bootstrap resamples to be performed.
#' @param constants A character vector specifying predictors that should remain constant in the bootstrap analysis. Default is an empty vector.
#' @param terms An optional vector of terms (predictors) to be analyzed. If NULL, terms are obtained from the model. Default is NULL.
#' @param fit.functions A vector of functions providing fit indices for the model. See `fit.functions` parameter in `dominanceAnalysis` function.
#' @param null.model An optional model object specifying the null model for linear mixed models, used as a baseline for testing submodels. Default is NULL.
#' @param ... Additional arguments passed to `dominanceAnalysis` method
#' @return An object of class `bootAverageDominanceAnalysis` containing:
#' -\item{boot}{The results of the bootstrap analysis in a \code{boot} object.}
#' \item{preds}{The predictors analyzed}
#' \item{fit.functions}{The fit functions used in the analysis}
#' \item{R}{The number of bootstrap resamples}
#' \item{eg}{expanded grid of predictors by fit functions}
#' \item{terms}{The terms analyzed}
#' @export
#' @examples
#' \donttest{
#' lm.1 <- lm(Employed ~ ., longley)
#' da.ave.boot <- bootAverageDominanceAnalysis(lm.1, R = 1000)
#' summary(da.ave.boot)
#' }
#'
#' @seealso \code{\link{dominanceAnalysis}}, \code{\link{boot}}

bootAverageDominanceAnalysis<-function(x,R,constants=c(), terms = NULL, fit.functions="default",null.model=NULL, ...) {
  if (!requireNamespace("boot", quietly = TRUE)) { #nocov start
    stop("boot package needed for this function to work. Please install it.",
         call. = FALSE)
  } #nocov end
  # Extract the data
  total.data  <- getData(x)
  da.original <- dominanceAnalysis(x, constants=constants, terms = terms, fit.functions=fit.functions, null.model=null.model, ...)
  preds       <- da.original$predictor
  n.preds     <- length(preds)
  ff          <- da.original$fit.functions

  eg          <- expand.grid(preds,ff)

  boot.da<-function(d,i) {
    boot.new.data<-d[i,]
    da<-dominanceAnalysis(x,constants=constants,terms=terms,fit.functions=fit.functions, newdata=boot.new.data, null.model=null.model,...)
    as.numeric(sapply(da$contribution.average,I))
  }

  res         <- boot::boot(total.data ,boot.da, R=R)
  out         <- list(boot=res, preds=preds, fit.functions=ff, R=R, eg=eg, terms=terms)
  class(out)  <- "bootAverageDominanceAnalysis"
  out
}
