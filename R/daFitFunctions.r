#' Provides fit indices for different regression models.
#'
#' \code{\link{dominanceAnalysis}} tries to infer, based on the class of the
#' model provided, the appropriate fit indices, using the scheme
#' da.CLASS.fit for name. This method has two interfaces, one for retrieving
#' the names of the fit indices, and another to retrieve the indices based
#' on the data.
#'
#' Interfaces are:
#' \itemize{
#' \item \code{da.CLASS.fit("names")} returns a vector with names for fit indices
#' \item \code{da.CLASS.fit(original.model, data, null.model, base.cov=NULL)} returns a function with one parameter, the formula to calculate the submodel.
#' }
#' @param original.model Original fitted model
#' @param newdata Data used in update statement
#' @param null.model Null model, only needed for HLM models.
#' @param base.cov Required if only a covariance/correlation matrix is provided.
#' @name using-fit-indices

NULL

#' Provides coefficient of determination for \code{lm} models.
#'
#' Uses \eqn{R^2} (coefficient of determination) as fit index
#' @param original.model Original fitted model
#' @param newdata Data used in update statement
#' @param ... ignored
#' @return A function described by \link{using-fit-indices} description for interface.
#'         You could retrieve \code{r2} index.
#' @export
#' @family fit indices
#' @importFrom stats lm
#' @examples
#' x1<-rnorm(1000)
#' x2<-rnorm(1000)
#' y <-x1+x2+rnorm(1000)
#' df.1=data.frame(y=y,x1=x1,x2=x2)
#' lm.1<-lm(y~x1+x2)
#' da.lm.fit(lm.1)("names")
#' da.lm.fit(lm.1)(y~x1)
da.lm.fit<-function(original.model, newdata=NULL, ...) {
  mc=match.call()
  function(x) {
  	if(x=="names") {
  		return("r2")
  	}
    if(!is.null(newdata)) {
      mod<-update(original.model, x, data=newdata)
    } else {
      mod<-update(original.model, x)
    }
	 list(r2=summary(mod)$r.squared)
	}
}

#' Provides fit indices for GLM models.
#'
#' These functions are only available for logistic regression models and are
#' based on the work of Azen and Traxel (2009).
#'
#' Check \link{daRawResults}.
#' @param original.model Original fitted model
#' @param newdata Data used in update statement
#' @param ...  ignored
#' @return A function described by \link{using-fit-indices}. You could retrieve the following indices:
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
#' @family fit indices
#' @importFrom stats lm glm logLik update
#' @export
#' @examples
#' x1<-rnorm(1000)
#' x2<-rnorm(1000)
#' x3<-rnorm(1000)
#' y<-factor(runif(1000) > exp(x1+x2+x3)/(1+exp(x1+x2+x3)))
#' df.1=data.frame(x1,x2,x3,y)
#' glm.1<-glm(y~x1+x2+x3,data=df.1,family=binomial)
#' da.glm.fit(original.model=glm.1)("names")
#' da.glm.fit(original.model=glm.1)(y~x1)
da.glm.fit<-function(original.model, newdata=NULL,...) {

	mc=match.call()
	function(x) {
	    if(x=="names") {
			return(c("r2.m","r2.cs","r2.n","r2.e"))
	    }


	  if(!is.null(newdata)) {
	    g1<-update(original.model, x, data=newdata)
	    g.null<-update(original.model,~1, data=newdata)
	  } else {
	    g1<-update(original.model, x)
	    g.null<-update(original.model,~1)
	  }

		#print(logLik(g.null))
		#print(logLik(g1))
		#l0=-0.5*g1$null.deviance

		#print(l0)


		l0=logLik(g.null)
		l1=logLik(g1)
		n<-nrow(g1$model)

		r2.cs<- 1- exp(2/n*(l0 - l1) )
		#cat(l0,",",l1,",",n,",",r2.cs,"\n")
    list(
		  r2.m=1-(l1/l0),
		  r2.cs=r2.cs,
		  r2.n=r2.cs/(1-exp(l0)^(2/n)),
		  r2.e=1-(l1/l0)^(-(2/n)*l0) # Estrella
		)
	}
}





#' Provides fit indices for betareg models.
#'
#' Note that the Nagelkerke and Estrella coefficients are designed for discrete dependent variables
#' and thus cannot be used in this context. Instead, the Cox and Snell coefficient is recommended,
#' along with the pseudo-\eqn{R^2}. It is worth noting that McFadden's index may produce
#' negative values and should be avoided.
#'
#' @param original.model Original fitted model
#' @param newdata Data used in update statement
#' @param ...  ignored
#'
#' @return A function described by \link{using-fit-indices}. You could retrieve following indices:
#' \describe{
#' \item{\code{r2.pseudo}}{Provided by betareg by default}
#' \item{\code{r2.m}}{McFadden(1974)}
#' \item{\code{r2.cs}}{Cox and Snell(1989).}
#' }
#'
#' @references
#' \itemize{
#' \item Cox, D. R., & Snell, E. J. (1989). The analysis of binary data (2nd ed.). London, UK: Chapman and Hall.
#' \item Estrella, A. (1998). A new measure of fit for equations with dichotomous dependent variables. Journal of Business & Economic Statistics, 16(2), 198-205. doi: 10.1080/07350015.1998.10524753.
#' \item McFadden, D. (1974). Conditional logit analysis of qualitative choice behavior. In P. Zarembka (Ed.), Frontiers in econometrics (pp. 104-142). New York, NY: Academic Press.
#' \item Shou, Y., & Smithson, M. (2015). Evaluating Predictors of Dispersion:A Comparison of Dominance Analysis and Bayesian Model Averaging. Psychometrika, 80(1), 236-256.
#' }
#'
#' @family fit indices
#' @importFrom stats lm logLik update
#' @export
#'
da.betareg.fit<-function(original.model, newdata=NULL, ...) {
  if (!requireNamespace("betareg", quietly = TRUE)) { #nocov start
    stop("betareg needed for this function to work. Please install it.",
         call. = FALSE)
  } #nocov end
  mc=match.call()
  function(x) {
    if(x=="names") {
      return(c("r2.cs","r2.pseudo","r2.m"))
    }

    if(!is.null(newdata)) {
      g1<-update(original.model, x,data=newdata)
      g.null<-update(original.model,~1, data=newdata)
    } else {
      g1<-update(original.model, x)
      g.null<-update(original.model,~1)
    }

    pseudo.r2<-g1$pseudo.r.squared
    if(is.na(pseudo.r2)) {
      pseudo.r2<-0
    }

    l0=logLik(g.null)
    l1=logLik(g1)
    n<-nrow(g1$model)


    r2.cs<- 1-   exp(2/n*(l0 - l1) )
    #cat(l0,",",l1,",",n,",",r2.cs,"\n")
    list(
      r2.cs=r2.cs,
      r2.pseudo=pseudo.r2,
      r2.m=1-(l1/l0)
    )
  }
}

#' Provides fit indices for ordinal regression models, based on the Nagelkerke (1991) method.
#'
#' @param original.model Original fitted model
#' @param newdata Data used in update statement
#' @param ... ignored
#' @return A function described by \link{using-fit-indices} description for interface.
#'         You could retrieve \code{r2.n} index, corresponding to Nagelkerke method.
#' @references
#' \itemize{
#' \item Nagelkerke, N. J. D. (1991). A Note on a General Definition of the Coefficient of Determination. Biometrika, 78(3), 691-692. doi:10.1093/biomet/78.3.691
#' }
#' @importFrom stats lm logLik update
#' @family fit indices
#' @export

da.clm.fit<-function(original.model, newdata=NULL, ...) {
	if (!requireNamespace("performance", quietly = TRUE)) { #nocov start
    stop("performance needed for this function to work. Please install it.",
         call. = FALSE)
  } #nocov end
  mc=match.call()
  function(x) {
    if(x=="names") {
      return(c("r2.n"))
    }

    if(!is.null(newdata)) {
      g1<-update(original.model, x,data=newdata)
#      g.null<-update(original.model,~1, data=newdata)
    } else {
      g1<-update(original.model, x)
#      g.null<-update(original.model,~1)
    }

    nagelkerge<-as.numeric(performance::r2_nagelkerke(g1))
    list(
      r2.n=nagelkerge
    )
  }

}


#' Provides fit indices for hierarchical linear models, based on
#' Nakagawa et al.(2017) and Luo and Azen (2013).
#'
#' @param original.model Original fitted model
#' @param null.model needed for HLM models
#' @param newdata Data used in update statement
#' @param ... ignored
#' @return A function described by \link{using-fit-indices} description for interface.
#'         By default, four indices are provided:
#'         \item{rb.r2.1}{Amount of  Level-1 variance explained by the addition of the predictor. }
#'         \item{rb.r2.2}{Amount of  Level-2 variance explained by the addition of the predictor.}
#'         \item{sb.r2.1}{Proportional reduction in error of predicting scores at Level 1 }
#'         \item{sb.r2.2}{Proportional reduction in  error of predicting cluster means at Level 2}
#'         If \code{performance} library is available, the two following indices are also available:
#'         \item{n.marg}{Marginal R2 coefficient based on Nakagawa et al. (2017). Considers only the variance of the fixed effects. }
#'         \item{n.cond}{Conditional R2 coefficient based on Nakagawa et al. (2017). Takes both the fixed and random effects into account.}
#' @references
#' \itemize{
#' \item Luo, W., & Azen, R. (2013). Determining Predictor Importance in Hierarchical Linear Models Using Dominance Analysis. Journal of Educational and Behavioral Statistics, 38(1), 3-31. doi:10.3102/1076998612458319
#' \item Nakagawa, S., Johnson, P. C. D., and Schielzeth, H. (2017). The coefficient of determination R2 and intra-class correlation coefficient from generalized linear mixed-effects models revisited and expanded. Journal of The Royal Society Interface, 14(134), 20170213.
#' }
#' @family fit indices
#' @export

da.lmerMod.fit<-function(original.model, null.model, newdata=NULL, ...) {
  if (!requireNamespace("lme4", quietly = TRUE)) { #nocov start
    stop("lme4 needed for this function to work. Please install it.",
      call. = FALSE)
  } #nocov end

  performance.available<-requireNamespace("performance", quietly=TRUE)
	mc=match.call()
	function(x) {
		if(x=="names") {

		  if(performance.available) {
		    names.out<-c("n.marg","n.cond","rb.r2.1","rb.r2.2","sb.r2.1","sb.r2.2")
		  } else {
		    names.out<-c("rb.r2.1","rb.r2.2","sb.r2.1","sb.r2.2")
		  }
		  return(names.out)
		}

	  if(!is.null(newdata)) {
	    l1<-update(original.model, x,data=newdata)
	    g.null<-update(null.model, data=newdata)
	  } else {
	    l1<-update(original.model, x)
	    g.null<-null.model
	  }

		lmmr2<-lmmR2(m.null=g.null, l1)


		out<-list(rb.r2.1=lmmr2$rb.r2.1,rb.r2.2=lmmr2$rb.r2.2, sb.r2.1=lmmr2$sb.r2.1,sb.r2.2=lmmr2$sb.r2.2)
		if(performance.available) {
      r2.nak<-performance::r2_nakagawa(l1)
      out$n.marg<-r2.nak[[2]]
      out$n.cond<-r2.nak[[1]]
		}
    out
	}
}

#' Provides coefficient of determination for linear models, using covariance/correlation matrix.
#'
#' Uses \eqn{R^2} (coefficient of determination).
#' See \code{\link{lmWithCov}}.
#'
#' @param base.cov variance/covariance matrix
#' @param ... ignored
#' @return A function described by \link{using-fit-indices} description for interface.
#'         You could retrieve \code{r2} index.
#' @family fit indices
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
#' @return A list with several fit indices
#' \describe{
#' \item{\code{r.squared.xy}}{Corresponds to \eqn{R^2_{XY}}}
#' \item{\code{p.squared.yx}}{Corresponds to \eqn{P^2_{YX}}}
#' }
#' See \code{\link{mlmWithCov}}
#' @references
#' Azen, R., & Budescu, D. V. (2006). Comparing Predictors in Multivariate Regression Models: An Extension of Dominance Analysis. Journal of Educational and Behavioral Statistics, 31(2), 157-180. doi:10.3102/10769986031002157
#' @family fit indices
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

#' Provides coefficient of determination for \code{dynlm} models.
#'
#' Uses \eqn{R^2} (coefficient of determination) as fit index
#' @param original.model Original fitted model
#' @param newdata Data used in update statement
#' @param ... ignored
#' @return A function described by \link{using-fit-indices} description for interface
#' @export
#' @family fit indices
da.dynlm.fit<-function(original.model, newdata=NULL, ...) {
  mc=match.call()
  function(x) {
    if(x=="names") {
      return("r2")
    }

    environment(x)<-environment()
    #dlm<-dynlm::dynlm(formula=x,data=data)

    if(!is.null(newdata)) {
      dlm<-update(original.model, x, data=newdata)
    } else {
      dlm<-update(original.model, x)
    }

    out<-list(r2=summary(dlm)$r.squared)
    out
  }
}
