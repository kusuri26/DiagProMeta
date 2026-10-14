#' @title SAUC and its confidence interval
#'
#' @description This function calculates the area under the SROC curve (SAUC) of the bivariate random-effects model,
#' and its confidence interval when the variance-covariance matrix of the estimates is given.
#'
#' @param mu1 The mean of the logit-transformed sensitivity.
#' @param mu2 The mean of the logit-transformed specificity.
#' @param tau1 The between-study standard deviation of the logit-transformed sensitivity.
#' @param tau2 The between-study standard deviation of the logit-transformed specificity.
#' @param rho The between-study correlation of the logit-transformed sensitivity and specificity.
#'
#' @param var.matrix The 5 x 5 variance-covariance matrix of the estimates of
#' \code{(mu1, mu2, tau1, tau2, rho)} in this order,
#' such as \code{var.ml} in the output of \code{\link{sroc}}.
#' If \code{var.matrix = NULL} (default), the confidence interval is not calculated.
#'
#' @param ci.level The confidence level of the confidence interval, within (0, 1).
#' It is required when \code{var.matrix} is given.
#'
#' @details
#' \describe{
#' \item{SROC curve}{The SROC curve is
#' \eqn{\mathrm{Se} = \mathrm{logit}^{-1}(\mu_1 - (\rho \tau_1 / \tau_2) (\mathrm{logit}(x) + \mu_2))}{Se = expit(mu1 - (rho * tau1 / tau2) * (logit(x) + mu2))},
#' where \eqn{x} is the false positive rate (1 - specificity).
#' SAUC is its integral over \eqn{x \in (0, 1)}{x in (0, 1)} by \code{\link[stats]{integrate}}.}
#' \item{Confidence interval}{The standard error of SAUC is calculated by the delta method.
#' The confidence interval is calculated on the logit scale and back-transformed,
#' so it is not symmetric around SAUC.}
#' }
#'
#' @return A named numeric vector of \code{sauc}, \code{sauc.lb}, and \code{sauc.ub}
#' (SAUC and the lower and upper bounds of its confidence interval).
#' \code{sauc.lb} and \code{sauc.ub} are \code{NA} if \code{var.matrix = NULL},
#' and \code{sauc} is \code{NA} if the integration failed.
#'
#' @examples
#' ## SAUC without confidence interval
#' sauc(mu1 = 1.5, mu2 = 2, tau1 = 0.8, tau2 = 0.9, rho = -0.3)
#'
#' ## SAUC with confidence interval from the fitted model
#' data(IVD)
#' fit <- sroc(TP = TP, FN = FN, FP = FP, TN = TN, data = IVD)
#' est <- fit$par
#' sauc(mu1 = est[1], mu2 = est[2], tau1 = est[3], tau2 = est[4], rho = est[5],
#'      var.matrix = fit$var.ml, ci.level = 0.95)
#'
#' @seealso
#' \code{\link{sroc}},
#' \code{\link{srocsa.t}}
#'
#' @export
sauc <- function(
	mu1, mu2, tau1, tau2, rho,
	var.matrix = NULL,
	ci.level){


		sroc <- function(x) plogis(mu1 - (tau1*tau2*rho/(tau2^2)) * (qlogis(x) + mu2))
		sauc.try <- try(integrate(sroc, 0, 1))

		if(!inherits(sauc.try, "try-error")) sauc <- sauc.try$value else sauc <- NA

		if(!is.null(var.matrix)){
		sauc.lb <-  plogis(qlogis(sauc) + qnorm((1-ci.level)/2, lower.tail = TRUE) *
																							suppressWarnings(
																								sqrt(.DID.sroc(mu1, mu2, tau1, tau2, rho, var.matrix))/(sauc*(1-sauc))) )

		sauc.ub <-  plogis(qlogis(sauc) + qnorm((1-ci.level)/2, lower.tail = FALSE)*
																							suppressWarnings(
																								sqrt(.DID.sroc(mu1, mu2, tau1, tau2, rho, var.matrix))/(sauc*(1-sauc))) )


		sauc.ci <- c(sauc, sauc.lb, sauc.ub)
		names(sauc.ci) <- c("sauc", "sauc.lb", "sauc.ub")

		} else {

			sauc.ci <- c(sauc, NA, NA)
			names(sauc.ci) <- c("sauc", "sauc.lb", "sauc.ub")
		}

sauc.ci
}




# ##
# ## DID for HSROC (not change yet)
# ##

# .DID.hsroc <- function(mu1, mu2, tau1, tau2, rho, var.matrix){

# 	Q1 <- function(x) {

# 		g <- plogis(mu1 + mu2*tau1/tau2 + tau1/tau2*qlogis(x))

# 		p.mu1 <- g*(1-g) * 1
# 	}

# 	Q2 <- function(x) {

# 		g <- plogis(mu1+mu2*tau1/tau2 + tau1/tau2*qlogis(x))

# 		p.mu2 <- g*(1-g) * (tau1/tau2)
# 	}

# 	Q3 <- function(x) {

# 		g <- plogis(mu1+mu2*tau1/tau2 + tau1/tau2*qlogis(x))
# 		p.tau1 <- g*(1-g) * (mu2 + qlogis(x))/tau2

# 	}

# 	Q4 <- function(x) {

# 		g <- plogis(mu1+mu2*tau1/tau2 + tau1/tau2*qlogis(x))
# 		p.tau2 <- g*(1-g) * (-1/tau2^2)*(mu2*tau1+tau1*qlogis(x))

# 	}



# 	fd <- c(integrate(Q1, 0, 1)$value,
# 									integrate(Q2, 0, 1)$value,
# 									integrate(Q3, 0, 1)$value,
# 									integrate(Q4, 0, 1)$value,
# 									0
# 	)

# 	(fd %*% var.matrix %*% fd)

# }


###########################
##
## Support function
##
###########################  


##
## DID for SROC
##

.DID.sroc <- function(mu1, mu2, tau1, tau2, rho, var.matrix){

	Q1 <- function(x) {

		g <- plogis(mu1 - (tau1*tau2*rho/(tau2^2)) * (qlogis(x) + mu2))
		g*(1-g)
	}

	Q2 <- function(x) {

		g <- plogis(mu1 - (tau1*tau2*rho/(tau2^2)) * (qlogis(x) + mu2))
		p.mu2 <- (-rho*tau1/tau2)*g*(1-g)
	}

	Q3 <- function(x) {

		g <- plogis(mu1 - (tau1*tau2*rho/(tau2^2)) * (qlogis(x) + mu2))
		p.tau1 <- (-rho/tau2*(qlogis(x)+mu2))*g*(1-g)

	}

	Q4 <- function(x) {

		g <- plogis(mu1 - (tau1*tau2*rho/(tau2^2)) * (qlogis(x) + mu2))
		p.tau2 <- rho*tau1/tau2^2*( qlogis(x)+mu2)*g*(1-g)

	}

	Q5 <- function(x) {

		g <- plogis(mu1 - (tau1*tau2*rho/(tau2^2)) * (qlogis(x) + mu2))
		p.rho  <- (-tau1)/tau2*(qlogis(x) + mu2)*g*(1-g)
	}

	fd <- c(integrate(Q1, 0, 1)$value,
									integrate(Q2, 0, 1)$value,
									integrate(Q3, 0, 1)$value,
									integrate(Q4, 0, 1)$value,
									integrate(Q5, 0, 1)$value
	)

	(fd %*% var.matrix %*% fd)

}



##
## FOR SROC CI
##

.QIQ.sroc <- function(x, mu1, mu2, tau1, tau2, rho, inv.I.fun.m) {

  sapply(1: length(x), function(i){

    Q <- c(1, -rho*tau1/tau2, -rho/tau2*(qlogis(x[i])+mu2), rho*tau1/tau2^2*(qlogis(x[i])+mu2), -tau1/tau2*(qlogis(x[i])+mu2))

    (Q %*% inv.I.fun.m %*% Q)

  })

}



