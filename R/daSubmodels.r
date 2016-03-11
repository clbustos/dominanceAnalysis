#' Returns all the submodels derived from full models.
#' You could set some variables as constantes, limiting the number of models.
#' Includes, by default, the null model
#' @param x regression class (lm or lmer)
#' @param constants vector of constants
#' @return list with elements level, pred.matrix, predictors, response, constants
#' @export
#' @keywords internal
daSubmodels<-function(x,constants=NULL) {
  f<-formula(x)
  t.f<-terms(f)
  x.terms<-sort(attr(t.f,"term.labels"))
  respuesta<-rownames(attr(terms(f),"factors"))[attr(t.f,"response")]

  if(length(constants)>0) {
	if(sum(constants %in% x.terms)!=length(constants)) {
		stop("all constants should be in predictors")
	}
	x.terms<-x.terms[-which(x.terms %in% constants)]
  }
  # Every grouped term should be considered as a constant
  # Because you don't want to mess with it!!!
  gt<-grep("\\|",x.terms)
  if(length(gt)>0) {
	gt.2<-paste("(",x.terms[gt],")")

	constants<-c(gt.2,constants)
	x.terms<-x.terms[-gt]
  }
  # Set combinations
  models<-list()
  m<-length(x.terms)
  prot.model<-rep(NA,m)
  names(prot.model)<-x.terms
  c.length<-length(constants)

  # Construct the data.frame
  d.f<-NULL
  model.predictors=list()
  ii<-2
  level<-numeric(1)
  pred.matrix<-matrix(0,1,length(x.terms))
  colnames(pred.matrix)<-x.terms
  for(i in 1:m) {
    combinaciones<-combn(x.terms,i)
    models[[i]]<-list()
    for(j in 1:dim(combinaciones)[2]) {
      vars=sort(combinaciones[,j])
      #fc<-formula(f.esp,env=data)
      ss<-1:length(vars)
      #models[[i]][[modelo]]<-list(vars=vars[ss], level=i)
      level[ii]<-i
      pred.matrix<-rbind(pred.matrix,as.numeric(x.terms %in% vars))
      ii<-ii+1
    }
  }
  out<-list(level=level, pred.matrix=pred.matrix, predictors=x.terms, response=respuesta, constants=constants)
  class(out)<-"daSubmodels"
  out
}

#' @keywords internal

names.daSubmodels<-function(x) {
	pm<-x$pred.matrix
	out<-character(nrow(pm))
	base<-NULL
	if(!is.null(x$constants)) {
	base<-paste0(x$constants,collapse="+")
	}

	response<-x$response
	pred<-x$predictors
	for(i in 1:nrow(pm)) {
		f.pred<-paste0(c(base,pred[which(pm[i,]==1)]),collapse="+")
		# Special case!
		if(f.pred=="") {
			f.pred="1"
		}
		out[i]<-f.pred
	}
	out
}
#' Return a list with formulas for a given daSubmodels object
#' @param x daSubmodels
#' @param env environment
#' @return list
#' @export
#' @keywords internal

formulas.daSubmodels<-function(x,env=parent.frame()) {
	pm<-x$pred.matrix
	out<-list()
	base<-NULL
	if(!is.null(x$constants)) {
	base<-paste0(x$constants,collapse="+")
	}

	response<-x$response
	pred<-x$predictors
	for(i in 1:nrow(pm)) {
		f.pred<-paste0(c(base,pred[which(pm[i,]==1)]),collapse="+")
		# Special case!
		if(f.pred=="") {
			f.pred="1"
		}
		f<-paste0(response,"~",f.pred,collapse="")
		out[[i]]<-formula(f,env)
	}
	out
}
