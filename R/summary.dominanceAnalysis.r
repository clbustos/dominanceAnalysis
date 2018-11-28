#' Summary for a \code{\link{dominanceAnalysis}} object
#'
#' @param object a \code{\link{dominanceAnalysis}} object
#' @param ... unused
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
	  out[[fit]]<-do.call(rbind, split.fit.matrix.1)
	  rownames(out[[fit]])<-abbreviate(out[[fit]]$model)
	}
	out
}
