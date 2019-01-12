#' Retrieve contribution by level for one or more fit indeces
#'
#' Retrieve the contribution by level for a given dominanceAnalysis object.
#' This contribution defines conditional dominance.
#' @param da.object dominanceAnalysis object
#' @param fit.functions name of the fit indeces to retrieve. If NULL, all fit indeces will be retrieved
#' @return a list. Key corresponds to fit-index and the value is a matrix, with contribution of each variable
#'                 by level
#' @export


contributionByLevel<-function(da.object, fit.functions=NULL) {
  if(!inherits(da.object,"dominanceAnalysis")) {
    stop("parameter da.object should be a dominanceAnalysis object")
  }
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
  cat("\nDominance analysis fit matrix\n")
  for(fit in names(x)) {
    cat("* Fit index: ", fit,"\n")
    print(round(x[[fit]],3),na.print = "",row.names=F)
  }
  invisible(x)
}
