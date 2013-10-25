#' Calculates the dominance for a given matrix
#' Dominance is defined between a pair of variables if all values on a given
#' variable are higher than for other variable
dominanceMatrix<-function(x) {
	vars<-colnames(x)
	  m<-length(vars)
	  ma<-matrix(0,m,m,dimnames=list(vars,vars))
	  
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
