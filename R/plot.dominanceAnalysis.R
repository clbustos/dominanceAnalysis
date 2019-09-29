#' Plot for a \code{\link{dominanceAnalysis}} object
#'
#' @param object a \code{\link{dominanceAnalysis}} object
#' @param which.graph which graph to plot
#' @param fit.function name of the fit indices to retrieve. If NULL, first index will be used
#' @param ... unused
#' @return a ggplot object
#' @export
#' @examples
#' data(longley)
#' lm.1<-lm(Employed~.,longley)
#' da<-dominanceAnalysis(lm.1)
#' # By default, plot complete dominance of first fit function
#' plot(da)
#' # Parameter which.graph defines dominance to plot
#' plot(da,which.graph='conditional')
#' plot(da,which.graph='general')

plot.dominanceAnalysis<-function(x, which.graph=c("complete", "complete_no_facet", "conditional","general"), fit.function=NULL,...) {
  which.graph<-which.graph[1]

  if(is.null(fit.function)) {
    fit.function<-x$fit.functions[[1]]
  }
  # Check
  checkDominanceAnalysis(x)
  if(!(which.graph %in% c("complete", "complete_no_facet", "conditional","general"))) {
    stop("which.graph should be 'complete', 'complete_no_facet', 'conditional' or 'general'")
  }
  if(!(fit.function %in% x$fit.functions)) {
    stop("fit function should be one of the following: ",paste0(x$fit.functions, collapse=" , "))
  }
  if(which.graph %in%  c("complete", 'complete_no_facet')) {
    x.level<-x$fits$level
    #x.names<-rownames(x$fits$fits[[fit.function]])
    x.names<-unlist(tapply(x.level,x.level,function(x) {paste0(x,":", 1:length(x))}))
    x.fits<-x$fits$fits[[fit.function]]
    colnames(x.fits)<-replaceTermsInString(string = colnames(x.fits), x$terms)
    x.df<-data.frame(.level=factor(paste0("Level: ",x.level)), .names=x.names, x.fits)
    x.df.m<-na.omit(reshape2::melt(x.df,id.vars = c(".level",".names")))
    gg<-ggplot2::ggplot(x.df.m, ggplot2::aes_string(x=".names", y="value", color="variable",group="variable", shape=".level")) +
      ggplot2::geom_point(size=2) +
      ggplot2::guides(shape=FALSE) +
      ggplot2::xlab("Submodels") +
      ggplot2::ylab(fit.function) +
      ggplot2::ggtitle("Complete dominance")

    if(which.graph=='complete') {
      gg<-gg+ggplot2::facet_wrap(~.level, scales="free_x")
    }

  }
  if(which.graph=="conditional") {
    cbl.0<-contributionByLevel(x,fit.functions = fit.function)
    cbl<-cbl.0[[fit.function]]
    x.df.m<-reshape2::melt(cbl,id.vars = c("level"))

    gg<-ggplot2::ggplot(x.df.m,
                        ggplot2::aes_string(x="level", y="value", color="variable", group = "variable")) +
      ggplot2::geom_point(size=2) +
      ggplot2::geom_line() +
      ggplot2::guides(shape=FALSE) +
      ggplot2::xlab("Levels") +
      ggplot2::ylab(fit.function) +
      ggplot2::ggtitle("Conditional dominance")
  }
  if(which.graph=="general") {
    av.c<-averageContribution(x,fit.function)[[fit.function]]
    gg<-ggplot2::ggplot(data.frame(variable=names(av.c), value=as.numeric(av.c)),
                        ggplot2::aes_string(x="variable", y="value",fill="variable"))+
      ggplot2::geom_bar(stat="identity")+
      ggplot2::theme_minimal()+
      ggplot2::ylab(fit.function)+
      ggplot2::ggtitle("General Dominance")
  }
  gg
}
