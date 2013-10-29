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

	daModels<-daSubmodels(x,constants)
	daRaw<-daRawResults(x,constants,fit.functions,data,null.model,...)
	daAverageByLevel<-daAverageContributionByLevel(daRaw)
	daAverageGeneral<-lapply(daAverageByLevel,function(x) {colMeans(x[,-1])} )
	list(
	  predictors=daModels$predictors,
	  constants=daModels$constants,
	  fit.functions=daRaw$fit.functions,
	  fits=daRaw,
	  contribution.by.level=daAverageByLevel,
	  contribution.average=daAverageGeneral,
	  complete=daCompleteDominance(daRaw),
	  conditional=daConditionalDominance(daRaw),
	  general=daGeneralDominance(daRaw)
	  )
}
