
#' @title Real meta-analysis of diagnostic studies: IVD data with number of subjects
#'
#' @description {``To identify the most accurate methods for diagnosis of IVD-related bloodstream infection.''}
#'
#' @format A data frame with 33 rows (studies) and 8 variables:
#' \describe{
#'   \item{study}{study ID}
#'   \item{TP}{True positive}
#'   \item{FN}{False negative}
#'   \item{FP}{False positive}
#'   \item{TN}{True negative}
#'   \item{cutoff.grp}{Cutoff value by group}
#'   \item{type}{Diagnostic type}
#'   \item{cutoff}{Cutoff information}
#' }
#' @source Safdar N, Fine JP, Maki DG (2005).
#' Meta-analysis: methods for diagnosing intravascular device-related bloodstream infection.
#' \emph{Annals of Internal Medicine}, 142(6), 451--466.
#' \doi{10.7326/0003-4819-142-6-200503150-00011}

"IVD"



#' @title Real meta-analysis of diagnostic studies: CD64 data
#'
#' @description {``To comprehensively and quantitatively summarize the accuracy of neutrophil CD64 in the early diagnosis of bacterial infection.''}
#'
#' @format A data frame with 27 rows (studies) and 11 variables:
#' \describe{
#'   \item{study}{study ID}
#'   \item{Author}{authors of studies}
#'   \item{TP}{True positive}
#'   \item{FN}{False negative}
#'   \item{FP}{False positive}
#'   \item{TN}{True negative}
#'   \item{cutoff}{Cutoff values}
#'   \item{unit}{Unit of cutoff}
#'   \item{unit.grp}{Unit group}
#'   \item{cutoff.grp}{Cutoff group}
#'   \item{subgroup}{Subgroup}
#' }
#'@source \url{https://pubmed.ncbi.nlm.nih.gov/22940278/}

"CD64"



#' @title Logit-transformed IVD data
#'
#' @description The data \code{\link{IVD}} after the continuity correction
#' (0.5 is added to all the cells of the studies with at least one zero cell)
#' and the logit transformation.
#'
#' @format A data frame with 33 rows (studies) and 6 variables:
#' \describe{
#'   \item{sens}{Sensitivity after the continuity correction}
#'   \item{spec}{Specificity after the continuity correction}
#'   \item{y1}{Logit-transformed sensitivity}
#'   \item{y2}{Logit-transformed specificity}
#'   \item{v1}{Variance of \code{y1}: \eqn{1/TP + 1/FN}}
#'   \item{v2}{Variance of \code{y2}: \eqn{1/TN + 1/FP}}
#' }
#' @source Created from \code{\link{IVD}}.

"IVD_2"



#' @title Logit-transformed CD64 data
#'
#' @description The data \code{\link{CD64}} after the continuity correction
#' (0.5 is added to all the cells of the studies with at least one zero cell)
#' and the logit transformation.
#'
#' @format A data frame with 27 rows (studies) and 6 variables:
#' \describe{
#'   \item{sens}{Sensitivity after the continuity correction}
#'   \item{spec}{Specificity after the continuity correction}
#'   \item{y1}{Logit-transformed sensitivity}
#'   \item{y2}{Logit-transformed specificity}
#'   \item{v1}{Variance of \code{y1}: \eqn{1/TP + 1/FN}}
#'   \item{v2}{Variance of \code{y2}: \eqn{1/TN + 1/FP}}
#' }
#' @source Created from \code{\link{CD64}}.

"CD64_2"
