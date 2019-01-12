#' Retrieve average contribution by level for each predictor
#'
#' Retrieve the average contribution by level for each predictor in a dominance analysis.
#' The average contribution defines conditional dominance.
#' @param da.object dominanceAnalysis object
#' @param fit.functions name of the fit indeces to retrieve. If NULL, all fit indeces will be retrieved
#' @return a list. Key corresponds to fit-index and the value is a matrix, with contribution of each variable
#'                 by level
#' @export
#' @family retrieval methods
#' @examples
#' data(longley)
#' da.longley<-dominanceAnalysis(lm(Employed~.,longley))
#' contributionByLevel(da.longley)


contributionByLevel<-function(da.object, fit.functions=NULL) {
  checkDominanceAnalysis(da.object)
  if(is.null(fit.functions)) {
    fit.functions=da.object$fit.functions
  }
  out<-da.object$contribution.by.level[fit.functions]
  class(out)<-c("daContributionByLevel","list")
  out
}

#' @keywords internal
#' @export
print.daContributionByLevel<-function(x,...) {
  cat("\nContribution by level\n")
  for(fit in names(x)) {
    cat("* Fit index: ", fit,"\n")
    print(round(x[[fit]],3),na.print = "",row.names=F)
  }
  invisible(x)
}
