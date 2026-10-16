
#' @title Meta-analysis of diagnostic studies: IVD data
#'
#' @description
#' A dataset from a meta-analysis of diagnostic studies evaluating methods
#' for diagnosing intravascular device-related bloodstream infection (IVD-BSI).
#' The dataset contains study-level 2 x 2 diagnostic accuracy data together
#' with information on diagnostic type and cutoff values.
#'
#' @format A data frame with 33 rows (studies) and 8 variables:
#' \describe{
#'   \item{study}{Study identifier.}
#'   \item{TP}{Number of true positive cases.}
#'   \item{FN}{Number of false negative cases.}
#'   \item{FP}{Number of false positive cases.}
#'   \item{TN}{Number of true negative cases.}
#'   \item{cutoff.grp}{Cutoff-value group used in the study.}
#'   \item{type}{Type of diagnostic method or test.}
#'   \item{cutoff}{Diagnostic cutoff value or cutoff information.}
#' }
#'
#' @source
#' Safdar N, Fine JP, Maki DG (2005).
#' Meta-analysis: methods for diagnosing intravascular device-related
#' bloodstream infection.
#' \emph{Annals of Internal Medicine}, 142(6), 451--466.
#' \doi{10.7326/0003-4819-142-6-200503150-00011}
#'
#'
#' @examples
#' data(IVD)
"IVD"


#' @title Meta-analysis of diagnostic studies: CD64 data
#'
#' @description
#' A dataset from a meta-analysis of diagnostic studies evaluating neutrophil
#' CD64 expression for the early diagnosis of bacterial infection.
#' The dataset contains study-level 2 x 2 diagnostic accuracy data together
#' with information on cutoff values, measurement units, and subgroups.
#'
#' @format A data frame with 27 rows (studies) and 11 variables:
#' \describe{
#'   \item{study}{Study identifier.}
#'   \item{Author}{Author or authors of the study.}
#'   \item{TP}{Number of true positive cases.}
#'   \item{FN}{Number of false negative cases.}
#'   \item{FP}{Number of false positive cases.}
#'   \item{TN}{Number of true negative cases.}
#'   \item{cutoff}{Diagnostic cutoff value used in the study.}
#'   \item{unit}{Measurement unit of the cutoff value.}
#'   \item{unit.grp}{Measurement-unit group used in the study.}
#'   \item{cutoff.grp}{Cutoff-value group used in the study.}
#'   \item{subgroup}{Subgroup of the study used for analysis.}
#' }
#'
#' @source
#' Li S, Huang X, Chen Z, Zhong H, Peng Q, Deng Y, Qin X, Zhao J (2013).
#' Neutrophil CD64 expression as a biomarker in the early diagnosis of
#' bacterial infection: A meta-analysis.
#' \emph{International Journal of Infectious Diseases}, 17(1), e12--e23.
#' \doi{10.1016/j.ijid.2012.07.017}
#'
#' @examples
#' data(CD64)
"CD64"




#' @title Meta-analysis of prognostic studies: Ki-67 data
#'
#' @description
#' A dataset from a meta-analysis of prognostic studies evaluating the
#' prognostic value of Ki-67 expression in early breast cancer.
#' The dataset contains study-level overall survival, hazard-ratio, and
#' median survival-time data.
#'
#' @format A list of 3 datasets:
#' \describe{
#'   \item{OS}{Dataset containing overall survival data. It includes
#'   \code{author} (study author), \code{study} (study identifier),
#'   \code{t} (follow-up time in month),
#'   \code{n1} and \code{n0} (sample sizes in the two comparison groups), and
#'   \code{s1} and \code{s0} (survival probabilities in the two groups).}
#'
#'   \item{HR}{Dataset containing hazard-ratio data. It includes
#'   \code{author} (study author), \code{study} (study identifier),
#'   \code{HR} (hazard ratio), and \code{ci.low} and \code{ci.up}
#'   (lower and upper confidence limits of the hazard ratio).}
#'
#'   \item{mct}{Dataset containing median follow-up time data. It includes
#'   \code{author} (study author), \code{study} (study identifier),
#'   \code{n1} and \code{n0} (sample sizes in the two comparison groups),
#'   \code{mct_mo} (median follow-up time in months),
#'   \code{s1_mct} and \code{s0_mct} (survival probabilities
#'   at median follow-up time in the two comparison groups).}
#' }
#'
#' @source
#' de Azambuja E, Cardoso F, de Castro G, Colozza M, Mano MS, Durbecq V,
#' Sotiriou C, Larsimont D, Piccart-Gebhart MJ, Paesmans M (2007).
#' Ki-67 as prognostic marker in early breast cancer: a meta-analysis of
#' published studies involving 12 155 patients.
#' \emph{British Journal of Cancer}, 96(10), 1504--1513.
#' \doi{10.1038/sj.bjc.6603756}
#'
#' @examples
#' data(Ki67)
#'
#' # Overall survival data
#' head(Ki67$OD)
#'
#' # Hazard-ratio data
#' head(Ki67$HR)
#'
#' # Median follow-up time data
#' head(Ki67$MT)
"Ki67"

