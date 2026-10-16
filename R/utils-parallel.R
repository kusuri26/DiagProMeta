## =====================================================================
## Internal: lapply() over X, in parallel on a PSOCK cluster when ncores > 1
## =====================================================================
##
## Used by hattori.tsroc() and tsrocsa.lrt() over the time points.
##
## FUN is a closure defined inside the calling package function. parLapply()
## sends FUN to the workers together with its enclosing environment (the
## caller's frame with its data and settings), whose parent is the package
## namespace. Each worker then loads the installed package automatically,
## so the internal helpers (convert.dt.tsroc, meta.sroc.mle, ...) are found
## without clusterExport().
##
## CRAN policy: examples and tests must not use more than 2 cores.

#' @noRd
.lapply_parallel <- function(X, FUN, ncores = 1L) {

  ncores <- suppressWarnings(as.integer(ncores))
  if (length(ncores) != 1L || is.na(ncores) || ncores < 1L) {
    stop("'parallel.ncores' must be a positive integer.", call. = FALSE)
  }

  ## no more workers than tasks
  ncores <- min(ncores, length(X))

  if (ncores == 1L) return(lapply(X, FUN))

  cl <- parallel::makeCluster(ncores, type = "PSOCK")
  on.exit(parallel::stopCluster(cl), add = TRUE)

  parallel::parLapply(cl, X = X, fun = FUN)
}
