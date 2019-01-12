#' Uses covariance/correlation matrix to calculate multivariate index of fit
#'
#' Calculate \eqn{R^2_{XY}} and  \eqn{P^2_{YX}} for multivariate regression
#' Could be used with \code{\link{dominanceAnalysis}} to
#' perform a multivariate dominance analysis without original
#' data.
#'
#' @param f formula. Should use \code{cbind(y1,y2,...,yk)~x1+x2+..+xp}
#' @param x correlation/covariance matrix
#' @return
#' \item{r.squared.xy}{\eqn{R^2_{XY}} of the regression}
#' \item{p.squared.yx}{\eqn{P^2_{YX}} of the regression}
#' \item{formula}{formula provided as parameter}
#' \item{cov}{covariance/correlation matrix provided as parameter}
#' @importFrom stats terms model.response model.frame
#' @examples
#' \dontrun{
#' library(car)
#' library(heplots)
#' cor.m<-cor(Rohwer[Rohwer[,1]==1,2+c(7,8,1,2,3)])
#' lwith<-mlmWithCov(cbind(na,ss)~SAT+PPVT+Raven,cor.m)
#' da<-dominanceAnalysis(lwith)
#' print(da)
#' summary(da)
#' }

mlmWithCov<-function(f,x) {
	t.f<-terms(f)
	x.terms<-attr(t.f,"term.labels")
	if(length(x.terms)>0) {
	  response.xy<-model.response(model.frame(f,data.frame(x)))
    y.terms<-colnames(response.xy)
    q<-ncol(response.xy)
    s.xx<-x[x.terms,x.terms,drop=F]
    s.yy<-x[y.terms,y.terms,drop=F]
    s.xy<-x[x.terms,y.terms,drop=F]
    s.yx<-x[y.terms,x.terms,drop=F]
    s.yyx<-s.yy-s.yx%*%solve(s.xx)%*%s.xy
    r2xy <- 1-(det(s.yyx)/(det(s.yy)))
    vxy <- q-sum(diag((solve(s.yy)%*%s.yyx)))
    p2yx<-vxy/q
	} else {
	  r2xy <-p2yx<-0
	 }
	out<-list(r.squared.xy=as.numeric(r2xy),p.squared.yx=as.numeric(p2yx),formula=f,cov=x)
	class(out)<-"mlmWithCov"
	out
}
# @internal
formula.mlmWithCov<-function(x) {
	x$formula
}
