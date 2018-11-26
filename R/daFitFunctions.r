#' Provides fit indexes for different regression models.
#'
#' \code{dominanceAnalysis} try to infer, based on the class of the
#' model provided, the appropiate fit indexes, using the scheme
#' da.CLASS.fit for name. This method have two interfaces, one for
#' retrieve the names of fit indexes, and other to retrieve the
#' indexes based on data.
#'
#' Interfaces are:
#' \itemize{
#' \item \code{da.CLASS.fit("names")} returns a vector with names for fit Indexes
#' \item \code{da.CLASS.fit(data, null.model, base.cov=NULL,family.glm=NULL)} returns a function with one param,
#'       the formula to calculate the submodel.
#' }
#' \code{\link{daRawResults}}
#' @param data complete data
#' @param null.model needed for LMM models
#' @param base.cov needed when only covarince/correlation matrix is provided
#' @param family.glm family for glm models
#' @name using-fit-indexes
NULL

#' Provides coefficient of determination for \code{lm} models.
#'
#' Uses \eqn{R^2} (coefficient of determination) as fit index
#' @param  data complete data for model
#' @return A function described by \link{using-fit-indexes} description for interface
#' @export
#' @family fit indexes
#' @examples
#' x1<-rnorm(1000)
#' x2<-rnorm(1000)
#' y <-x1+x2+rnorm(1000)
#' da.lm.fit(lm(y~x1+x2))("names")
#' da.lm.fit(lm(y~x1+x2))(y~x1)
da.lm.fit<-function(...) {
  mc=match.call()
  function(x) {
  	if(x=="names") {
  		return("r2")
  	}
	 list(r2=summary(lm(x, data=mc$data))$r.squared)
	}
}

#' Provides fit indexes for GLM models, based on Azen and Traxel(2009)
#'
#' Check \link{daRawResults}.
#'
#' @return A function described by \link{using-fit-indexes}. You could retrieve following indexes
#' \describe{
#' \item{\code{r2.m}}{McFadden(1974)}
#' \item{\code{r2.cs}}{Cox and Snell(1989). Use as a reference, because don't have 1 as upper bound}
#' \item{\code{r2.n}}{Nagelkerke(1991), that corrects the upper bound of Cox and Snell(1989) index }
#' \item{\code{r2.e}}{Estrella(1998)}
#' }
#'
#' @references
#' \itemize{
#' \item Azen, R. and Traxel, N. (2009). Using Dominance Analysis to Determine Predictor Importance in Logistic Regression. \emph{Journal of Educational and Behavioral Statistics, 34} (3), 319-347. doi:10.3102/1076998609332754.
#'
#' \item Nagelkerke, N. J. D. (1991). A note on a general definition of the coefficient of determination. \emph{Biometrika, 78}(3), 691-692. doi:10.1093/biomet/78.3.691.
#' }
#' @family fit indexes
#' @export
#' @examples
#' x1<-rnorm(1000)
#' x2<-rnorm(1000)
#' x3<-rnorm(1000)
#' y<-factor(rbinom(1000,  size=1,prob = exp(x1+x2+x3)/(1+exp(x1+x2+x3))))
#' da.glm.fit(glm(y~x1+x2,family='binomial'))("names")
#' da.glm.fit(glm(y~x1+x2,family='binomial'), family.glm='binomial')(y~x1)
da.glm.fit<-function(...) {

	mc=match.call()
	function(x) {
	    if(x=="names") {
			return(c("r2.m","r2.cs","r2.n","r2.e"))
		}

		g1<-glm(x,data=mc$data,family=mc$family.glm);

		l0=-0.5*g1$null.deviance
		l1=logLik(g1)
		n<-nrow(mc$data)

    r2.cs<-1-exp(l0-l1)^(2/n)
    #cat(l0,",",l1,",",n,",",r2.cs,"\n")
    list(
		  r2.m=1-(l1/l0),
		  r2.cs=r2.cs,
		  r2.n=r2.cs/(1-exp(l0)^(2/n)),
		  r2.e=1-(l1/l0)^(-(2/n)*l0)
		)
	}

}
#' Provides fit indexes for mixed models, based on Luo and Azen (2012).
#'
#' @references
#' \itemize{
#' \item Luo, W., & Azen, R. (2012). Determining Predictor Importance in Hierarchical Linear Models Using Dominance Analysis. Journal of Educational and Behavioral Statistics, 38(1), 3-31. doi:10.3102/1076998612458319
#' }
#' @inheritParams using-fit-indexes
#' @family fit indexes
#' @export

da.lmerMod.fit<-function(...) {
  if (!requireNamespace("lme4", quietly = TRUE)) {
    stop("lme4 needed for this function to work. Please install it.",
      call. = FALSE)
  }
	mc=match.call()
	function(x) {
		if(x=="names") {
			return(c("rb.r2.1","rb.r2.2","sb.r2.1","sb.r2.2"))
		}

		l1<-lme4::lmer(x,data=mc$data);
		lmmr2<-lmmR2(m.null=mc$null.model, l1)
		list(rb.r2.1=lmmr2$rb.r2.1,rb.r2.2=lmmr2$rb.r2.2, sb.r2.1=lmmr2$sb.r2.1,sb.r2.2=lmmr2$sb.r2.2)
	}
}

#' Provides coefficient of determination for lineal models, using covariance/correlation matrix.
#'
#' Uses \eqn{R^2} (coefficient of determination)
#' See \code{\link{lmWithCov}}
#' @inheritParams using-fit-indexes
#' @family fit indexes
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


#' Provides coefficient of determination for multivariate models.
#' Uses
#' @return A list with several fit indexes
#' \item{r.squared.xy}{\eqn{R^2_{XY}}}
#' \item{p.squared.yx}{\eqn{P^2_{YX}}}
#' See \code{\link{mlmWithCov}}
#' @inheritParams using-fit-indexes
#' @references
#' Azen, R., & Budescu, D. V. (2006). Comparing Predictors in Multivariate Regression Models: An Extension of Dominance Analysis. Journal of Educational and Behavioral Statistics, 31(2), 157-180. doi:10.3102/10769986031002157
#' @family fit indexes
#' @export
da.mlmWithCov.fit<-function(...) {
  mc=match.call()
  function(x) {
    if(x=="names") {
      return(c("r.squared.xy","p.squared.yx"))
    }
    mlm.1<-mlmWithCov(x,mc$base.cov)
    list(r.squared.xy=mlm.1$r.squared.xy, p.squared.yx=mlm.1$p.squared.yx)
  }
}
