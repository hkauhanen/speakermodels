fit_glm <- function(results,
                    data) {
  results <- results[results$model %in% c("CRH", "VRH", "qCRH", "qVRH"), ]
  results$logL_glm <- NA
  
  for (i in 1:nrow(results)) {
    df <- data[[results[i,]$ID]]
    
    if (results[i,]$model == "CRH") {
      fit <- glm(response~time+context, df, family=binomial)
    } else if (results[i,]$model == "VRH") {
      fit <- glm(response~time*context, df, family=binomial)
    } else if (results[i,]$model == "qCRH") {
      fit <- glm(response~time+I(time^2)+context, df, family=binomial)
    } else {
      fit <- glm(response~time*context+I(time^2)*context, df, family=binomial)
    }

    results[i,]$logL_glm <- as.numeric(logLik(fit))
  }

  results
}
