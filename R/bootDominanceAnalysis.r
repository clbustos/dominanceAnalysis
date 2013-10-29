#' Bootstrap analysis for Dominance Analysis
#' Based on Azen and Bodescu(2006)
#' @export
bootDominanceAnalysis<-function(x,R,constants=c(),fit.functions="default",null.model=NULL, ...) {
	require(boot)
	# Extract the data
	total.data<-getData(x)
	da.original<-dominanceAnalysis(x,constants=constants,fit.functions=fit.functions, null.model=null.model,...)
	preds<-			da.original$predictor
	n.preds<-length(preds)
	ff<-	da.original$fit.functions
	p.nombres<-character((n.preds*(n.preds-1))/2)
	m.nombres<-matrix("",(n.preds*(n.preds-1))/2,2)
	ii<-1
	
	for(i in 1:(n.preds-1)) {
		for(j in (i+1):n.preds) {
			p.nombres[[ii]]<-paste0(preds[i],".",preds[j],collapse=""	)
			m.nombres[ii,]<-c(preds[i],preds[j])
			ii<-ii+1
		}
	}
	
	fit.vars.n<-character(0)
	for(i in ff) {
	   fit.vars.n<-c(fit.vars.n,paste0(i,"-",p.nombres))
	}
	c.names<-character(0)
	for(i in c("complete","conditional","general")) {
		c.names<-c(c.names,paste0(i,"-",fit.vars.n))
	}
	#print(preds)
	#print(fit.functions)
	aplanar<-function(m) { 
	  as.numeric(sapply(m,function(x) {as.numeric(x[upper.tri(x)]) } ))
	 }
	
	boot.da<-function(d,i) {
		ss<-d[i,]
		da<-dominanceAnalysis(x,constants=constants,fit.functions=fit.functions,data=ss, null.model=null.model,...)
		da$complete
		out<-c(aplanar(da$complete),aplanar(da$conditional),aplanar(da$general))
		names(out)<-c.names
		out
	}
	res<-boot(total.data,boot.da,R=R)
	out<-list(boot=res,preds=preds,fit.functions=ff,c.names=c.names, m.names=m.nombres,R=R)
	class(out)<-"bootDominanceAnalysis"
	out
}
