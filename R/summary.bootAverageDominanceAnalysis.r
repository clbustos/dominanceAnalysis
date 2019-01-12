#' Summary for bootAverageDominanceAnalysis.
#' @param object a \code{\link{bootAverageDominanceAnalysis}} object
#' @param fit.functions name of the fit indeces to retrieve. If NULL, all fit indeces will be retrieved
#' @param ... ignored
#' @importFrom stats sd
#' @export
#' @keywords internal

summary.bootAverageDominanceAnalysis<-function(object, fit.functions=NULL, ...) {
	bs.mean<-colMeans(object$boot$t)
	bs.se<-apply(object$boot$t,2,sd)
	x.table<-data.frame(object$eg, original=object$boot$t0, bs.mean=bs.mean,bias=bs.mean-object$boot$t0,bs.se=bs.se)
	colnames(x.table)<-c("Var","Fit.Index","original","bs.E","bias","bs.SE")

	out<-split(x.table, x.table$Fit.Index)
	if(!is.null(fit.functions)) {
	  out<-out[fit.functions]
	}
	attr(out,"R")<-object$R
	class(out)<-"summary.bootAverageDominanceAnalysis"
	out
}

# Print method for summary.bootAverageDominanceAnalysis
# @param x a \code{\link{summary.bootAverageDominanceAnalysis}} object
# @param digits minimal number of significant digits. See \code{\link{print.default}}
# @param ... further arguments passed to print method
#' @export
#' @keywords internal

print.summary.bootAverageDominanceAnalysis<-function(x,digits=3,...) {
	cat("Bootstrap Average for Dominance Analysis\n")
	cat("========================================\n")
	cat("Resamples: ",attr(x,"R"),"\n")
	for(i in names(x)) {
		cat("Fit index:",i,"\n")
		print(x[[i]][,-2],digits=digits,...)
		cat("\n")
	}
}

