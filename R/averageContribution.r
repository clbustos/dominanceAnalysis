#' Retrieve average contribution of each predictor in a dominance analysis.
#'
#' Retrieve the average contribution for each predictor. Is calculated
#' averaging all contribution by level.
#' The average contribution defines general dominance.
#' @param da.object dominanceAnalysis object
#' @param fit.functions name of the fit indeces to retrieve. If NULL, all fit indeces will be retrieved
#' @return a list. Key corresponds to fit-index and the value is vector,
#'                 with average contribution for each variable
#' @family retrieval methods
#' @export
#' @examples
#' data(longley)
#' da.longley<-dominanceAnalysis(lm(Employed~.,longley))
#' averageContribution(da.longley)



averageContribution<-function(da.object, fit.functions=NULL) {
  checkDominanceAnalysis(da.object)
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
  cat("\nAverage Contribution by predictor\n")
  print(round(t(sapply(x,I)),3))

  invisible(x)
}
