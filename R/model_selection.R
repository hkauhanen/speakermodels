model_selection <- function(df,
                            modelset = c("CRH", "VRH", "BRH", "qCRH", "qVRH"),
                            digits = 2) {
  df <- df[df$model %in% modelset, ]

  df$AIC <- 2*df$K - 2*df$logL
  df$Delta <- NA
  df$w <- NA

  for (i in 1:nrow(df)) {
    dfhere <- df[df$ID == df[i,]$ID & df$noise == df[i,]$noise, ]
    df[i,]$Delta <- df[i,]$AIC - min(dfhere$AIC)
  }

  for (i in 1:nrow(df)) {
    dfhere <- df[df$ID == df[i,]$ID & df$noise == df[i,]$noise, ]
    df[i,]$w <- exp(-df[i,]$Delta/2)/sum(exp(-dfhere$Delta/2))
  }

  df$Delta_rounded <- round(df$Delta, digits)
  df$w_rounded <- round(df$w, digits)

  df
}
