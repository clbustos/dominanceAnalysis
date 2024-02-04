#' Bootstrap Analysis for Dominance Analysis
#'
#' Implements a bootstrap procedure as presented by Azen and Budescu (2003).
#' Provides the expected level of dominance of predictor \eqn{X_i} over \eqn{X_j},
#' as the degree to which the pattern found in the sample is reproduced in the
#' bootstrap samples.
#'
#' Use \code{summary()} to obtain a nicely formatted \code{data.frame}.
#'
#' @param x An object of class \code{lm}, \code{glm}, or \code{lmer}.
#' @param R The number of bootstrap resamples.
#' @param constants A vector of predictors to remain unchanged between models,
#'                  i.e., variables not subjected to bootstrap analysis.
#' @param terms A vector of terms to be analyzed. By default, terms are obtained from the model.
#' @param fit.functions A list of functions providing fit indices for the model.
#'                      Refer to \code{fit.functions} parameter in \code{\link{dominanceAnalysis}} function.
#' @param null.model Applicable only for linear mixed models. It refers to the null model against which to test the submodels,
#'                   i.e., only random effects, without any fixed effects.
#' @param ... Additional arguments provided to \code{lm} or \code{lmer} (not implemented yet).
#' @return An object of class \code{bootDominanceAnalysis} containing:
#'   \item{boot}{The results of the bootstrap analysis.}
#'   \item{preds}{The predictors analyzed.}
#'   \item{fit.functions}{The fit functions used in the analysis.}
#'   \item{c.names}{A vector where each value represents the name of a specific dominance analysis result.
#'                Names are prefixed with the type of dominance (complete, conditional, or general),
#'                and the fit function used, followed by the names of the first and second predictors
#'                involved in the comparison.}
#'   \item{m.names}{Names of each one the predictor pairs.}
#'   \item{terms}{The terms analyzed.}
#'   \item{R}{The number of bootstrap resamples.}
#' @export
#' @examples
#' \donttest{
#' lm.1 <- lm(Employed ~ ., longley)
#' da.boot <- bootDominanceAnalysis(lm.1, R = 1000)
#' summary(da.boot)
#' }
bootDominanceAnalysis<-function(x,R,constants=c(),terms=NULL, fit.functions="default",null.model=NULL, ...) {
	if (!requireNamespace("boot", quietly = TRUE)) { #nocov start
    stop("boot package needed for this function to work. Please install it.",
      call. = FALSE)
  } #nocov end
  # Extract the data
	total.data<-getData(x)

	da.original<-dominanceAnalysis(x, constants=constants, terms=terms, fit.functions=fit.functions, null.model=null.model,...)
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
	  res<-as.numeric(sapply(m,function(x) {as.numeric(1-x[lower.tri(x)]) } ))
	  res
	 }

	boot.da<-function(d,i) {
	  # UGLY HACK.
		boot.new.data<-d[i,]
		da<-dominanceAnalysis(x,constants=constants,terms=terms, fit.functions=fit.functions, newdata=boot.new.data, null.model=null.model,...)
		#print(da$complete$r2.m[3,]-da$conditional$r2.m[3,])
		out<-c(aplanar(da$complete),aplanar(da$conditional),aplanar(da$general))
		names(out)<-c.names
		out
	}
	res<-boot::boot(total.data,boot.da,R=R)
	out<-list(boot=res, preds=preds, fit.functions=ff, c.names=c.names, m.names=m.nombres, terms=terms, R=R)
	class(out)<-"bootDominanceAnalysis"
	out
}
