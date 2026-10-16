#' @title Print the summary of 'srocsa'
#'
#' @description Print the summary of 'srocsa':
#' the main results (see \code{\link{print.srocsa}}) and the estimates of all the parameters
#' (\code{par.all}) of the fitted models.
#' @param x
#' An object returned by the function \code{summary.srocsa}.
#' @param digits
#' The digits of the results
#' @param ...
#' Other arguments in function \code{\link{print.default}}
#' @method print summary.srocsa
#' @return Print the summary of a srocsa object
#' @export
#'
print.summary.srocsa <- function(x, digits = 3, ...) {

  if (!is.null(x$call)) {
    cat("Input:\n")
    print(x$call)
    cat("\n")
  }

  ## main results ----
  for (b in x$blocks) .srocsa.print.block(b, digits = digits)

  ## all the estimates (par.all) of the fitted models ----
  cat("==================================================\n")
  cat("All elements of the fitted models\n")
  cat("==================================================\n\n")

  ## wrap par.all at the width of the rules (50 characters)
  op <- options(width = 50)
  on.exit(options(op), add = TRUE)

  for (b in x$blocks) {
    for (i in seq_along(b$fits)) {

      cat("--------------------------------------------------\n")
      cat(if (!is.null(b$time)) paste0("time = ", b$time, ", "), "p = ", b$p[i], "\n", sep = "")
      cat("--------------------------------------------------\n")

      fit <- b$fits[[i]]

      if (!is.list(fit) || is.null(fit$par.all)) {
        cat("Estimation failed\n\n")
        next
      }

      print(round(fit$par.all, digits), ...)
      cat("\n")
    }
  }

  invisible(x)

}
