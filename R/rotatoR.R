require(stringr)


# Transform a relative frequencies data set into an
# absole frequencies data set.
#
rel2abs <- function(data) {
  # figure out variables ("contexts")
  contexts_values <- names(data)[stringr::str_detect(names(data), pattern="_")]
  contexts <- unique(stringr::str_replace(contexts_values, pattern="_[^_]*$", replacement=""))
  values <- vector("list", length(contexts))

  for (con in contexts) {
    val <- contexts_values[stringr::str_detect(contexts_values, pattern=con)]
    val <- stringr::str_replace(val, pattern="^[^_]*_", replacement="")
    values[[con]] <- val
  }

  # out dataframe
  out <- NULL

  # transform relative frequencies into absolute frequencies, rounding when necessary
  for (i in 1:nrow(data)) {
    for (con in contexts) {
      freqval <- values[[con]][values[[con]] != "total"]

      f <- data[i, paste0(con, "_", freqval)]
      total_here <- data[i, paste0(con, "_total")]
      N <- round(f*total_here)

      data[i, paste0(con, "_", freqval)] <- N
      data[i, paste0(con, "_total")] <- total_here - N
    }
  }

  # rename columns
  names(data) <- stringr::str_replace(names(data), pattern="_total", replacement="_0")

  # return
  data
}


# From "contingency table" format (common in research papers) to
# long format.
#
table2long <- function(data,
                       margin,
                       margin.name = NA,
                       variable.name = NA,
                       value.name = NA) {
  # figure out variables ("contexts") and their possible values
  contexts_values <- names(data)[stringr::str_detect(names(data), pattern="_")]
  contexts <- unique(stringr::str_replace(contexts_values, pattern="_[^_]*$", replacement=""))
  values <- vector("list", length(contexts))

  for (con in contexts) {
    val <- contexts_values[stringr::str_detect(contexts_values, pattern=con)]
    val <- stringr::str_replace(val, pattern="^[^_]*_", replacement="")
    values[[con]] <- val
  }

  # non-context column and its values
  nonconvalues <- unique(data[[margin]])

  # out dataframe
  out <- NULL

  # fill that dataframe
  for (ncval in nonconvalues) {
    for (con in contexts) {
      for (val in values[[con]]) {
        N <- data[data[[margin]]==ncval, paste0(con, "_", val)]
        if (N > 0) {
          for (i in 1:N) {
            df <- data.frame(nonconvariable=ncval, context=con, response=val)
            out <- rbind(out, df)
          }
        }
      }
    }
  }

  # column names
  names(out) <- c(margin, "variable", "value")
  if (!is.na(margin.name)) {
    names(out)[1] <- margin.name
  }
  if (!is.na(variable.name)) {
    names(out)[2] <- variable.name
  }
  if (!is.na(value.name)) {
    names(out)[3] <- value.name
  }

  # return
  out
}


# Turn a factor into a numeric.
#
factor2numeric <- function(x) {
  if (is.factor(x)) {
    return(as.numeric(levels(x))[x])
  } else {
    return(x)
  }
}
