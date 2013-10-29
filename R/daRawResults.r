#' Retrieve raw results for dominance analysis
#' Provides name functions, base fit values and 
#' matrix for models vs predictors importance
#' @export
daRawResults<-function(x,constants=c(),fit.functions="default",data=NULL,null.model=NULL, ...) {
  f<-formula(x)
  t.f<-terms(f)
  base.cov=NULL
  if(is(x,"lmWithCov")) {
	base.cov=x$cov
  } else if (is.null(data)) {
	data=getData(x)
	if(is.null(data)) {
		stop("Not implemented")
	}
	
  }
  x.terms<-sort(attr(t.f,"term.labels"))
  respuesta<-rownames(attr(terms(f),"factors"))[attr(t.f,"response")]
  
  models<-daSubmodels(x,constants)
  fm<-formulas.daSubmodels(models)
  if(fit.functions=="default") {
	# Should return 
	fit.functions<-do.call(paste0("da.",class(x)[1],".fit"),list(data=data,null.model=null.model,base.cov=base.cov))
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
   out<-list(fit.functions=ffn, fits=raw.vals, base.fits=fits,level=models$level)
   class(out)<-"daRawResults"
   out
}
