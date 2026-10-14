#' Plot SROC curves from a matrix of parameters
#'
#' Internal function used in \code{plot.srocsa}.
#'
#' @param par.mat A matrix whose rows are \code{(mu1, mu2, tau1, tau2, rho)} (5 x k; one SROC curve for each column),
#' or a vector of \code{(mu1, mu2, tau1, tau2, rho)} (one SROC curve).
#' @param var.matrix The variance-covariance matrix of the estimates of \code{(mu1, mu2, tau1, tau2, rho)}.
#' Used only when \code{plot.ci = TRUE}.
#' @param sroc.cols A vector of colors of the SROC curves. Default uses grey colors.
#' @param sroc.lty Line type of the SROC curves.
#' @param sroc.lwd Line width of the SROC curves.
#' @param add.spoint Whether to add the summary points on the SROC curves.
#' @param sp.pch Type of the summary points.
#' @param sp.cex Size of the summary points.
#' @param plot.ci Whether to plot the confidence intervals of the SROC curves (requires \code{var.matrix}).
#' @param sroc.ci.col Color of the confidence intervals (currently not used; \code{sroc.cols} is used).
#' @param sroc.ci.lty Line type of the confidence intervals.
#' @param sroc.ci.lwd Line width of the confidence intervals.
#' @param ci.level The confidence level of the confidence intervals.
#' @param xlab Label of x-axis.
#' @param ylab Label of y-axis.
#' @param addon Whether to add the SROC curves onto an existing plot.
#' Default is \code{FALSE}, to start from a new plot.
#' @param ... Other arguments in function \code{\link[graphics]{plot.default}} or function \code{\link[graphics]{curve}}.
#'
#' @return No return value; called for the side effect of plotting.
#'
#' @importFrom grDevices gray.colors
#' @importFrom graphics curve points
#'
#' @exportS3Method NULL
#' @keywords internal
#' @noRd
plot.sroc <- function(
  # object,
  # sroc.type = c("sroc", "hsroc"),
  # mu1, mu2, tau1, tau2, rho,
  par.mat,
  var.matrix = NULL,
  sroc.cols = gray.colors(ncol(as.matrix(par.mat)), gamma = 1, start = 0, end = 0.5),
  sroc.lty = 1,
  sroc.lwd = 1,
  add.spoint = TRUE,
  sp.pch = 19,
  sp.cex = 1,
  plot.ci = FALSE,
  sroc.ci.col = "red",
  sroc.ci.lty = 2,
  sroc.ci.lwd = 1,
  ci.level = 0.95,
  xlab = "FPR",
  ylab = "TPR",
  addon = FALSE,
  ...
){

  par <- as.matrix(par.mat)

  if(nrow(par) < 5) stop("PLEASE CHECK THE INPUT MATRIX")

  # sroc.type <- match.arg(sroc.type)

  if (!addon) plot(NULL, xlim=c(0,1), ylim=c(0,1), xlab = xlab, ylab = ylab, ...)

  for (i in 1:ncol(par)) {

    u1  <- par[1,i]
    u2  <- par[2,i]
    t1  <- par[3,i]
    t2  <- par[4,i]
    r <- par[5, i] 

    f <- function(x) plogis(u1 - (t1*t2*r/(t2^2)) * (qlogis(x) + u2))
    curve(f, 0, 1,
          col = sroc.cols[i],
          add = TRUE,
          lty = sroc.lty,
          lwd = sroc.lwd,
          ...)
  }

  if (add.spoint) {

    sens <- plogis(par[1,])
    spec <- plogis(par[2,])
    points(1-spec, sens, col=sroc.cols, pch = sp.pch, cex = sp.cex)

    }

  if(plot.ci && !is.null(var.matrix)){

    for (i in 1:ncol(par)) {

    u1 <- par[1,]
    u2 <- par[2,]
    t1 <- par[3,]
    t2 <- par[4,]
    r  <- par[5,]


      f.lb <- function(x) plogis( u1 - (t1*t2*r/t2^2) * (qlogis(x) + u2) + qnorm((1-ci.level)/2, lower.tail = TRUE) * suppressWarnings(sqrt(.QIQ.sroc(x, mu1=u1, mu2=u2, tau1=t1, tau2=t2, rho=r, var.matrix[1:5,1:5]))))

      f.ub <- function(x) plogis( u1 - (t1*t2*r/t2^2) * (qlogis(x) + u2) + qnorm((1-ci.level)/2, lower.tail = FALSE) * suppressWarnings(sqrt(.QIQ.sroc(x, mu1=u1, mu2=u2, tau1=t1, tau2=t2, rho=r, var.matrix[1:5,1:5]))))

      curve(f.lb, add = TRUE, col = sroc.cols[i], lty = sroc.ci.lty, lwd = sroc.ci.lwd)

      curve(f.ub, add = TRUE, col = sroc.cols[i], lty = sroc.ci.lty, lwd = sroc.ci.lwd)
    }

      }


}

