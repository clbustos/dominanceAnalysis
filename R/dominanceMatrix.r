#' Retrieve or calculates a dominance matrix for a given object
#'
#' This methods calculates or retrieve dominance matrix
#'
#' To calculate a dominance matrix from a matrix or dataframe, use
#'
#'   \code{dominanceMatrix(x,undefined.value)}.
#'
#' To retrieve the dominance matrices from a dominanceAnalysis object, use
#'
#'    \code{dominanceMatrix(x,type,fit.function)}
#'
#' @param x matrix (calculate) or dominanceAnalysis (retrieve)
#' @param undefined.value value when no dominance can be established
#' @param type type of dominance matrix to retrieve. Could be complete, conditional or general
#' @param fit.function specific fit function to retrieve. If not specified, retrieve the first
#'                     method according to fit.functions
#' @param ... extra arguments. Check  \code{\link{dominanceMatrix.matrix}} and \code{\link{dominanceMatrix.dominanceAnalysis}} for specific arguments
#' @return A matrix representing dominance. 1 represented domination of the row variable
#'         over the column variable, 0 dominance of the column over the row variable.
#'         Undefined dominance is represented by \code{undefined.value} parameter
#' @export
dominanceMatrix<-function(x, undefined.value=0.5, type=NULL, fit.function=NULL, ...) {
  UseMethod("dominanceMatrix",x)
}

#' Calculates the dominance for a given matrix.
#' Just transform the data.frame to matrix an call \link{dominanceMatrix.matrix}
#' @export
#' @keywords internal
dominanceMatrix.data.frame<-function(x,undefined.value=0.5, type=NULL, fit.function=NULL, ...) {
  x<-as.matrix(x)
  dominanceMatrix.matrix(x, undefined.value = 0.5)
}

#' Calculates the dominance for a given matrix
#'
#' Dominance is defined between a pair of variables if all values on a given
#' variable are higher than for other variable.
#'
#' @param x matrix with fit indexes. Should have colnames
#' @param undefined.value value when no dominance can be established
#' @param type unused
#' @param fit.function unused
#' @return A matrix representing dominance. 1 represented domination of the row variable
#'         over the column variable, 0 dominance of the column over the row variable.
#'         Undefined dominance is represented by \code{undefined.value} parameter
#' @importFrom stats na.omit
#' @export
#' @keywords internal
dominanceMatrix.matrix<-function(x,undefined.value=0.5, type=NULL, fit.function=NULL, ...) {
	vars<-colnames(x)
	if(is.null(vars)) {
	  stop("Matrix should have colnames")
	}
	  m<-length(vars)
	  ma<-matrix(undefined.value,m,m,dimnames=list(vars,vars))

	  for(i in 1:(m-1)) {
		for(j in (i+1):m) {
		  comps<-na.omit(cbind(x[,i,drop=F],x[,j,drop=F]))
		  if(mean(comps[,1]>comps[,2])==1)
		  {
			ma[i,j]<-1
			ma[j,i]<-0
		  }

		  if(mean(comps[,1]<comps[,2])==1)
		  {
			ma[i,j]<-0
			ma[j,i]<-1
		  }

		}
	  }
	  #class(ma)<-c("dominanceMatrix","matrix")
	  ma
}


#' Retrieve a dominance matrix for a dominanceAnalysis object
#'
#' This methods allows a common interface to retrieve all dominance matrices
#' from dominanceAnalysis objects
#'
#' @param x a dominanceAnalysis object
#' @param undefined.value unused
#' @param type type of dominance matrix. Could be complete, conditional or general
#' @param fit.function specific fit function to retrieve. If not specified, retrieve the first
#'                     method according to fit.functions
#' @return A matrix representing dominance. 1 represented domination of the row variable
#'         over the column variable, 0 dominance of the column over the row variable.
#'         Undefined dominance is represented by \code{undefined.value} parameter
#' @importFrom stats na.omit
#' @export
#' @keywords internal
dominanceMatrix.dominanceAnalysis<-function(x, undefined.value=0.5, type=NULL, fit.function=NULL,...) {
  if(!(type %in% c("complete","conditional","general"))) {
    stop("Matrix type is incorrect")
  } else {
    if(is.null(fit.function)) {
      fit.function=x$fit.functions[1]
    }
    x[[type]][[fit.function]]
  }
}

