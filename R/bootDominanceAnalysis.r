#' Bootstrap analysis for Dominance Analysis
#'
#' Bootstrap procedure as presented on Azen and Bodescu(2003).
#' Provides the expected level of dominance of variable \eqn{X_i} over \eqn{X_j},
#' as the degree to which the pattern found on sample is reproduced on the 
#' bootstrap samples.
#' Use \code{\link{summary.bootDominanceAnalysis}} to get a nice formatted
#' data.frame
#' 
#' @param x lm, glm, lmer model
#' @param constants vector of variables to remain unchanged between models
#' @param fit.functions list of functions which provides fit indexes for model. 
#' @param null.model for mixel models, null model against to test the submodels
#' @param ... Other arguments provided to lm or lmer (not implemented yet)
#' @export
#' @seealso \code{\link{summary.bootDominanceAnalysis}}
#' @examples
#' \dontrun{
#' lm.1<-lm(Employed~.,longley)
#' da.boot<-bootDominanceAnalysis(lm.1,R=1000)
#' summary(da.boot)
#' }
bootDominanceAnalysis<-function(x,R,constants=c(),fit.functions="default",null.model=NULL, ...) {
	if (!requireNamespace("boot", quietly = TRUE)) {
    stop("boot package needed for this function to work. Please install it.",
      call. = FALSE)
  }
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
	res<-boot::boot(total.data,boot.da,R=R)
	out<-list(boot=res, preds=preds, fit.functions=ff, c.names=c.names, m.names=m.nombres, R=R)
	class(out)<-"bootDominanceAnalysis"
	out
}
