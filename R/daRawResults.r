#' Retrieve raw results for dominance analysis.
#'
#' Provides name functions, base fit values and
#' matrix for models vs predictors importance
#' @param x a model.
#' @param constants a vector of parameter to be fixed on all analysis
#' @param terms     vector of terms to be analyzed. By default, obtained using the formula of model
#' @param fit.functions name of functions to fit.
#' @param data Provides full data, if can't be obtained from the model
#' @param null.model Null model, for LMM models
#' @return a list with this elements
#' \describe{
#' \item{fit.functions}{Name of fit indeces}
#' \item{fits}{Increment on fit indeces, when specific variable is added}
#' \item{base.fits}{Raw fit indeces for each model}
#' \item{level}{Vector of levels, compatible with fits and base.fits}
#' }
#' @importFrom stats formula terms family
#' @keywords internal
daRawResults<-function(x, constants=c(), terms=NULL, fit.functions="default", data=NULL, null.model=NULL, ...) {
  f<-formula(x)
  t.f<-terms(f)
  base.cov<-family.glm<-NULL
  if(is(x,"lmWithCov") | is (x,"mlmWithCov")) {
  	base.cov=x$cov
  } else if (is.null(data)) {
	  data=getData(x)
  	if(is.null(data)) {
  		stop("Not implemented")
  	}
  }
  if(is(x,"glm")) {
    family.glm<-family(x)
  }

  if(is.null(terms)) {
    x.terms<-attr(t.f,"term.labels")
  } else {
    x.terms<-terms
  }
  response<-rownames(attr(terms(f),"factors"))[attr(t.f,"response")]

  models<-daSubmodels(x = x,constants = constants, terms=terms)
  fm<-formulas.daSubmodels(models)

  if(fit.functions=="default") {
	# Should return
	  fit.functions<-do.call(paste0("da.",class(x)[1],".fit"), list(data=data, null.model=null.model, base.cov=base.cov, family.glm=family.glm))
  }
  ffn=fit.functions("names")

  fits<-matrix(0, nrow(models$pred.matrix), length(ffn))
  rownames(fits)<-names.daSubmodels(models)
  colnames(fits)<-ffn
  model.predictors<-matrix(0,nrow(models$pred.matrix),length(models$predictors)+length(constants))
  if(length(constants)>0) {
	  model.predictors[,1:length(constants)]<-1
  }
  model.predictors[,(length(constants)+1):ncol(model.predictors)]<-models$pred.matrix
  vars.predictor<-c(constants,models$predictors)
  g.model.matrix<-matrix(NA,nrow(models$pred.matrix),length(models$predictors))
  rownames(g.model.matrix)<-names.daSubmodels(models)
  colnames(g.model.matrix)<-models$predictors
  #print(model.predictors)
  # We generate the global fits
   for(i.preds in 1:nrow(model.predictors)) {
		fit.g<-fit.functions(fm[[i.preds]])
		for(ff.i in 1:length(ffn)) {
		#print(i.preds)
		#cat(ffn,":",ff.i,"\n")
			fits[i.preds, ff.i]<-fit.g[[ffn[ff.i]]]
		}
	}


	raw.vals=list()
   for(ff in ffn) {
	  mm<-g.model.matrix
	  for(i.preds in 1:nrow(model.predictors)) {
		preds<-models$pred.matrix[i.preds,]
		for(j in 1:length(models$predictors)) {
			if(preds[j]==1) {
				next
			}
			g.model<-preds
			g.model[j]<-1
			er<-getEqualRowId(models$pred.matrix,g.model)
			mm[i.preds,j]<-fits[er,ff]-fits[i.preds,ff]

		}
	  }
	  raw.vals[[ff]]<-mm
   }
   out<-list(fit.functions = ffn, fits=raw.vals, base.fits=fits, level=models$level)
   class(out)<-"daRawResults"
   out
}
