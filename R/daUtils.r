#' Return the index of row equals to r on m
#' @param m matrix
#' @param r row
getEqualRowId<-function(m,r) {
	which(rowSums(t(t(m)==r))==length(r))
}
