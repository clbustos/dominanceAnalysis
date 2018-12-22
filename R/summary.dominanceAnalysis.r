#' Summary for a \code{\link{dominanceAnalysis}} object
#'
#' @param object a \code{\link{dominanceAnalysis}} object
#' @param ... unused
#' @return A list, with values
#' \itemize{
#' \item \code{average.contribution}: vector of average contributions of each variable
#' \item \code{summary.matrix}: matrix with all calculations for dominance analysis
#' }
#' @export
summary.dominanceAnalysis<-function(object, ...) {
	ff<-object$fit.functions
	out=list()
	for(fit in ff) {

	  fit.matrix<-data.frame(model=rownames(object$fits$fits[[fit]]), level=object$fits$level, fit=object$fits$base.fits[,fit],  round(object$fits$fits[[fit]],3))
	  split.fit.matrix<-split(fit.matrix,f = fit.matrix$level)
	  max.level=max(fit.matrix$level)
	  split.fit.matrix.1<-lapply(split.fit.matrix,function(xx) {
	    level=min(xx$level)
	    if(level==0 || level==max.level) {
	      xx
	    } else {
        averages=colMeans(xx[,-c(1:3)],na.rm=T)

        row=data.frame(c(list(model=paste0("Average level ",level), level=level,fit=NA), as.list(averages)))
        rbind(xx,row)
	    }
	  })
	  summary.matrix<-do.call(rbind, split.fit.matrix.1)
	  out[[fit]]<-list(
	    average.contribution=object$contribution.average[[fit]],
	    summary.matrix=summary.matrix
	  )
	  rownames(out[[fit]]$summary.matrix)<-abbreviate(out[[fit]]$summary.matrix$model)
	}
	class(out)<-c("summary.dominanceAnalysis","list")
	out
}

# Print a summary.dominanceAnalysis object
# @param x a \code{\link{summary.dominanceAnalysis}} object
# @param ... further arguments passed to print method
#' @export
print.summary.dominanceAnalysis<-function(x, ...) {
  for(fit in names(x)) {
    cat("\n* Fit index: ",fit,"\n")
    cat("\nAverage contribution of each variable:\n\n")
    print(sort(x[[fit]]$average.contribution,decreasing = T),...)
    cat("\nDominance Analysis matrix:\n")
    delete.na<-function(xx) {
      if(is.numeric(xx)) {
        result<-as.character(round(xx,3))
        result[is.na(result)]<-""
        result
      } else {
        xx
      }
    }
    print(data.frame(lapply(x[[fit]]$summary.matrix,delete.na)), row.names=F, ...)
  }
}
