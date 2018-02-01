#' Summary for bootAverageDominanceAnalysis.
#'@export
summary.bootAverageDominanceAnalysis<-function(x,...) {
	bs.mean<-colMeans(x$boot$t)
	bs.se<-apply(x$boot$t,2,sd)
	x.table<-data.frame(x$eg,original=x$boot$t0,bs.mean=bs.mean,bias=bs.mean-x$boot$t0,bs.se=bs.se)
	colnames(x.table)<-c("Var","Fit.Index","original","bs.E","bias","bs.SE")

	out<-split(x.table,x.table$Fit.Index)
	attr(out,"R")<-x$R
	class(out)<-"summary.bootAverageDominanceAnalysis"
	out
}

#' @export
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

