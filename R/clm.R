#' Fit censored linear models
#'
#' A specialized interface to [survival::survreg()], `clm()` fits linear models
#' in the presence of censored observations.
#'
#' @export
clm <- function(formula, data, ..., left) {
  if (missing(left)) {
    force(left) # Just signal an error for now
  }
  lhs <- formula[[2]]
  formula[[2]] <- call("Surv", lhs, call(">", lhs, substitute(left)), type = "left")
  # TODO: Work out how to not require survival to be loaded.
  fit <- eval.parent(substitute(survreg(formula, data, ..., dist = "gaussian")))
  structure(fit, class = c("censlm", class(fit)))
}

#' Extract model imputed values
#' @export
imputed <- function(object, ...) {
  UseMethod("imputed")
}

#' @export
imputed.censlm <- function(object, ...) {
  cnsr <- !as.logical(object$y[, "status"])
  value <- as.numeric(object$y[, "time"])

  # Fitted parameters for each censored subject
  i <- which(cnsr)
  n <- length(i)
  m <- fitted(object)[i]
  s <- object$scale

  # Inverse transform sample from censored region
  a <- 0
  b <- pnorm(value[i], m, s)
  u <- runif(n, a, b)
  y <- qnorm(u, m, s)

  replace(value, i, y)
}
