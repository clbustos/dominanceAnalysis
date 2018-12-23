#' Provides fit indexes for different regression models.
#'
#' \code{\link{dominanceAnalysis}} tries to infer, based on the class of the
#' model provided, the appropriate fit indexes, using the scheme
#' da.CLASS.fit for name. This method has two interfaces, one for retrieving
#' the names of the fit indexes, and another to retrieve the indexes based
#' on the data.
#'
#' Interfaces are:
#' \itemize{
#' \item \code{da.CLASS.fit("names")} returns a vector with names for fit indexes
#' \item \code{da.CLASS.fit(data, null.model, base.cov=NULL,family.glm=NULL)} returns a function with one parameter, the formula to calculate the submodel.
#' }
#' @param data Complete data set containing the variables in the model.
#' @param null.model Null model only needed for HLM models.
#' @param base.cov Required if only a covariance/correlation matrix is provided.
#' @param family.glm family param for glm models.
#' @name using-fit-indexes
NULL

#' Provides coefficient of determination for \code{lm} models.
#'
#' Uses \eqn{R^2} (coefficient of determination) as fit index
#' @param data complete data set containing the variables in the model
#' @param ... ignored
#' @return A function described by \link{using-fit-indexes} description for interface
#' @export
#' @family fit indexes
#' @importFrom stats lm
#' @examples
#' x1<-rnorm(1000)
#' x2<-rnorm(1000)
#' y <-x1+x2+rnorm(1000)
#' df.1=data.frame(y=y,x1=x1,x2=x2)
#' da.lm.fit(df.1)("names")
#' da.lm.fit(df.1)(y~x1)
da.lm.fit<-function(data,...) {
  mc=match.call()
  function(x) {
  	if(x=="names") {
  		return("r2")
  	}
	 list(r2=summary(lm(x, data=data))$r.squared)
	}
}

#' Provides fit indexes for GLM models.
#'
#' Functions only available for logistic regression, based on Azen and Traxel(2009).
#'
#' Check \link{daRawResults}.
#' @param data complete data set
#' @param family.glm family for glm method. Use 'binomial' for logistic regression.
#' @param ...  ignored
#' @return A function described by \link{using-fit-indexes}. You could retrieve following indexes
#' \describe{
#' \item{\code{r2.m}}{McFadden(1974)}
#' \item{\code{r2.cs}}{Cox and Snell(1989). Use with caution, because don't have 1 as upper bound}
#' \item{\code{r2.n}}{Nagelkerke(1991), that corrects the upper bound of Cox and Snell(1989) index }
#' \item{\code{r2.e}}{Estrella(1998)}
#' }
#'
#' @references
#' \itemize{
#' \item Azen, R. and Traxel, N. (2009). Using Dominance Analysis to Determine Predictor Importance in Logistic Regression. \emph{Journal of Educational and Behavioral Statistics, 34} (3), 319-347. doi:10.3102/1076998609332754.
#'
#' \item Nagelkerke, N. J. D. (1991). A note on a general definition of the coefficient of determination. \emph{Biometrika, 78}(3), 691-692. doi:10.1093/biomet/78.3.691.
#' \item Cox, D. R., & Snell, E. J. (1989). The analysis of binary data (2nd ed.). London, UK: Chapman and Hall.
#' \item Estrella, A. (1998). A new measure of fit for equations with dichotomous dependent variables. Journal of Business & Economic Statistics, 16(2), 198-205. doi: 10.1080/07350015.1998.10524753
#' \item McFadden, D. (1974). Conditional logit analysis of qualitative choice behavior. In P. Zarembka (Ed.), Frontiers in econometrics (pp. 104-142). New York, NY: Academic Press.
#' }
#' @family fit indexes
#' @importFrom stats lm glm logLik
#' @export
#' @examples
#' x1<-rnorm(1000)
#' x2<-rnorm(1000)
#' x3<-rnorm(1000)
#' y<-factor(runif(1000) > exp(x1+x2+x3)/(1+exp(x1+x2+x3)))
#' df.1=data.frame(x1,x2,x3,y)
#' da.glm.fit(data=df.1)("names")
#' da.glm.fit(data=df.1, family.glm='binomial')(y~x1)
da.glm.fit<-function(data,family.glm,...) {

	mc=match.call()
	function(x) {
	    if(x=="names") {
			return(c("r2.m","r2.cs","r2.n","r2.e"))
		}

		g1<-glm(x,data=data,family=family.glm);

		l0=-0.5*g1$null.deviance
		l1=logLik(g1)
		n<-nrow(mc$data)

    r2.cs<-1-exp(l0-l1)^(2/n)
    #cat(l0,",",l1,",",n,",",r2.cs,"\n")
    list(
		  r2.m=1-(l1/l0),
		  r2.cs=r2.cs,
		  r2.n=r2.cs/(1-exp(l0)^(2/n)),
		  r2.e=1-(l1/l0)^(-(2/n)*l0) # Estrella
		)
	}

}
#' Provides fit indexes for hierarchiecal linear models, based on Luo and Azen (2013).
#'
#' @param data complete data set containing the variables in the model
#' @param null.model needed for HLM models
#' @param ... ignored
#' @references
#' \itemize{
#' \item Luo, W., & Azen, R. (2012). Determining Predictor Importance in Hierarchical Linear Models Using Dominance Analysis. Journal of Educational and Behavioral Statistics, 38(1), 3-31. doi:10.3102/1076998612458319
#' }
#' @inheritParams using-fit-indexes
#' @family fit indexes
#' @export

da.lmerMod.fit<-function(data, null.model, ...) {
  if (!requireNamespace("lme4", quietly = TRUE)) {
    stop("lme4 needed for this function to work. Please install it.",
      call. = FALSE)
  }
	mc=match.call()
	function(x) {
		if(x=="names") {
			return(c("rb.r2.1","rb.r2.2","sb.r2.1","sb.r2.2"))
		}

		l1<-lme4::lmer(x,data=data);
		lmmr2<-lmmR2(m.null=null.model, l1)
		list(rb.r2.1=lmmr2$rb.r2.1,rb.r2.2=lmmr2$rb.r2.2, sb.r2.1=lmmr2$sb.r2.1,sb.r2.2=lmmr2$sb.r2.2)
	}
}

#' Provides coefficient of determination for linear models, using covariance/correlation matrix.
#'
#' Uses \eqn{R^2} (coefficient of determination)
#' See \code{\link{lmWithCov}}
#'
#' @param base.cov variance/covariance matrix
#' @param ... ignored
#'
#' @inheritParams using-fit-indexes
#' @family fit indexes
#' @export
da.lmWithCov.fit<-function(base.cov, ...) {
	mc=match.call()
	function(x) {
		if(x=="names") {
			return(c("r2"))
		}
		list(r2=lmWithCov(x,base.cov)$r.squared)
	}
}


#' Provides coefficient of determination for multivariate models.
#'
#' @param base.cov variance/covariance matrix
#' @param ... ignored
#' @return A list with several fit indexes
#' \describe{
#' \item{\code{r.squared.xy}}{\eqn{R^2_{XY}}}
#' \item{\code{p.squared.yx}}{\eqn{P^2_{YX}}}
#' }
#' See \code{\link{mlmWithCov}}
#' @inheritParams using-fit-indexes
#' @references
#' Azen, R., & Budescu, D. V. (2006). Comparing Predictors in Multivariate Regression Models: An Extension of Dominance Analysis. Journal of Educational and Behavioral Statistics, 31(2), 157-180. doi:10.3102/10769986031002157
#' @family fit indexes
#' @export
da.mlmWithCov.fit<-function(base.cov, ...) {
  mc=match.call()
  function(x) {
    if(x=="names") {
      return(c("r.squared.xy","p.squared.yx"))
    }
    mlm.1<-mlmWithCov(x,base.cov)
    list(r.squared.xy = mlm.1$r.squared.xy, p.squared.yx = mlm.1$p.squared.yx)
  }
}
