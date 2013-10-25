#' Matrix of Conditional dominance of one variable over another
#' Uses daRawResults as input
daConditionalDominance<-function(daRR) {
  daACBL<-daAverageContributionByLevel(daRR)
  analize<-function(x) {
		x<-x[,-1]
	  dominanceMatrix(x)
	}
	lapply(daACBL,analize)
}
