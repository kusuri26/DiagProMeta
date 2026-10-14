#' Default settings for the estimation
#'
#' \code{default.parset.sroc()} is used in \code{srocsa.t}, \code{sroc}, and \code{meta.sroc.mle}.
#' \code{default.parset.tsroc.pb()} is used in \code{tsroc} and \code{tsrocsa.lrt}.
#' The elements are updated by the argument \code{parset} of these functions
#' (see \code{\link[utils]{modifyList}}).
#'
#' @return A list of the following elements:
#' \describe{
#'   \item{inital.values}{Initial values. Length 5 for \code{(mu1, mu2, tau1, tau2, rho)} in
#'   \code{default.parset.sroc()}, and length 9 in \code{default.parset.tsroc.pb()}.
#'   They are used only in \code{meta.sroc.mle} when the length is 5;
#'   otherwise, the initial values are calculated by \code{sroc.init} (\code{mixmeta}).}
#'   \item{mu.bound}{Bounds of the means: \code{[-mu.bound, mu.bound]}.}
#'   \item{tau.bound}{Upper bound of the between-study standard deviations.}
#'   \item{beta.interval}{Lower and upper bounds of beta.}
#'   \item{alpha.bound}{Initial search interval of alpha: \code{[-alpha.bound, alpha.bound]}.}
#'   \item{eps}{Lower bound of the between-study standard deviations.}
#' }
#'
#' @keywords internal
#' @noRd
default.parset.sroc <- function() {
  list(
    inital.values = c(rep(0.1, 4), -0.1), ## initial values for mu1, mu2, tau1, tau2, rho
    mu.bound = 5,
    tau.bound = 5,
    beta.interval = c(0, 5),
    alpha.bound = 5,
    eps = 1e-5
  )
}


default.parset.tsroc.pb <- function() {
  list(
    inital.values = c(rep(0.1, 6), rep(-0.1, 3)), ## initial values for mu1, mu2, tau1, tau2, rho
    mu.bound = 5,
    tau.bound = 5,
    beta.interval = c(0, 5),
    alpha.bound = 5,
    eps = 1e-5
  )
}
