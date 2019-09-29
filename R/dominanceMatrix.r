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
#'    \code{dominanceMatrix(x,type,fit.function,drop)}
#'
#' @param x matrix (calculate) or dominanceAnalysis (retrieve)
#' @param undefined.value value when no dominance can be established
#' @param type type of dominance matrix to retrieve. Could be complete, conditional or general
#' @param fit.functions name of the fit indices to retrieve. If NULL, all fit indices will be retrieved
#' @param drop  if TRUE and just one fit index is available, returns a matrix. Else, returns a list
#' @param ordered Logical. If TRUE, sort the output according to dominance.
#' @param ... extra arguments. Not used
#' @return for matrix and data-frame, returns a matrix representing dominance.
#'          1 represents domination of the row variable over the column variable,
#'          0 dominance of the column over the row variable.
#'          Undefined dominance is represented by \code{undefined.value} parameter.
#'          For dominanceAnalysis object, returns a matrix, if \code{drop} parameter
#'          if TRUE and just one index is available. Else, a list is returned, with
#'          keys as name of fit-indices and values as matrices, as described previously.
#' @export
#' @family retrieval methods
#' @examples
#' # For matrix or data.frame
#' mm<-data.frame(a=c(5,3,2),b=c(4,2,1),c=c(5,4,3))
#' dominanceMatrix(mm)
#' # For dominanceAnalysis
#' data(longley)
#' da.longley<-dominanceAnalysis(lm(Employed~.,longley))
#' dominanceMatrix(da.longley,type="complete")

dominanceMatrix<-function(x, ...) {
  UseMethod("dominanceMatrix",x)
}

#' Calculates the dominance for a given matrix.
#' Just transform the data.frame to matrix an call \link{dominanceMatrix.matrix}
#' @export
#' @rdname dominanceMatrix

dominanceMatrix.data.frame<-function(x,undefined.value=0.5, ordered=FALSE, ...) {
  x<-as.matrix(x)
  dominanceMatrix.matrix(x, undefined.value = undefined.value,ordered=ordered)
}

#' Calculates the dominance for a given matrix
#' @importFrom stats na.omit
#' @export
#' @rdname dominanceMatrix


dominanceMatrix.matrix<-function(x,undefined.value=0.5, ordered=FALSE, ...) {
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
	  if(ordered ) {
	    ma<-sort.matrix(ma)
	  }
	  ma
}


#' Retrieve a dominance matrix for a dominanceAnalysis object
#'
#' This methods allows a common interface to retrieve all dominance matrices
#' from dominanceAnalysis objects
#'
#' @importFrom stats na.omit
#' @export
#' @rdname dominanceMatrix
dominanceMatrix.dominanceAnalysis<-function(x, type, fit.functions=NULL,drop=TRUE, ordered=FALSE, ...) {
  if(!(type %in% c("complete","conditional","general"))) {
    stop("Matrix type is incorrect")
  } else {
    if(is.null(fit.functions)) {
      fit.functions=x$fit.functions
    }
    matrices.type<-lapply(x[[type]],function(xx) {
      colnames(xx)<-replaceTermsInString(colnames(xx), x$terms)
      rownames(xx)<-replaceTermsInString(rownames(xx), x$terms)
      xx
    })

    if(length(fit.functions)==1 & drop) {
      if(ordered) {
        sort.matrix(matrices.type[[fit.functions]])
      } else {
        matrices.type[[fit.functions]]
      }
    } else {
      rr<-matrices.type[fit.functions]
      if(ordered) {
        print(rr)
        rr<-lapply(rr, sort.matrix)
        }
      rr
    }
  }
}

# Sort a matrix
#' @keywords internal
sort.matrix<-function(x) {
  or<-order(rowSums(x,na.rm=T),decreasing = T)
  x[or,or]
}
