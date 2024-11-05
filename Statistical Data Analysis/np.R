library(BSDA)
if (!require("randtests")) install.packages("randtests")
library(randtests)
setwd("/home/localuser/Downloads/")
climate <- read.csv("climate.csv")
View(climate)
residuals <-read.csv("residual.csv")

# Run's Test for randomness
runs.test(residuals$x)

# Run's Test one sided
runs.test(residuals$x, alternative = "left.sided")

runs.test(residuals$x, alternative = "right.sided")


# Sign Test Two sided
SIGN.test(residuals$x , md = 0, alternative = "two.sided")


data <- residuals$x 
hypothesized_median <- 0
signs <- sign(data - hypothesized_median)
positive_signs <- sum(signs == 1)
negative_signs <- sum(signs == -1)
n <- positive_signs + negative_signs
sign_test_result <- binom.test(positive_signs, n, p = 0.5, alternative = "two.sided")
print(sign_test_result)
