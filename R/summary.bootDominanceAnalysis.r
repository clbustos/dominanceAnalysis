#' Summary for bootDominanceAnalysis 
#'@export
summary.bootDominanceAnalysis<-function(x,...) {
	out<-list()
	mm.n<-nrow(x$m.names)
	m.out<-matrix(0,mm.n*3*length(x$fit.functions),11)
	
	colnames(m.out)<-c("f", "dominance","i","j","Dij","mDij","SE(Dij)","Pij","Pji","Pnoij","Rep")
	ii<-1
	
	for(an in c("complete","conditional","general")) {
		for(ff in x$fit.functions) {
		  for(m in 1:mm.n) {
			boot.t<-x$boot$t[,ii]
			m.out[ii,]<-c(ff,an,x$m.names[m,1], x$m.names[m,2], x$boot$t0[ii], mean(boot.t), sd(boot.t),
			sum(boot.t==1)/x$R, sum(boot.t==0)/x$R, sum(boot.t==0.5)/x$R, sum(boot.t==x$boot$t0[ii])/x$R )
			ii<-ii+1
		  }
			
		}
	}
	for(ff in x$fit.functions) {
			out[[ff]]<-data.frame(m.out[m.out[,1]==ff,-1])
	}
	class(out)<-"summary.bootDominanceAnalysis"
	out
}

print.summary.bootDominanceAnalysis<-function(x,digits=3,...) {
	cat("Dominance Analysis\n")
	cat("==================\n")
	for(i in names(x)) {
		cat("Fit index:",i,"\n")
		print(x[[i]],digits=digits,...)
		cat("\n")

	}
}

