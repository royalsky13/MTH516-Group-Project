# These are the suuplimentary codes, will be used for testing for the residuals

# install.packages("BSDA")  # Only needed once
library(BSDA)

# Perform one-sample sign test
SIGN.test(clim.data$ANN- mean(clim.data$ANN), md = 0, alternative = "two.sided")

# install.packages("randtests")  # Run this line only once
library(randtests)

# Perform two sided run test
runs.test(clim.data$ANN)

# Perform one-sided run tests
runs.test(clim.data$ANN, alternative = "left.sided")
runs.test(clim.data$ANN, alternative = "right.sided")
