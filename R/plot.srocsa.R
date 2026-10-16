#' @title
#' Plot method for 'srocsa' objects
#'
#' @description
#' This function plots the SROC curves and the summary points for each marginal selection probability \eqn{p},
#' from the sensitivity analysis by \code{\link{srocsa.t}} or \code{\link{tsrocsa.lrt}}.
#' For \code{\link{srocsa.t}}, one plot is created.
#' For \code{\link{tsrocsa.lrt}}, one plot is created at each time point, with the title \code{time = xx};
#' in an interactive session the user is prompted ("Hit <Return> to see next plot")
#' before each new time point.
#' The same \eqn{p} has the same color and line type at all the time points.
#'
#' @param x
#' A fitted object returned by the function \code{\link{srocsa.t}} or \code{\link{tsrocsa.lrt}}.
#'
#' @param time
#' Time points to plot (only for the results from \code{\link{tsrocsa.lrt}}).
#' If \code{time = NULL} (default), all the time points are plotted.
#'
#' @param p
#' Values of the marginal selection probability \eqn{p} to plot.
#' If \code{p = NULL} (default), all the values are plotted.
#'
#' @param ask Logical; whether to wait for <Return> before each new time point.
#' Default \code{NULL} means \code{TRUE} when more than one plot is drawn on an interactive device.
#'
#' @param sroc.cols Colors of the SROC curves, one for each \eqn{p}.
#' Default uses grey colors (black for the first \eqn{p}).
#' @param sroc.lty Line types of the SROC curves, recycled over \eqn{p}.
#' @param sroc.lwd Line width of the SROC curves.
#'
#' @param add.spoint Whether to add the summary points on the SROC curves.
#' @param sp.pch Type of the summary points.
#' @param sp.cex Size of the summary points.
#'
#' @param plot.ci Whether to add the pointwise confidence bands of the SROC curves
#' (delta method using \code{var.ml}).
#' @param spoint.region Whether to add the confidence regions of the summary points.
#' @param ci.level Confidence level of the bands and regions. Default 0.95.
#' @param ci.lty,ci.lwd Line type and width of the bands and regions.
#'
#' @param add.study Whether to add the observed (published) studies
#' (\eqn{(1 - \mathrm{spec}_i, \mathrm{sens}_i)}{(1 - spec_i, sens_i)}, after continuity correction),
#' stored in the attribute \code{"data"} of \code{x}.
#' @param study.size Size of the study points: \code{"fixed"} (default) or \code{"precision"},
#' proportional to \eqn{1/\sqrt{v_1 + v_2}}{1/sqrt(v1 + v2)} relative to its mean.
#' @param study.pch,study.cex,study.col Symbol, (base) size, and color of the study points.
#'
#' @param add.sauc Whether to show the SAUC (and its CI) for each \eqn{p} in the legend.
#' @param legend.pos Position of the legend. See \code{\link[graphics]{legend}}.
#' \code{NULL} suppresses the legend.
#' @param legend.cex Size of the legend text.
#'
#' @param main Title of the plot.
#' If \code{main = NULL} (default), \code{time = xx} is used for the time-dependent results,
#' and no title for the results from \code{srocsa.t}.
#' @param xlab Label of x-axis.
#' @param ylab Label of y-axis.
#' @param n.grid Number of grid points to draw each curve.
#'
#' @param ... Other arguments in function \code{\link[graphics]{plot.default}}.
#'
#' @details
#' For \eqn{p < 1} in \code{\link{tsrocsa.lrt}}, the SROC curve is calculated from
#' \eqn{(\mu_1, \mu_2, \tau_1, \tau_2, \rho_1)}{(mu1, mu2, tau1, tau2, rho1)} of the trivariate model,
#' i.e., the parameters of the logit-transformed sensitivity and specificity.
#'
#' @importFrom grDevices gray.colors dev.interactive devAskNewPage
#' @importFrom graphics legend
#'
#' @examples
#' ## load data
#' data(IVD)
#'
#' fit1 <- srocsa.t(TP = TP, FN = FN, TN = TN, FP = FP, data = IVD, sa.p = c(1, 0.8, 0.6))
#' plot(fit1)
#'
#' ## set the colors and add the studies
#' plot(fit1, sroc.cols = c("black", "blue", "red"), add.study = TRUE)
#'
#' ## only p = 1 and p = 0.6, with confidence bands
#' plot(fit1, p = c(1, 0.6), plot.ci = TRUE, sroc.cols = c("black", "red"))
#'
#' \donttest{
#' ## time-dependent results (see ?tsrocsa.lrt for fit2)
#' ## plot(fit2)               # one plot per time point; press <Return> for the next
#' ## plot(fit2, time = 60)    # one time point
#' }
#'
#' @seealso
#' \code{\link{srocsa.t}},
#' \code{\link{tsrocsa.lrt}},
#' \code{\link{plot.sroc}}
#'
#' @return \code{x}, invisibly. Called for the side effect of plotting.
#'
#' @method plot srocsa
#' @export
plot.srocsa <- function(
  x,
  time = NULL,
  p = NULL,
  ask = NULL,
  sroc.cols = NULL,
  sroc.lty = 1,
  sroc.lwd = 2,
  add.spoint = TRUE,
  sp.pch = 19,
  sp.cex = 1.2,
  plot.ci = FALSE,
  spoint.region = FALSE,
  ci.level = 0.95,
  ci.lty = 2,
  ci.lwd = 1,
  add.study = FALSE,
  study.size = c("fixed", "precision"),
  study.pch = 1,
  study.cex = 1,
  study.col = "grey55",
  add.sauc = TRUE,
  legend.pos = "bottomright",
  legend.cex = 0.85,
  main = NULL,
  xlab = "FPR (1 - specificity)",
  ylab = "TPR (sensitivity)",
  n.grid = 300,
  ...
){

  study.size <- match.arg(study.size)
  panels <- .srocsa_panels(x)
  is.td  <- !is.null(panels[[1]]$time)

  ## select time points ----
  if (!is.null(time)) {
    if (!is.td) stop("`time` can be used only for the results from tsrocsa.lrt.", call. = FALSE)
    times <- vapply(panels, function(b) b$time, character(1))
    keep  <- times %in% as.character(time) |
      suppressWarnings(as.numeric(times)) %in% suppressWarnings(as.numeric(time))
    if (!any(keep)) {
      stop("No results at time = ", paste(time, collapse = ", "),
           ". Available: ", paste(times, collapse = ", "), call. = FALSE)
    }
    panels <- panels[keep]
  }

  ## all p values (to fix one color / line type for each p across panels) ----
  p.all <- sort(unique(unlist(lapply(panels, `[[`, "p"))), decreasing = TRUE)
  if (!is.null(p)) {
    p.sel <- p.all[vapply(p.all, function(v) any(abs(v - p) < 1e-8), logical(1))]
    if (length(p.sel) == 0) {
      stop("No results at p = ", paste(p, collapse = ", "),
           ". Available: ", paste(p.all, collapse = ", "), call. = FALSE)
    }
  } else {
    p.sel <- p.all
  }

  k    <- length(p.all)
  cols <- if (is.null(sroc.cols)) gray.colors(k, gamma = 1, start = 0, end = 0.6) else rep_len(sroc.cols, k)
  ltys <- rep_len(sroc.lty, k)
  ## when the user gives colors for the selected p only, match them to p.sel
  if (!is.null(sroc.cols) && !is.null(p) && length(sroc.cols) == length(p.sel)) {
    cols[match(p.sel, p.all)] <- sroc.cols
  }
  if (!is.null(p) && length(sroc.lty) == length(p.sel)) {
    ltys[match(p.sel, p.all)] <- sroc.lty
  }

  ## <Return> prompt between time points ----
  if (!is.null(main)) main <- rep_len(main, length(panels))
  if (is.null(ask)) ask <- length(panels) > 1 && dev.interactive()
  if (ask) {
    old.ask <- devAskNewPage(TRUE)
    on.exit(devAskNewPage(old.ask), add = TRUE)
  }

  for (i in seq_along(panels)) {

    b <- panels[[i]]

    ## curves to draw in this panel
    use <- which(vapply(b$p, function(v) any(abs(v - p.sel) < 1e-8), logical(1)))
    ok  <- vapply(b$fits[use], .sroc_fit_ok, logical(1))
    if (any(!ok)) {
      warning("Estimation failed for p = ", paste(b$p[use][!ok], collapse = ", "),
              if (!is.null(b$time)) paste0(" at time = ", b$time),
              "; these curves are skipped.", call. = FALSE)
    }
    use <- use[ok]

    main.i <- if (!is.null(main)) main[i] else if (!is.null(b$time)) paste0("time = ", b$time) else NULL
    .sroc_frame(xlab, ylab, main.i, ...)

    if (length(use) == 0) {
      warning("No SROC curve to plot", if (!is.null(b$time)) paste0(" at time = ", b$time),
              call. = FALSE)
      next
    }

    if (add.study) {
      .sroc_draw_studies(b$data, col = study.col, study.size = study.size,
                         study.pch = study.pch, study.cex = study.cex)
    }

    j.col <- match(round(b$p[use], 10), round(p.all, 10))
    for (m in seq_along(use)) {
      .sroc_draw(b$fits[[use[m]]], col = cols[j.col[m]],
                 lty = ltys[j.col[m]], lwd = sroc.lwd,
                 plot.ci = plot.ci, ci.lty = ci.lty, ci.lwd = ci.lwd,
                 add.spoint = add.spoint, spoint.region = spoint.region,
                 sp.pch = sp.pch, sp.cex = sp.cex,
                 ci.level = ci.level, n.grid = n.grid)
    }

    if (!is.null(legend.pos)) {
      lab <- paste0("p = ", b$p[use])
      if (add.sauc) {
        lab <- paste0(lab, ": ", vapply(b$fits[use], .sroc_sauc_label, character(1)))
      }
      legend(legend.pos, legend = lab,
             col = cols[j.col], lty = ltys[j.col], lwd = sroc.lwd,
             pch = if (add.spoint) sp.pch else NA,
             bty = "n", cex = legend.cex)
    }
  }

  invisible(x)
}


## =====================================================================
## Internal: split an 'srocsa' object into panels
## each panel: list(time = NULL or "36", p = numeric, fits = list, data = data.frame or NULL)
## =====================================================================
.srocsa_panels <- function(x) {

  type <- attr(x, "type")
  xx   <- unclass(x)

  ## structure check when the attribute "type" is missing
  if (is.null(type)) {
    elems <- if (is.null(names(xx))) xx else xx[names(xx) != "call"]
    nested <- length(elems) > 0 && all(vapply(elems, function(e)
      is.list(e) && !inherits(e, "try-error") && is.null(e$par), logical(1)))
    type <- if (nested) "tsrocsa.lrt" else "srocsa.t"
  }

  if (identical(type, "tsrocsa.lrt")) {

    times <- names(xx)
    if (is.null(times)) times <- as.character(seq_along(xx))

    lapply(seq_along(xx), function(i) {
      e  <- xx[[i]]
      pv <- suppressWarnings(as.numeric(names(e)))
      if (is.null(names(e)) || anyNA(pv)) pv <- rep(NA_real_, length(e))
      list(time = times[i], p = pv, fits = unname(as.list(e)), data = attr(e, "data"))
    })

  } else {

    nm   <- names(xx)
    fits <- if (is.null(nm)) xx else xx[nm != "call"]
    pv   <- attr(x, "sa.p")
    if (is.null(pv) || length(pv) != length(fits)) {
      warning("The values of p are not found; the curves are numbered instead.", call. = FALSE)
      pv <- seq_along(fits)
    }
    list(list(time = NULL, p = as.numeric(pv), fits = unname(fits), data = attr(x, "data")))
  }
}
