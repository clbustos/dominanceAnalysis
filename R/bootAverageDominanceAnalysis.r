#' Bootstrap average values for Dominance Analysis
#'
#' Bootstrap average values, which are used on general dominance
#' Use \code{\link{summary.bootAverageDominanceAnalysis}} to get a nice formatted
#' data.frame
#'
#' @param x lm, glm, lmer model
#' @param R number on bootstrap resamples
#' @param constants vector of variables to remain unchanged between models
#' @param fit.functions list of functions which provides fit indexes for model.
#' @param null.model for mixel models, null model against to test the submodels
#' @param ... Other arguments provided to lm or lmer (not implemented yet)
#' @export
#' @seealso \code{\link{summary.bootAverageDominanceAnalysis}}
#' @examples
#' \dontrun{
#' lm.1<-lm(Employed~.,longley)
#' da.ave.boot<-bootAverageDominanceAnalysis(lm.1,R=1000)
#' summary(da.ave.boot)
#' }

bootAverageDominanceAnalysis<-function(x,R,constants=c(),fit.functions="default",null.model=NULL, ...) {
  if (!requireNamespace("boot", quietly = TRUE)) {
    stop("boot package needed for this function to work. Please install it.",
         call. = FALSE)
  }
  # Extract the data
  total.data  <- getData(x)
  da.original <- dominanceAnalysis(x,constants=constants,fit.functions=fit.functions, null.model=null.model, ...)
  preds       <- da.original$predictor
  n.preds     <- length(preds)
  ff          <- da.original$fit.functions

  eg          <- expand.grid(preds,ff)

  boot.da<-function(d,i) {
    ss<-d[i,]
    da<-dominanceAnalysis(x,constants=constants,fit.functions=fit.functions,data=ss, null.model=null.model,...)
    as.numeric(sapply(da$contribution.average,I))
  }

  res         <- boot::boot(total.data,boot.da,R=R)
  out         <- list(boot=res, preds=preds, fit.functions=ff, R=R, eg=eg)
  class(out)  <- "bootAverageDominanceAnalysis"
  out
}
