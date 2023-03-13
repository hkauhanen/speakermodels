sweep <- function(data,
                  IDs = c("K1", "K2", "PT"),
                  noises = exp(seq(from=log(0.001), to=log(1.0), length.out=30)),
                  mc.cores = round(parallel::detectCores()/2)) {
  # function to do one instance
  do_one_dataset <- function(ID, noise, datalist) {
    # select dataset
    df <- datalist[[ID]]

    # add noise
    if (noise > 0) {
      howmany <- round(noise*nrow(df))
      whichones <- sample(1:nrow(df), size=howmany, replace=FALSE)
      df[whichones, ]$response <- sample(c(0,1), size=howmany, replace=TRUE)
    }

    # fit models
    mod <- cre2::fit_dm_all(df, reps=10, mc.cores=1)
    mods <- mod$summary
    mods$ID <- ID
    mods$noise <- noise

    mods
  }

  data <- data[names(data) %in% IDs]

  # parameter grid
  pargrid <- expand.grid(ID=names(data), noise=noises)

  # sweep
  out <- do.call(rbind, parallel::mcmapply(pargrid$ID, pargrid$noise, FUN=do_one_dataset, MoreArgs=list(data=data), mc.cores=mc.cores, SIMPLIFY=FALSE))

  # return
  out
}
