#' Matrix of Complete dominance of one variable over another
#' Uses daRawResults as input
daCompleteDominance<-function(daRR) {
	lapply(daRR$fits,dominanceMatrix)
}
