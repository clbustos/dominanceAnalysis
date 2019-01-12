#' Calculates the average contribution by level for a daRawResult object
#'
#' @param x daRawResults object
#' @return list, with key named as a fit index
#'               and values are matrix, with the average
#'               contribution of each variable on every level
#' @importFrom stats aggregate
#' @keywords internal
daAverageContributionByLevel<-function(x) {
	ff<-x$fit.functions
	out<-list()

	for(i in ff) {
		res<-aggregate(x$fits[[i]],list(level=x$level),mean,na.rm=T)
		out[[i]]<-res[res$level<max(x$level),]
	}
	out
}
