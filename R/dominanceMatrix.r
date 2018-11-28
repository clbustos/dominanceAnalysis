#' Calculates the dominance for a given matrix
#'
#' Dominance is defined between a pair of variables if all values on a given
#' variable are higher than for other variable.
#'
#' @param x matrix with fit indexes
#' @param undefined.value value when no dominance can be established
#' @return A matrix representing dominance. 1 represented domination of the row variable
#'         over the column variable, 0 dominance of the column over the row variable.
#'         Undefined dominance is represented by \code{undefined.value} parameter
#' @importFrom stats na.omit
#' @keywords internal
dominanceMatrix<-function(x,undefined.value=0.5) {
	vars<-colnames(x)
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
	  ma
}
