#' Calculates several measures of fit for Linear Mixel Models
#' based on Lou and Azen (2013) text.
#' Models could be lmer or lme models
#' @param m.null Null model (only with random intercept effects)
#' @param m.full Full model
#' @return lmmR2 class
#' @importFrom stats sigma
#' @importFrom methods is
#' @export
lmmR2<-function(m.null, m.full) {
  test.lmer.class<-function(x) {
    class(x) %in% c("mer","lmerMod","lmerTest","lmerModLmerTest")
  }

	if (test.lmer.class(m.null) & test.lmer.class(m.full)) {
		return(lmmR2.mer(m.null,m.full))
	} else {
		stop("Not implemented for other classes than lmer")
	}
}

# Calculates coefficients of determination for different models on mer models
#
# Calculates the four R^2 presents on Lou and Azen (2013) text.
# Should extract the intercepts for each model
lmmR2.mer<-function(m.null,m.full) {
  # First, I verify the group structure.
  # If the structure isn't the same, I'm in trouble
	v.0<-lme4::VarCorr(m.null)
	v.1<-lme4::VarCorr(m.full)
	#print(names(v.0))
	#print(names(v.1))
	n.v.0<-length(names(v.0))
	n.v.1<-length(names(v.1))
	if(!(n.v.0==n.v.1 && all.equal(names(v.0),names(v.1)))) {
		stop("Groups should be equal")
	}
	# recojo los sigmas
	sigmas=c(sigma(m.null)^2, sigma(m.full)^2)
	# recojo los thetas
	thetas.0=sapply(v.0,function(x) {x[1,1]})
	thetas.1=sapply(v.1,function(x) {x[1,1]})
	# recojo el largo promedio
	nn=sapply(m.null@flist,function(x) {
		length(levels(x)) / sum(1/table(x))
	})
	rb.r2.1<-1-(sigmas[2]/sigmas[1])
	rb.r2.2<-1-(sum(thetas.1)/sum(thetas.0))
	sb.r2.1<-1-((sigmas[2]+sum(thetas.1))/(sigmas[1]+sum(thetas.0)))
	sb.r2.2<-1-(  sigmas[2]+sum(thetas.1*nn)) / (sigmas[1]+sum(thetas.0*nn))
	out<-list(sigmas=sigmas,t0=thetas.0,t1=thetas.1, nn=nn, rb.r2.1=rb.r2.1, rb.r2.2=rb.r2.2, sb.r2.1=sb.r2.1, sb.r2.2=sb.r2.2)
	class(out)<-"lmmR2"
	out
}




#' Print method for  lmmR2 models summary
#' @param x    lmmR2 object
#' @param ...  extra arguments for print
#' @keywords internal

print.lmmR2<-function(x,...) {
	print(summary.lmmR2(x), ...)
}

#' Print method for  lmmR2 models summary
#' @param x    summary.lmmR2 object
#' @param ...  unused
#' @keywords internal

print.summary.lmmR2<-function(x, ...) {
	cat("Explanatory power of Multilevel Model\n")
	cat("=====================================\n")
	cat("Variances:\n")
	print(x$m1)
	cat("Indexes:\n")
	print(x$m2,row.names=F)
	cat("\n")

}

#' Summary for lmmR2 models
#' @param object lmmR2 object
#' @param ... unused
#' @keywords internal

summary.lmmR2<-function(object, ...) {
  x<-object
  v.null<-c(x$sigmas[1],x$t0)
  v.full<-c(x$sigmas[2],x$t1)

	m1<-data.frame(avg.size=c(1,x$nn),null=v.null, null.r=v.null/(sum(v.null)),  full=v.full, pseudo.r2= 1-(v.full/v.null) )
	#cat("Variances:\n")
	rownames(m1)[1]<-"Residual"
	#print(m1)
	#cat("Indexes:\n")
	m2<-with(x, data.frame(indexes=c("R & B R1","R & B R2","S & B R1","S & B R2"),
	meaning=c("Within-cluster variance(relative)",
	"Between-cluster variance(relative)",
	"Reduce individual error(total)",
	"Reduce cluster error(total)"
	),
	vals=c(rb.r2.1,rb.r2.2,sb.r2.1,sb.r2.2)))
	#print(m2, row.names=F)
	out=list(m1=m1,m2=m2)

	class(out)<-"summary.lmmR2"
	return(out)
}
