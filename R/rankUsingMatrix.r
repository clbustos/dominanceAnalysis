#' Dominance of each factor over others
#' Dominance requires that a variable have higher values on all submodels.
#' This method allows to visualize those relation
#' @param x a square matrix
#' @return a vector of string, each one showing what factors dominates others
#' @keywords internal
rankUsingMatrix<-function(x) {
  if(nrow(x)!=ncol(x)) {
    stop("Not symmetric matrix")
  }
  apply(x,1,function(xx) {
    paste0(names(xx)[xx==1],collapse=",")
  })
}
