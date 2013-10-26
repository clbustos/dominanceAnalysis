#' Returns the average contribution by level
#' presented usually as row between contributions by predictors
#' @param x daRawResults object
daAverageContributionByLevel<-function(x) {
	ff<-x$fit.functions
	
	out<-list()
	for(i in ff) {
		
		res<-aggregate(x$fits[[i]],list(level=x$level),mean,na.rm=T)
		
		out[[i]]<-res[res$level<max(x$level),]
		
	}
	out
}
