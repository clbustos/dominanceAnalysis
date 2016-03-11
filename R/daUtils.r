#' Return the index of row equals to r on m
#' @param m matrix
#' @param r row
#' @keywords internal
getEqualRowId<-function(m,r) {
	which(rowSums(t(t(m)==r))==length(r))
}

#' Returns data from different models
#'
#' @keywords internal
getData<-function(x) {
  data=NULL;
  if(is(x,"glm")) {
	data=x$data
  } else if(is(x,"lm")) {
	  if(!is.null(x$call$data)) {
		data=get(as.character(x$call$data))
	  } else {
		stop("Can't get data for lm")
	  }
  } else if(is(x,"lmerMod")) {
		data=x@frame
  }
  data;
}
