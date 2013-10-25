#' Uses covariance/correlation matrix for OLS
#' We use for testing, comparing the results of papers with
#' this package, but useful anyway
#' @param f formula
#' @param x correlation/covariance matrix
lmWithCov<-function(f,x) {
	t.f<-terms(f)  
	x.terms<-sort(attr(t.f,"term.labels"))
	
	if(length(x.terms)>0) {
		respuesta<-rownames(attr(terms(f),"factors"))[attr(t.f,"response")]
		# (X^T X)^-1 X^T Y 
		xt.x<-x[x.terms,x.terms]
		xt.y<-x[c(x.terms),c(respuesta),drop=F]
		betas.i<-solve(xt.x)%*%xt.y
		r.2<-sum(xt.y*betas.i)
	} else {
		betas.i<-numeric(0)
		r.2=0
		
	}
	out<-list(coef=as.numeric(betas.i),r.squared=as.numeric(r.2),formula=f,cov=x)
	class(out)<-"lmWithCov"
	out
}

formula.lmWithCov<-function(x) {
	x$formula
}
