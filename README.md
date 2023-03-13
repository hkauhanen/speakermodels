# speakermodels

This repository contains R code required to replicate the analyses presented in the following paper:

> Kauhanen, Henri (in prep) Grammar competition, speaker models and rates of change: A critical reappraisal of the Constant Rate Hypothesis. Ms., University of Konstanz.


## To replicate the analyses

### Main analysis

All of the following is to be run from an R session within the `R/` directory. The main analysis takes a while due to the need to carry out the optimization from several independent initial parameter combinations. The code parallelizes automatically when run on a Linux/Mac system, but even then, the runtime was on the order of 2.5 minutes (using z-scored time covariate) or 13.5 minutes (raw time covariate) when executed on an AMD Ryzen 3950X processor with all cores working in parallel at 4.1 GHz. (Further parallelization and more efficient use of R's vectorization capability is probably possible, but wasn't explored so far.)

Tested on R version 4.0.4. Exact replication of the numbers reported in the paper is in general not possible (or easy), due to the parallelized nature of the code (each optimization run depends on random number generation, but the order in which different combinations of model and dataset hit the processing nodes is not controlled for; therefore, slight differences in the estimated parameters are to be expected).

The code calls the author's `cre2` package which is available in [this repository](https://github.com/hkauhanen/cre2) but is also included here, in the `pkg/` directory, for completeness. Version 0.1.1 is required.

```r
# Install cre2 package
install.packages("../pkg/cre2_0.1.1.tar.gz", repos=NULL)

# Load all scripts
sapply(list.files(path=".", pattern=".R$", full.names=TRUE), source)

# Prepare data
prep_data()

# Read data
data <- load_data()

# Main analysis
fits <- main_analysis(data)

# Model selection
results_5models <- model_selection(fits$summary)
results_3models <- model_selection(fits$summary, modelset=c("CRH", "VRH", "BRH"))
```

To run the regressions with the un-standardized time variable, simply repeat the above but loading the data with an additional argument:

```r
data_us <- load_data(scale = FALSE)
fits_us <- main_analysis(data_us)
results_us_5models <- model_selection(fits_us$summary)
```


### Sanity check against `glm`

All models with the exception of BRH can also be fit in a standard way using R's default implementation for generalized linear models, `glm`. This enables a useful sanity check, as we can correlate the resulting log-likelihoods from both kinds of analysis:

```r
# glm fit
glm_comp <- fit_glm(results_5models, data)

# Differences are small...
diff <- abs(glm_comp$logL - glm_comp$logL_glm)
all(diff < 10^-6)

# ...as also evidenced by this linear regression
summary(lm(logL~logL_glm, glm_comp))
```


## Acknowledgements

This work was supported financially by the Economic and Social Research Council of the UK (grant no.~ES/S011382/1) and by the Federal Ministry of Education and Research (BMBF) and the Baden-Württemberg Ministry of Science as part of the Excellence Strategy of the German Federal and State Governments (project PopDyLan). The manuscript was finalized while the author was employed under a grant from the European Research Council (project STARFISH, grant no.~851423 awarded to George Walkden). Thanks are also due to the Zukunftskolleg of the University of Konstanz for providing computer hardware that greatly facilitated prototyping the software.
