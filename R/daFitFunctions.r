#' Provides coefficient of determination for \code{lm} models
#' 
#' Uses \eqn{R^2} (coefficient of determination) as fit index
#' @export
da.lm.fit<-function(...) {
	mc=match.call()
	function(x) {
	if(x=="names") {
		return("r2")
	}
	 list(r2=summary(lm(x, data=mc$data))$r.squared)}
}
#' Provides fit indexes for GLM models, based on Azen and Traxel(2009) 
#'
#' @return A list with several fit indexes 
#' \item{r2.m}{McFadden(1974)}
#' \item{r2.n}{Nagelkerke(1991)}
#' \item{r2.e}{Estrella(1998)}
#' 
#' @references Azen, R., & Traxel, N. (2009). Using Dominance Analysis to Determine Predictor Importance in Logistic Regression. Journal of Educational and Behavioral Statistics, 34(3), 319-347. doi:10.3102/1076998609332754
#' @export
da.glm.fit<-function(...) {
  
	mc=match.call()
	function(x) {
	    if(x=="names") {
			return(c("r2.m","r2.n","r2.e"))
		}

		g1<-glm(x,data=mc$data,family=binomial);
		
		l0=-0.5*g1$null.deviance
		l1=-0.5*g1$deviance
		n=ncol(g1$data)
		
		list(r2.m=(l0-l1)/(l0),r2.n=(1-(exp(l0-l1)^(2/n)))/(1-exp(l0)^(2/n)),r2.e=1-(l1/l0)^(-(2/n)*l0))
	}

}
#' Provides fit indexes for mixed models, based on Luo and Azen (2012)
#' 
#' Requires glmmextra @url{https://github.com/clbustos/r-glmmextra} 
#' @references
#' \itemize {
#' \item Luo, W., & Azen, R. (2012). Determining Predictor Importance in Hierarchical Linear Models Using Dominance Analysis. Journal of Educational and Behavioral Statistics, 38(1), 3-31. doi:10.3102/1076998612458319
#' } 
#' @export
da.lmerMod.fit<-function(...) {
  if (!requireNamespace("lme4", quietly = TRUE)) {
    stop("lme4 needed for this function to work. Please install it.",
      call. = FALSE)
  }
  if (!requireNamespace("glmmextra", quietly = TRUE)) {
    stop("glmmextra needed for this function to work. Please install it.",
      call. = FALSE)
  }  
	mc=match.call()
	function(x) {
		if(x=="names") {
			return(c("rb.r2.1","rb.r2.2","sb.r2.1","sb.r2.2"))
		}

		l1<-lme4::lmer(x,data=mc$data);  
		lmmr2<-glmmextra::lmmR2(m.null=mc$null.model, l1)
		list(rb.r2.1=lmmr2$rb.r2.1,rb.r2.2=lmmr2$rb.r2.2, sb.r2.1=lmmr2$sb.r2.1,sb.r2.2=lmmr2$sb.r2.2)
	}
}

#' Provides coefficient of determination for lineal models, using covariance/correlation matrix
#'
#' Uses \eqn{R^2} (coefficient of determination)
#' See \code{\link{lmWithCov}}
#' @export
da.lmWithCov.fit<-function(...) {
	mc=match.call()
	function(x) {
		if(x=="names") {
			return(c("r2"))
		}
		list(r2=lmWithCov(x,mc$base.cov)$r.squared)
	}
}
