#' @title
#' Print method for 'sroc' objects
#'
#' @description This function prints the main results of \code{\link{reitsma.sroc}}
#' (SROC curve) and \code{\link{hattori.tsroc}} (time-dependent SROC curve; one row for each time point),
#' without considering publication bias:
#' the number of studies, convergence of the optimizer, the SAUC, the summary sensitivity and specificity
#' with their confidence intervals, and the estimates of \eqn{(\mu_1, \mu_2, \tau_1, \tau_2, \rho)}{(mu1, mu2, tau1, tau2, rho)}.
#'
#' @param x
#' A fitted object returned by the function \code{\link{reitsma.sroc}} or \code{\link{hattori.tsroc}}.
#'
#' @param digits
#' The number of decimal places of the results.
#'
#' @param ... Other arguments in function \code{\link{print.default}}.
#'
#' @details
#' \describe{
#' \item{Conv}{\code{"yes"} indicates that \code{\link[stats]{nlminb}} converged (\code{convergence = 0}).}
#' \item{SAUC}{The confidence interval is \code{sauc.ci} of the fitted object
#' (calculated on the logit scale; see \code{\link{sauc}}).}
#' \item{Sens, Spec}{\eqn{\mathrm{plogis}(\mu_1)}{plogis(mu1)} and \eqn{\mathrm{plogis}(\mu_2)}{plogis(mu2)};
#' the confidence intervals are the Wald intervals of \eqn{\mu_1}{mu1} and \eqn{\mu_2}{mu2}, back-transformed.}
#' \item{tau1, tau2, rho}{Between-study standard deviations (not variances) and correlation
#' of the logit-transformed sensitivity and specificity.}
#' }
#' See \code{\link{summary.sroc}} for the standard errors and confidence intervals of all the parameters.
#'
#' @examples
#' ## load data
#' data(IVD)
#'
#' fit <- reitsma.sroc(TP = TP, FN = FN, FP = FP, TN = TN, data = IVD)
#' fit
#' print(fit, digits = 4)
#'
#' @seealso
#' \code{\link{reitsma.sroc}},
#' \code{\link{hattori.tsroc}},
#' \code{\link{summary.sroc}},
#' \code{\link{plot.sroc}}
#'
#' @return \code{x}, invisibly. Called for the side effect of printing.
#'
#' @method print sroc
#' @export
print.sroc <- function(x, digits = 3, ...) {

  fits  <- .sroc_fits_safe(x)
  is.td <- isTRUE(attr(fits, "td"))
  lev   <- .sroc_ci_level(x)
  st    <- lapply(seq_along(fits), function(i) .sroc_fit_stats(fits[[i]], lev, n.study = .sroc_n_study(x, fits, i)))

  .sroc_print_header(is.td)

  ## main results ----
  pc <- paste0(round(100 * lev), "% CI")
  f  <- function(v) .fmt(v, digits)
  ci <- function(v) if (anyNA(v[2:3])) "-" else paste0("[", f(v[2]), ", ", f(v[3]), "]")

  main <- t(vapply(st, function(s) {
    if (!s$ok) return(c(.na_chr(s$K), "failed", rep("-", 6)))
    c(.na_chr(s$K), if (s$conv) "yes" else "no",
      f(s$sauc[1]), ci(s$sauc), f(s$sens[1]), ci(s$sens), f(s$spec[1]), ci(s$spec))
  }, character(8)))
  colnames(main) <- c("K", "Conv", "SAUC", pc, "Sens", pc, "Spec", pc)
  rownames(main) <- if (is.td) names(fits) else ""
  print(main, quote = FALSE, right = TRUE, ...)

  ## parameters ----
  cat("\nEstimates (tau1, tau2: between-study SDs; rho: correlation):\n")
  par <- t(vapply(st, function(s) if (s$ok) f(s$est) else rep("-", 5), character(5)))
  colnames(par) <- c("mu1", "mu2", "tau1", "tau2", "rho")
  rownames(par) <- if (is.td) names(fits) else ""
  print(par, quote = FALSE, right = TRUE, ...)

  if (any(vapply(st, function(s) s$ok && !s$conv, logical(1)))) {
    cat("\nWarning: nlminb did not converge for some fits; see summary() for the messages.\n")
  }

  invisible(x)
}


## =====================================================================
## Internal helpers shared by print.sroc, summary.sroc, print.summary.sroc
## (.sroc_fits and .sroc_extract are in plot.sroc.R)
## =====================================================================

.fmt <- function(v, digits) {
  out <- formatC(as.numeric(v), format = "f", digits = digits)
  out[!is.finite(as.numeric(v))] <- "-"
  out
}

.na_chr <- function(v) if (is.null(v) || is.na(v)) "-" else as.character(v)

## like .sroc_fits(), but an estimation failure of reitsma.sroc() (a character string
## from try()) is turned into one failed fit instead of an error
.sroc_fits_safe <- function(x) {
  if (is.character(x) || inherits(x, "try-error")) {
    fits <- list(SROC = structure(as.character(x), class = "try-error"))
    attr(fits, "td") <- FALSE
    return(fits)
  }
  .sroc_fits(x)
}

.sroc_ci_level <- function(x) {
  lev <- attr(x, "ci.level")
  if (is.null(lev) || !is.numeric(lev) || lev <= 0 || lev >= 1) 0.95 else lev
}

.sroc_n_study <- function(x, fits, i) {
  d <- if (is.list(fits[[i]])) fits[[i]]$data else NULL
  if (!is.null(d)) return(nrow(d))
  ns <- attr(x, "n.study")
  if (!is.null(ns) && length(ns) >= i) ns[i] else NA
}

.sroc_print_header <- function(is.td) {
  if (is.td) {
    cat("Time-dependent SROC curve: bivariate random-effects model at each time point\n")
    cat("(Hattori and Zhou, 2016); publication bias is not considered\n\n")
  } else {
    cat("SROC curve: bivariate random-effects model (Reitsma et al., 2005)\n")
    cat("Publication bias is not considered\n\n")
  }
}

## all the numbers needed by the print / summary methods for one fit
.sroc_fit_stats <- function(fit, ci.level = 0.95, n.study = NA) {

  if (!.sroc_fit_ok(fit)) {
    msg <- if (inherits(fit, "try-error")) trimws(as.character(fit)) else "estimation failed"
    return(list(ok = FALSE, K = n.study, message = msg))
  }

  z  <- qnorm(1 - (1 - ci.level) / 2)
  ex <- .sroc_extract(fit)
  est <- ex$est
  se  <- if (is.null(ex$V)) rep(NA_real_, 5) else sqrt(pmax(diag(ex$V), 0))
  names(se) <- names(est)

  ## Wald CIs: mu on the original scale, tau on the log scale, rho on Fisher's z scale
  lb <- ub <- rep(NA_real_, 5); names(lb) <- names(ub) <- names(est)
  lb[1:2] <- est[1:2] - z * se[1:2]
  ub[1:2] <- est[1:2] + z * se[1:2]
  lb[3:4] <- exp(log(est[3:4]) - z * se[3:4] / est[3:4])
  ub[3:4] <- exp(log(est[3:4]) + z * se[3:4] / est[3:4])
  lb[5]   <- tanh(atanh(est[5]) - z * se[5] / (1 - est[5]^2))
  ub[5]   <- tanh(atanh(est[5]) + z * se[5] / (1 - est[5]^2))

  coef <- cbind(Estimate = est, SE = se, lower = lb, upper = ub)

  ## SAUC (est, lower, upper) from sauc.ci, or par.all as fallback
  sv <- suppressWarnings(as.numeric(unlist(fit$sauc.ci)))
  sauc <- if (length(sv) >= 3) sv[1:3] else c(if (length(sv)) sv[1] else NA_real_, NA, NA)
  if (!is.finite(sauc[1]) && !is.null(fit$par.all) && "sauc" %in% names(fit$par.all)) {
    sauc[1] <- fit$par.all[["sauc"]]
  }

  list(
    ok      = TRUE,
    K       = n.study,
    conv    = isTRUE(fit$convergence == 0),
    message = if (is.null(fit$message)) "" else fit$message,
    iter    = fit$iterations,
    logLik  = if (is.numeric(fit$objective)) -fit$objective else NA_real_,
    est     = est,
    coef    = coef,
    sauc    = sauc,
    sens    = plogis(c(est[1], lb[1], ub[1])),
    spec    = plogis(c(est[2], lb[2], ub[2])),
    par.all = fit$par.all
  )
}
