#' Plot for a \code{\link{dominanceAnalysis}} object
#'
#' @param x a \code{\link{dominanceAnalysis}} object
#' @param which.graph which graph to plot
#' @param fit.function name of the fit indices to retrieve. If NULL, first index will be used
#' @param complete_flipped_axis For complete and complete_no_facet plot, set the R2 on X axis
#'                              to allow easier visualization
#' @param ... unused
#' @return a ggplot object
#' @export
#' @examples
#' data(longley)
#' lm.1<-lm(Employed~.,longley)
#' da<-dominanceAnalysis(lm.1)
#' # By default, plot() shows the general dominance plot
#' plot(da)
#' # Parameter which.graph defines which type of dominance to plot
#' plot(da,which.graph='conditional')
#' plot(da,which.graph='complete')
#' # Parameter complete_flipped_axis allows to flip axis on complete plot, to better visualization
#' plot(da,which.graph='complete', complete_flipped_axis=TRUE)
#' plot(da,which.graph='complete', complete_flipped_axis=FALSE)


plot.dominanceAnalysis<-function(x, which.graph=c("general", "complete", "complete_no_facet", "conditional"),  fit.function=NULL, complete_flipped_axis=TRUE,...) {
  which.graph<-which.graph[1]

  if(is.null(fit.function)) {
    fit.function<-x$fit.functions[[1]]
  }
  # Check if x is a dominanceAnalysis
  checkDominanceAnalysis(x)
  valid_graphs=c("complete", "complete_no_facet", "conditional","general")
  if(!(which.graph %in% valid_graphs)) {
    stop("which.graph should be", paste0(valid_graphs, collapse=" , "))
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
    if(complete_flipped_axis) {
      gg<-ggplot2::ggplot(x.df.m, ggplot2::aes_string(y=".names", x="value", color="variable", group="variable", shape = switch(which.graph, complete=NULL, complete_no_facet=".level")))
      free_scale<-"free_y"
    } else {
      gg<-ggplot2::ggplot(x.df.m, ggplot2::aes_string(x=".names", y="value", color="variable", group="variable", shape = switch(which.graph, complete=NULL, complete_no_facet=".level")))
      free_scale<-"free_x"
    }

    gg<-gg+ggplot2::geom_point(size=2) +
      ggplot2::guides(shape="none") +
      ggplot2::xlab("Submodels") +
      ggplot2::ylab(fit.function) +
      ggplot2::ggtitle("Complete dominance")

    if(which.graph=='complete') {
      gg<-gg + ggplot2::facet_wrap(~.level, scales=free_scale)
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
      ggplot2::guides(shape="none") +
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
