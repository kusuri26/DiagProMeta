#' @title Print the summary of 'sroc' objects
#'
#' @description Print the summary of the results of \code{\link{reitsma.sroc}} or
#' \code{\link{hattori.tsroc}}; see \code{\link{summary.sroc}}.
#' For \code{\link{hattori.tsroc}}, the results are printed for each time point.
#'
#' @param x
#' An object returned by the function \code{\link{summary.sroc}}.
#' @param digits
#' The number of decimal places of the results.
#' @param ...
#' Other arguments in function \code{\link{print.default}}.
#'
#' @return \code{x}, invisibly. Called for the side effect of printing.
#'
#' @seealso
#' \code{\link{summary.sroc}}
#'
#' @method print summary.sroc
#' @export
print.summary.sroc <- function(x, digits = 3, ...) {

  rule <- function(ch = "=") cat(strrep(ch, 60), "\n", sep = "")
  pc   <- paste0(round(100 * x$ci.level), "% CI")

  .sroc_print_header(x$time.dependent)

  if (!is.null(x$call)) {
    cat("Call:\n")
    print(x$call)
    cat("\n")
  }

  for (i in seq_along(x$fits)) {

    s <- x$fits[[i]]

    rule("=")
    if (x$time.dependent) cat(names(x$fits)[i], "\n", sep = "") else cat("Results\n")
    rule("=")

    if (!s$ok) {
      cat("Estimation failed", if (nzchar(s$message)) paste0(": ", s$message), "\n\n", sep = "")
      next
    }

    cat("Number of studies: ", .na_chr(s$K), "\n", sep = "")
    cat("Convergence:       ", if (s$conv) "yes" else "NO", " (", s$message, ")\n", sep = "")
    cat("Log-likelihood:    ", .fmt(s$logLik, digits), "\n\n", sep = "")

    ## parameters
    cat("Parameters (tau1, tau2: between-study SDs; rho: correlation)\n")
    rule("-")
    cf <- s$coef
    tab <- cbind(
      Estimate = .fmt(cf[, "Estimate"], digits),
      SE       = .fmt(cf[, "SE"], digits),
      CI       = ifelse(is.finite(cf[, "lower"]) & is.finite(cf[, "upper"]),
                        paste0("[", .fmt(cf[, "lower"], digits), ", ", .fmt(cf[, "upper"], digits), "]"),
                        "-")
    )
    colnames(tab)[3] <- pc
    rownames(tab) <- rownames(cf)
    print(tab, quote = FALSE, right = TRUE, ...)
    if (all(!is.finite(cf[, "SE"]))) cat("(SEs are not available: var.ml is missing or not finite)\n")
    cat("\n")

    ## summary measures
    cat("Summary measures\n")
    rule("-")
    sm <- rbind(Sensitivity = s$sens, Specificity = s$spec, SAUC = s$sauc)
    tab2 <- cbind(
      Estimate = .fmt(sm[, 1], digits),
      CI = ifelse(is.finite(sm[, 2]) & is.finite(sm[, 3]),
                  paste0("[", .fmt(sm[, 2], digits), ", ", .fmt(sm[, 3], digits), "]"), "-")
    )
    colnames(tab2)[2] <- pc
    print(tab2, quote = FALSE, right = TRUE, ...)
    cat("\n")

    ## all estimates
    if (!is.null(s$par.all)) {
      cat("All estimates (par.all)\n")
      rule("-")
      print(round(s$par.all, digits), ...)
      cat("\n")
    }
  }

  invisible(x)
}
