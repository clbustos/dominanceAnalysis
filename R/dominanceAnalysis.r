#' Dominance Analysis
#' Based on Azen and Bodescu(1993) and all their derivations
#' @param x lm, glm or another regression based linear model
#' @param constants variables to remain unchanged between models
#' @param fit.functions list of functions which provides fit indexes for model. 
#' @param data optional data.frame to which fit the formulas
#' @param null.model for mixel models, null model against to test the submodels
#' @param ... Other arguments provided to lm or lmer (not implemented yet)
#' @return dominanceAnalysis object
#' @export 
dominanceAnalysis<-function(x,constants=c(),fit.functions="default",data=NULL,null.model=NULL, ...) {
  f<-formula(x)
  t.f<-terms(f)
  if(class(x)=="lm") {
	  if(is.null(data) & !is.null(x$call$data)) {
		data=get(as.character(x$call$data))
	  }
  } else if(class(x)=="lmerMod") {
	if(is.null(data)) {
		data=x@frame
	}
  }
  
  x.terms<-sort(attr(t.f,"term.labels"))
  respuesta<-rownames(attr(terms(f),"factors"))[attr(t.f,"response")]
  
  models<-daSubmodels(x,constants)
  fm<-formulas.daSubmodels(models)
  if(fit.functions=="default") {
	fit.functions<-do.call(paste0("da.",class(x),".fit"),list(data=data,null.model=null.model))
  }
  
  fits<-matrix(0, nrow(models$pred.matrix),length(fit.functions))
  rownames(fits)<-names.daSubmodels(models)
  colnames(fits)<-names(fit.functions)
  
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
  for(ff in names(fit.functions)) {
	  for(i.preds in 1:nrow(model.predictors)) {
		fit.g<-fit.functions[[ff]](fm[[i.preds]])
		fits[i.preds,ff]<-fit.g
	  } 
   }
	raw.vals=list()
   for(ff in names(fit.functions)) {
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
   list(fit.functions=names(fit.functions), fits=raw.vals,base.fits=fits,level=models$level)
}
getEqualRowId<-function(m,r) {
	which(rowSums(t(t(m)==r))==length(r))
}
# Crea una matriz a partir del análisis de dominancia
dominanceAnalysis.matrix<-function(x) {
  n<-length(x$models)
  m<-x$m
  mat<-matrix(NA,n+1,m)
  colnames(mat)<-x$x.terms
  rownames(mat)<-c("-",names(x$models))
  for(j in 1:m) {
    v<-x$x.terms[j]
    
    mat[1,j]<-x$models[[v]]$r.2
  }
  for(i in 1:length(x$models)) {
    for(j in 1:m) {
      mat[i+1,j]<-x$models[[i]]$adiciones[j]
    }
  }
  mat<-mat[apply(is.na(mat),1,sum)!=m,]
  mat
}
dominanceAnalysis.data.frame<-function(x) {
   da.m<-dominanceAnalysis.matrix(x)
   models<-rownames(da.m)
   rownames(da.m)<-NULL
   r.2<-numeric(length(models))
   level<-numeric(length(models))
   for(i in 1:length(models)) {
     if(models[i] %in% names(x$models)) {
       r.2[i]<-x$models[[models[i]]]$r.2
       level[i]<-x$models[[models[i]]]$level
     }
   }
   cbind(data.frame(vars=models,r.2=r.2,level),da.m)
}

dominanceAnalysis.dominance<-function(x) {
  da.m<-dominanceAnalysis.matrix(x)
  vars<-x$x.terms
  m<-x$m
  ma<-matrix(0,m,m)
  for(i in 1:(m-1)) {
    for(j in (i+1):m) {
      comps<-na.omit(cbind(da.m[,i],da.m[,j]))
      if(mean(comps[,1]>comps[,2])==1) 
      {
        ma[i,j]<-1
        ma[j,i]<-0
      }
      
      if(mean(comps[,1]<comps[,2])==1) 
      {
        ma[i,j]<-0
        ma[j,i]<-1
      }
      
    }
  }
  ma
}
dominanceAnalysis.complete<-function(x) {
  da.df<-dominanceAnalysis.data.frame(x)
  levels.da=0:(x$m-1)
  ma<-matrix(0,x$m,x$m,dimnames=list(levels.da,x$x.terms))
  for(i in levels.da) {
    da.df.s<-da.df[da.df$level==i,-(1:3)]
    ma[i+1,]<-apply(da.df.s,2,mean,na.rm=T)
  }
  ma
}

