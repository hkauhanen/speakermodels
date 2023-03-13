main_analysis <- function(data,
                          reps = 10) {
  IDs <- names(data)

  summ <- NULL
  coefs <- vector("list", length(IDs))
  names(coefs) <- IDs

  for (ID in IDs) {
    fit <- cre2::fit_dm_all(data[[ID]], reps=reps)
    fitsum <- fit$summary
    fitsum$ID <- ID
    fitsum$noise <- 0
    summ <- rbind(summ, fitsum)
    coefs[[ID]] <- fit$coef
  }

  list(summary=summ, coef=coefs)
}

