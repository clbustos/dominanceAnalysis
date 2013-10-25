#' Standard fit function for regression
#' @export
da.lm.fit<-function(...) {
	mc=match.call()
	list(r2=function(x) { summary(lm(x, data=mc$data))$r.squared})
}
da.lmerMod.fit<-function(...) {
	require(glmmextra)
	mc=match.call()
	list(
	rb.r2.1=function(x) {l1<-lmer(x,data=mc$data);  lmmR2(m.null=mc$null.model, l1)$rb.r2.1},
	rb.r2.2=function(x) {l1<-lmer(x,data=mc$data);  lmmR2(m.null=mc$null.model, l1)$rb.r2.2},
	sb.r2.1=function(x) {l1<-lmer(x,data=mc$data);  lmmR2(m.null=mc$null.model, l1)$sb.r2.1},
	sb.r2.2=function(x) {l1<-lmer(x,data=mc$data);  lmmR2(m.null=mc$null.model, l1)$sb.r2.2}
	)
}


da.lmWithCov.fit<-function(...) {
	mc=match.call()
	list(r2=function(x) {lmWithCov(x,mc$base.cov)$r.squared})
}
