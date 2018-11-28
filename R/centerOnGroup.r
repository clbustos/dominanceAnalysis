#' Center the variables on groups mean.
#'
#' Returns a dataframe with variables groups means as x.mean
#' and centered variables a x.centered
#' @param x dataframe
#' @param g grouping factor
#' @return New dataframe
#' @importFrom stats aggregate
#' @keywords internal
centerOnGroup<-function(x,g) {
	# First, create the joint distribution
	df1<-data.frame(x)
	df1$.g<-g
	x2<-x
	colnames(x2)<-paste0("mean.",colnames(x))
	df2.1<-aggregate(x2,list(.g=g),mean)
	df2<-merge(df1,df2.1)
	for(i in colnames(x)) {
		df2[[paste0("centered.",i)]]<-df2[[i]]-df2[[paste0("mean.",i)]]
	}
	df2
}
