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

	daRaw<-daRawResults(x,constants,fit.functions,data,null.model,...)
	daAverageByLevel<-daAverageContributionByLevel(daRaw)
	daAverageGeneral<-lapply(daAverageByLevel,function(x) {colMeans(x[,-1])} )
	list(fits=daRaw,
	  contribution.by.level=daAverageByLevel,
	  contribution.average=daAverageGeneral,
	  complete=daCompleteDominance(daRaw),
	  conditional=daConditionalDominance(daRaw),
	  general=daGeneralDominance(daRaw)
	  )
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


