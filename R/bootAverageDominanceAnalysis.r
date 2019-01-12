#' Bootstrap average values for Dominance Analysis
#'
#' Bootstrap average values and correspond standard errors for each predictor
#' in the dominance analysis. Those values are used for general dominance.
#'
#' Use \code{summary()} to get a nice formatted \code{data.frame} object.
#'
#' @param object lm, glm or lmer model
#' @param R number on bootstrap resamples
#' @param constants vector of predictors to remain unchanged between models.
#'                  i.e. vector of variables not subjected to bootstrap analysis.
#' @param fit.functions list of functions which provides fit indeces for model.
#'                      See \code{fit.functions} param in \code{\link{dominanceAnalysis}}
#'                      function.
#' @param null.model only for linear mixel models, null model against to test the submodels.
#'                   i.e. only random effects, without any fixed effect.
#' @param ... Other arguments provided to lm or lmer (not implemented yet).
#' @export
#' @examples
#' \dontrun{
#' lm.1<-lm(Employed~.,longley)
#' da.ave.boot<-bootAverageDominanceAnalysis(lm.1,R=1000)
#' summary(da.ave.boot)
#' }

bootAverageDominanceAnalysis<-function(object,R,constants=c(),fit.functions="default",null.model=NULL, ...) {
  if (!requireNamespace("boot", quietly = TRUE)) { #nocov start
    stop("boot package needed for this function to work. Please install it.",
         call. = FALSE)
  } #nocov end
  # Extract the data
  total.data  <- getData(object)
  da.original <- dominanceAnalysis(object, constants=constants,fit.functions=fit.functions, null.model=null.model, ...)
  preds       <- da.original$predictor
  n.preds     <- length(preds)
  ff          <- da.original$fit.functions

  eg          <- expand.grid(preds,ff)

  boot.da<-function(d,i) {
    ss<-d[i,]
    da<-dominanceAnalysis(object,constants=constants,fit.functions=fit.functions,data=ss, null.model=null.model,...)
    as.numeric(sapply(da$contribution.average,I))
  }

  res         <- boot::boot(total.data,boot.da, R=R)
  out         <- list(boot=res, preds=preds, fit.functions=ff, R=R, eg=eg)
  class(out)  <- "bootAverageDominanceAnalysis"
  out
}
