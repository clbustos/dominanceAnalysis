#' Retrieve fit matrix or matrices
#'
#' Retrieve fit matrix or matrices for a given dominanceAnalysis object
#' @param da.object dominanceAnalysis object
#' @param fit.functions name of the fit indeces to retrieve. If NULL, all fit indeces will be retrieved
#' @return a list. Key corresponds to fit-index and the value is a matrix, with fits values
#' @export


getFits<-function(da.object, fit.functions=NULL) {
  if(!inherits(da.object,"dominanceAnalysis")) {
    stop("parameter da.object should be a dominanceAnalysis object")
  }
  if(is.null(fit.functions)) {
    fit.functions=da.object$fit.functions
  }
  out<-da.object$fits$fits[fit.functions]
  class(out)<-c("daFits","list")
  out
}

#' @keywords internal
#' @export
print.daFits<-function(x,...) {
  cat("\nDominance analysis fit matrix\n")
  for(fit in names(x)) {
    cat("* Fit index: ", fit,"\n")
    print(round(x[[fit]],3),na.print = "")
  }
  invisible(x)
}
