#' Matrix of General dominance of one variable over another
#' Uses daRawResults as input
daGeneralDominance<-function(daRR) {
  daACBL<-daAverageContributionByLevel(daRR)
  analize<-function(x) {
		x<-x[,-1]
		gm<-matrix(colMeans(x),1,ncol(x),dimnames=list(1,colnames(x)))
	  dominanceMatrix(gm)
	}
	lapply(daACBL,analize)
}
