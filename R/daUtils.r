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
    if(!is.null(x$data) & !is(x$data,"environment")) {
      data=x$data
    } else {
      data=x$model
    }
  } else if(is(x,"lm")) {

    if(!is.null(x$call$data)) {
      #print(where(as.character(x$call$data)))
      data=get(as.character(x$call$data))
	  } else {
      data=x$model
    }
    if(is.null(data)) {
      stop("Can't get data")
    }
  } else if(is(x,"lmerMod")) {
		data=x@frame
  }
  data;
}

#' Check if the given object have the dominanceAnalysis class
#'
#' Stop execution if object isn't a dominanceAnalysis object
#' @param x an object
#' @return boolean TRUE if x is a dominanceAnalysis object, raises an error otherwise
#' @keywords internal
checkDominanceAnalysis<-function(x) {
  if(!inherits(x,"dominanceAnalysis")) {
    stop("parameter da.object should be a dominanceAnalysis object")
  }
  TRUE
}

#' Replace terms by name using the terms definition
#' @param string string to be updated
#' @param replacement string with replacement for strings. values are replaced by names
replaceTermsInString<-function(string,replacement) {
  if(is.null(replacement) || is.null(names(replacement))) {
    string
  } else {
    names.r=names(replacement)
    to.replace<-as.character(replacement)
    for(i in 1:length(names.r)) {
      if(names.r[i]!="") {
        string=sub(to.replace[i], names.r[i], string, fixed=TRUE)
      }
    }
  }
  string
}