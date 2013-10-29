#' Standard fit function for regression
#' Uses R^2 (coefficient of determination) as fit index
#' @export
da.lm.fit<-function(...) {
	mc=match.call()
	function(x) {
	if(x=="names") {
		return("r2")
	}
	 list(r2=summary(lm(x, data=mc$data))$r.squared)}
}
#' Uses fit indexes provided by Azen and Traxel(2009)
#' - r2.m: McFadden(1974)
#' - r2.n: Nagelkerke(1991)
#' - r2.e: Estrella(1998)
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
#'  Uses fit index provided by Luo and Azen (2012) 
#' @export
da.lmerMod.fit<-function(...) {
	require(glmmextra)
	mc=match.call()
	function(x) {
		if(x=="names") {
			return(c("rb.r2.1","rb.r2.2","sb.r2.1","sb.r2.2"))
		}

		l1<-lmer(x,data=mc$data);  
		lmmr2<-lmmR2(m.null=mc$null.model, l1)
		list(rb.r2.1=lmmr2$rb.r2.1,rb.r2.2=lmmr2$rb.r2.2, sb.r2.1=lmmr2$sb.r2.1,sb.r2.2=lmmr2$sb.r2.2)
	}
}

#' Uses R^2 (coefficient of determination)
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
