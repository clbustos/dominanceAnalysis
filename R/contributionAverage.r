#' Retrieve average contribution for one or more fit indeces
#'
#' Retrieve the average contribution for a dominanceAnalysis object.
#' The average contribution defines general dominance.
#' @param da.object dominanceAnalysis object
#' @param fit.functions name of the fit indeces to retrieve. If NULL, all fit indeces will be retrieved
#' @return a list. Key corresponds to fit-index and the value is vector,
#'                 with average contribution for each variable
#' @export


averageContribution<-function(da.object, fit.functions=NULL) {
  if(!inherits(da.object,"dominanceAnalysis")) {
    stop("parameter da.object should be a dominanceAnalysis object")
  }
  if(is.null(fit.functions)) {
    fit.functions=da.object$fit.functions
  }
  out<-da.object$contribution.average[fit.functions]
  class(out)<-c("daAverageContribution","list")
  out
}

#' @keywords internal
#' @export
print.daAverageContribution<-function(x,...) {
  cat("\nAverage Contribution by index\n")
  print(round(t(sapply(x,I)),3))

  invisible(x)
}
