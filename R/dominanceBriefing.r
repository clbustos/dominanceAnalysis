#' Retrieve a briefing for complete, conditional and general dominance
#'
#' @param  da.object a \code{dominanceAnalysis} object
#' @param  fit.functions name of the fit indices to retrieve. If NULL, all fit indices will be retrieved
#' @param  abbrev if TRUE
#' @return a list. Each element is a data.frame, that comprises the dominance analysis
#'         for a specific fit index. Each data.frame have the predictors as row
#'         and each column reports the predictors that are dominated for each predictor
#' @export
#' @family retrieval methods
#' @examples
#' # For matrix or data.frame
#' data(longley)
#' da.longley<-dominanceAnalysis(lm(Employed~.,longley))
#' dominanceBriefing(da.longley, abbrev=FALSE)
#' dominanceBriefing(da.longley, abbrev=TRUE)
dominanceBriefing<-function(da.object, fit.functions=NULL, abbrev=FALSE) {
  checkDominanceAnalysis(da.object)
  if(is.null(fit.functions)) {
    fit.functions=da.object$fit.functions
  }

  abbrev.matrix<-function(m) {
    n=rownames(m)
    n=abbreviate(n)
    rownames(m)<-n
    colnames(m)<-n
    m
  }

    if(abbrev) {
      process.names<-abbrev.matrix
    } else {
      process.names<-I
    }

  names(fit.functions)<-fit.functions

  rank.f<-function(type,fit) {
    rankUsingMatrix(process.names(dominanceMatrix(da.object, type=type, fit.functions=fit)))
  }

  out<-lapply(fit.functions, function(fit) {
    rank.complete    = rank.f('complete', fit)
    rank.conditional = rank.f('conditional', fit)
    rank.general     = rank.f('general', fit)
    out<-data.frame(complete=rank.complete,conditional=rank.conditional, general=rank.general)
    rownames(out)<-replaceTermsInString(da.object$predictors,da.object$terms)
    out
  })

  class(out)<-c("dominanceBriefing","list")
  out
}