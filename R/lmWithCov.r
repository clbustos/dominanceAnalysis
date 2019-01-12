#' Uses covariance/correlation matrix for calculate OLS
#'
#' Calculate regression coefficients and \eqn{R^2} for an OLS regression.
#' Could be used with \code{\link{dominanceAnalysis}} to
#' perform a dominance analysis without the original data.
#'
#'
#' @param f formula for lm model
#' @param x correlation/covariance matrix
#' @return
#' \item{coef}{regression coefficients}
#' \item{r.squared}{\eqn{R^2} or coefficient of determination}
#' \item{formula}{formula provided as parameter}
#' \item{cov}{covariance/correlation matrix provided as parameter}
#' @examples
#' cov.m<-matrix(c(1,0.2,0.3, 0.2,1,0.5,0.3,0.5,1),3,3,
#' dimnames=list(c("x1","x2","y"),c("x1","x2","y")))
#' lm.cov<-lmWithCov(y~x1+x2,cov.m)
#' \dontrun{
#' da<-dominanceAnalysis(lm.cov)
#' }
#' @export
lmWithCov<-function(f,x) {
	t.f<-terms(f)

	x.terms<-attr(t.f,"term.labels")

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
# @internal
formula.lmWithCov<-function(x) {
	x$formula
}
