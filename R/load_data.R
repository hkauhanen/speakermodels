load_data <- function(folder = "../data/long",
                      scale = TRUE) {
  dal <- list(K1=read.csv(paste0(folder, "/kroch_do_lim.csv")),
              K2=read.csv(paste0(folder, "/kroch_do.csv")),
              PT=read.csv(paste0(folder, "/pintzuk_taylor_sansOE1.csv")))

  if (scale) {
    dal <- lapply(dal, function(x) { x$time <- scale(x$time); x })
  }

  dal
}
