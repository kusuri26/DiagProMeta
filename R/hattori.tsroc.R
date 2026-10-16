#' @title Bivariate random-effects model (Hattori's model) estimating the time-dependent SROC curve without publication bias
#'
#' @description This function estimates the time-dependent SROC curve and SAUC
#' in meta-analysis of prognostic studies, without considering publication bias.
#' At each time point, the time-dependent sensitivity and specificity are reconstructed from the published
#' survival probabilities of the test-positive and test-negative groups,
#' and the bivariate random-effects model of the logit-transformed sensitivity and specificity
#' (with the within-study covariance) is fitted by the maximum likelihood method.
#'
#' @inheritParams tsrocsa.lrt
#'
#' @param data.os A data frame of the survival data, with one row for each study and each time point.
#' Within each study, the rows should be sorted in ascending order of time.
#' If \code{data.os = NULL} (default), \code{study.os}, \code{time.os}, \code{n1.os}, \code{n0.os},
#' \code{s1.os}, and \code{s0.os} are evaluated in the calling environment.
#' @param data.lnhr A data frame of lnHR, with one row for each study.
#' If \code{data.lnhr = NULL} (default), \code{study.lnhr}, \code{lnhr}, and \code{var.lnHR}
#' are evaluated in the calling environment.
#' @param data.mt A data frame of the median follow-up time, with one row for each study reporting it.
#' It is used to estimate the censoring distribution common to all the studies
#' (see details in \code{\link{tsrocsa.lrt}}).
#' If \code{data.mt = NULL} (default), \code{time.med}, \code{n1.med}, \code{n0.med},
#' \code{s1.med}, and \code{s0.med} are evaluated in the calling environment.
#'
#' @param parset A list of the settings for the estimation, which updates the default settings.
#' Bad initial values and bounds may cause non-convergence.
#' \itemize{
#'     \item \code{inital.values}: The initial values of \code{c(mu1, mu2, tau1, tau2, rho)}.
#'     If it is not a vector of length 5 (default), the estimates by \code{\link[mixmeta]{mixmeta}} are used.
#'     \item \code{mu.bound}: \eqn{\mu_1}{mu1} and \eqn{\mu_2}{mu2} are searched within
#'     \code{[-mu.bound, mu.bound]}. The default is 5.
#'     \item \code{tau.bound}: \eqn{\tau_1}{tau1} and \eqn{\tau_2}{tau2} are searched within
#'     \code{[eps, tau.bound]}. The default is 5.
#'     \item \code{eps}: The lower bound of \eqn{\tau_1}{tau1} and \eqn{\tau_2}{tau2}. The default is \code{1e-5}.
#'   }
#'
#' @details
#' The time-dependent sensitivity and specificity, and their within-study variances and covariance
#' are calculated in the same way as \code{\link{tsrocsa.lrt}}.
#' \code{study.lnhr}, \code{lnhr}, and \code{var.lnHR} are required as input,
#' but lnHR is not used in the estimation of this function.
#'
#' @return An object of class \code{"sroc"}:
#' a list with one element for each time point (named \code{"t = xx"}).
#' Each element is the same as the output of \code{\link{reitsma.sroc}}
#' (its \code{data} element also contains the within-study covariance \code{v12}),
#' or an object of class \code{"try-error"} if the estimation failed at that time point.
#' The attributes \code{"call"}, \code{"ci.level"}, and \code{"n.study"} (the number of studies
#' at each time point) are used by the methods.
#' The results can be shown by \code{\link{print.sroc}}, \code{\link{summary.sroc}}, and \code{\link{plot.sroc}}.
#'
#' @references
#' Hattori, S., & Zhou, X.-H. (2016).
#' Time-dependent summary receiver operating characteristics for meta-analysis of prognostic studies.
#' \emph{Statistics in Medicine}, 35(26), 4746–4763.
#' \doi{10.1002/sim.7029}
#'
#' @examples
#' ## load data
#' data(Ki67)
#' head(Ki67$OS)
#' head(Ki67$HR)
#' head(Ki67$MT)
#'
#' ## Define datasets of the HR
#' Ki67_OS <- Ki67$OS
#' Ki67_HR <- Ki67$HR
#' Ki67_MT <- Ki67$MT
#'
#' ## lnHR and its variance from HR and its 95 percent CI
#' Ki67_HR$lnHR   <- log(Ki67_HR$HR)
#' Ki67_HR$lnHR.var <- ((log(Ki67_HR$ci.up) - log(Ki67_HR$ci.low)) / (2 * qnorm(0.975)))^2
#'
#' fit <- hattori.tsroc(
#'   time.points = c(24, 36, 60),
#'   study.os = study,
#'   time.os = t, n1.os = n1, n0.os = n0,
#'   s1.os = s1, s0.os = s0,
#'   data.os = Ki67_OS,
#'   study.lnhr = study, lnhr = lnHR, var.lnHR = lnHR.var,
#'   data.lnhr = Ki67_HR,
#'   time.med = mct_mo, n1.med = n1, n0.med = n0,
#'   s1.med = s1_mct, s0.med = s0_mct,
#'   data.mt = Ki67_MT
#' )
#'
#' ## main results: one row for each time point
#' fit
#'
#' ## estimates with SEs and confidence intervals at each time point
#' print(fit)
#' summary(fit)
#'
#' ## plots
#' plot(fit, ask = FALSE)                       # all time points, one per page, no prompt
#' plot(fit, time = 36, add.study = TRUE)       # one time point with the studies
#' plot(fit, overlay = TRUE)                    # all time points in one panel
#'
#' \donttest{
#' ## interactive: press <Return> to move to the next time point
#' if (interactive()) plot(fit, add.study = TRUE, study.size = "precision")
#' }
#'
#' @seealso
#' \code{\link{print.sroc}},
#' \code{\link{summary.sroc}},
#' \code{\link{plot.sroc}},
#' \code{\link{reitsma.sroc}},
#' \code{\link{tsrocsa.lrt}}
#'
#' @export
hattori.tsroc <- function(
  time.points,
  study.os, time.os, n1.os, n0.os, s1.os, s0.os, data.os=NULL,
  study.lnhr, lnhr, var.lnHR, data.lnhr =NULL,
  time.med, n1.med, n0.med, s1.med, s0.med, data.mt=NULL,
  ci.level = 0.95,
  parallel.ncores = 1L,
  parset = list()
    ){

  this.call <- match.call()

  #### data.os
  inputs <- resolve_inputs(
      exprs = list(
        study.os  = substitute(study.os),
        time.os     = substitute(time.os),
        n1.os     = substitute(n1.os),
        n0.os     = substitute(n0.os),
        s1.os     = substitute(s1.os),
        s0.os     = substitute(s0.os)
      ),
      data = data.os,
      env = parent.frame(),
      numeric = FALSE,
      same.length = TRUE
    )

    data.os <- data.frame(
      study.os  = inputs$study.os,
      time.os = inputs$time.os,
      n1.os   = inputs$n1.os,
      n0.os   = inputs$n0.os,
      s1.os   = inputs$s1.os,
      s0.os   = inputs$s0.os
    )

#### data.lnhr

  inputs <- resolve_inputs(
      exprs = list(
        study.lnhr  = substitute(study.lnhr),
        lnhr = substitute(lnhr),
        var.lnHR = substitute(var.lnHR)
      ),
      data = data.lnhr,
      env = parent.frame(),
      numeric = FALSE,
      same.length = TRUE
    )

    data.lnhr <- data.frame(
      study.lnhr  = inputs$study.lnhr,
      lnhr = inputs$lnhr,
      var.lnHR = inputs$var.lnHR
    )

#### data.mtc
    inputs <- resolve_inputs(
      exprs = list(
        time.med = substitute(time.med),
        n1.med   = substitute(n1.med),
        n0.med   = substitute(n0.med),
        s1.med   = substitute(s1.med),
        s0.med   = substitute(s0.med)
      ),
      data = data.mt,
      env = parent.frame(),
      numeric = FALSE,
      same.length = TRUE
    )

    data.mt <- data.frame(
      time.med  = inputs$time.med,
      n1.med    = inputs$n1.med,
      n0.med    = inputs$n0.med,
      s1.med    = inputs$s1.med,
      s0.med    = inputs$s0.med
    )


        ## update parameter setting
  parset <- modifyList(default.parset.tsroc.pb(), parset)


  f <- function(tt){

  data.log <- convert.dt.tsroc(
    time.point = tt, study.os, time.os, n1.os, n0.os, s1.os, s0.os, data.os,
    study.lnhr, lnhr, var.lnHR, data.lnhr,
    time.med, n1.med, n0.med, s1.med, s0.med, data.mt)

  fit <- meta.sroc.mle(y1=data.log$u_sen, y2=data.log$u_spe, v1=data.log$v_sen, v2=data.log$v_spe, v12=data.log$v_senspe, ci.level = ci.level, parset=parset)

  ## keep the study-level data (logit sensitivity / specificity) for plotting
  if (!inherits(fit, "try-error")) {
    fit$data <- data.frame(y1 = data.log$u_sen, y2 = data.log$u_spe,
                           v1 = data.log$v_sen, v2 = data.log$v_spe,
                           v12 = data.log$v_senspe)
  }
  fit

  }

  if(parallel.ncores == 1L) {

     res <- lapply(time.points, function(tt) f(tt))

  } else {

    cl <- parallel::makeCluster(parallel.ncores, type = "PSOCK")
    on.exit(parallel::stopCluster(cl), add = TRUE)

    ## envir = environment(): the package functions are found through the namespace
    ## (not in .GlobalEnv when the package is installed)
    parallel::clusterExport(
      cl,
      varlist = c("f", "convert.dt.tsroc", "cens.eta", "meta.sroc.mle", "sroc.init",
                  "resolve_inputs", "default.parset.sroc"),
      envir = environment()
    )

    res <- parallel::parLapply(
      cl,
      X = time.points,
      fun = f
    )


  }

  class(res) <- "sroc"
  names(res) <- paste0("t = ", time.points)

  ## information for print/summary/plot methods
  attr(res, "type")     <- "sroc"
  attr(res, "call")     <- this.call
  attr(res, "ci.level") <- ci.level
  attr(res, "n.study")  <- vapply(time.points, function(tt) sum(data.os$time.os == tt, na.rm = TRUE), numeric(1))

  return(res)

}
