#' Summary for bootDominanceAnalysis.
#' @param object a \code{\link{bootDominanceAnalysis}} object
#' @param fit.functions name of the fit indices to retrieve. If NULL, all fit indices will be retrieved
#' @param ... ignored
#' @importFrom stats sd
#' @export
#' @keywords internal

summary.bootDominanceAnalysis<-function(object,fit.functions=NULL,...) {
	out<-list()
	mm.n<-nrow(object$m.names)
	#m.out<-matrix(0,mm.n*3*length(object$fit.functions),11)
  m.out<-list()
	#colnames(m.out)<-c("f", "dominance","i","j","Dij","mDij","SE(Dij)","Pij","Pji","Pnoij","Rep")
	ii<-1

	if(is.null(fit.functions)) {
	  fit.functions=object$fit.functions
	}
	m.names<-object$m.names
	m.names[,1]<-replaceTermsInString(string = m.names[,1], object$terms)
  m.names[,2]<-replaceTermsInString(string = m.names[,2], object$terms)
	for(an in c("complete","conditional","general")) {
		for(ff in object$fit.functions) {
		  for(m in 1:mm.n) {
  			boot.t<-object$boot$t[,ii]
  			m.out[[ii]]<-list(f=ff, dominance=an, i=m.names[m,1], k=m.names[m,2],
  			                  Dij=object$boot$t0[ii], mDij=mean(boot.t), `SE.Dij`=sd(boot.t),
  			                  Pij=sum(boot.t==1)/object$R, Pji=sum(boot.t==0)/object$R,
  			                  Pnoij=sum(boot.t==0.5) / object$R,
  			                  Rep=sum(boot.t==object$boot$t0[ii]) / object$R )
  			ii<-ii+1
		  }

		}
	}
	mm.out<-data.frame(do.call(rbind,m.out))

	for(ff in fit.functions) {
			out[[ff]]<-data.frame(lapply(mm.out[mm.out[,1]==ff,-1],unlist))
	}
	class(out)<-"summary.bootDominanceAnalysis"
	out
}

# Print a summary.bootDominanceAnalysis object
# @param x a \code{\link{summary.bootDominanceAnalysis}} object
# @param round.digits Number of decimal places to round results
# @param ... further arguments passed to print method
#' @export
#' @keywords internal

print.summary.bootDominanceAnalysis<-function(x,round.digits=3,...) {
	cat("Dominance Analysis\n")
	cat("==================\n")
	for(i in names(x)) {
		cat("Fit index:",i,"\n")
	  out<-x[[i]]
	  print(format(out,digits=round.digits),row.names=F,...)
		cat("\n")

	}
}

