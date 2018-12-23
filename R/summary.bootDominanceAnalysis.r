#' Summary for bootDominanceAnalysis.
#' @param object a \code{\link{bootDominanceAnalysis}} object
#' @param ... ignored
#' @importFrom stats sd
#'@export
summary.bootDominanceAnalysis<-function(object,...) {
	out<-list()
	mm.n<-nrow(object$m.names)
	m.out<-matrix(0,mm.n*3*length(object$fit.functions),11)

	colnames(m.out)<-c("f", "dominance","i","j","Dij","mDij","SE(Dij)","Pij","Pji","Pnoij","Rep")
	ii<-1

	for(an in c("complete","conditional","general")) {
		for(ff in object$fit.functions) {
		  for(m in 1:mm.n) {
			boot.t<-object$boot$t[,ii]
			m.out[ii,]<-c(ff, an, object$m.names[m,1], object$m.names[m,2], object$boot$t0[ii], mean(boot.t), sd(boot.t),
			sum(boot.t==1)/object$R, sum(boot.t==0)/object$R, sum(boot.t==0.5) / object$R, sum(boot.t==object$boot$t0[ii]) / object$R )
			ii<-ii+1
		  }

		}
	}
	for(ff in object$fit.functions) {
			out[[ff]]<-data.frame(m.out[m.out[,1]==ff,-1])
	}
	class(out)<-"summary.bootDominanceAnalysis"
	out
}

# Print a summary.bootDominanceAnalysis object
# @param x a \code{\link{summary.bootDominanceAnalysis}} object
# @param digits minimal number of significant digits, see print.default.
# @param ... further arguments passed to print method
#' @export
print.summary.bootDominanceAnalysis<-function(x,digits=3,...) {
	cat("Dominance Analysis\n")
	cat("==================\n")
	for(i in names(x)) {
		cat("Fit index:",i,"\n")
		print(x[[i]],digits=digits,...)
		cat("\n")

	}
}

