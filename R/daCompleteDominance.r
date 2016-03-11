#' Matrix of Complete dominance of one variable over another
#' Uses daRawResults as input
#' @keywords internal
#' @family dominance matrices

daCompleteDominance<-function(daRR) {
	lapply(daRR$fits,dominanceMatrix)
}
