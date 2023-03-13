# Preprocess all data sets
#
prep_data <- function(infolder = "../data/csv",
                      outfolder = "../data/long") {
  files <- list.files(infolder, pattern=".csv$", full.names=TRUE)
  filenames <- list.files(infolder, pattern=".csv$", full.names=FALSE)

  for (i in 1:length(files)) {
    write.csv(preprocess(read.csv(files[i])), file=paste0(outfolder, "/", filenames[i]), row.names=FALSE)
  }
}


# Preprocess data set into a format understood by the fitting
# routine (response data as a long-format data frame).
#
# The `rel2abs`, `table2long` and `factor2numeric` functions
# are defined in rotatoR.R.
#
preprocess <- function(df) {
  # if CSV contains time period information ('start' and 'end' variables,
  # but no 'time' variable), we need to create a time variable
  if ("start" %in% names(df)) {
    df$time <- df$start + (df$end - df$start)/2
  }

  # if CSV contains relative frequency+totals information, we need to translate
  # this into raw frequencies
  if (sum(stringr::str_detect(names(df), pattern="_total$")) > 0) {
    df <- rel2abs(df)
  }

  # finally, move from table to long format
  df <- table2long(df, margin="time", variable.name="context", value.name="response")
  df$response <- factor2numeric(df$response)

  df
}

