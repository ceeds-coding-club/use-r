## Sam Taylor - 10th November 2021

#intro to lm
mock_data <- data.frame(
  treat = rep(c("A", "B", "C", "D", "E", "F"), each = 30),
  dep = c(mapply(rnorm,
                 n = rep(30, 6),
                 mean = c(20, 30, 35, 20, 25, 35),
                 sd = 7,
                 SIMPLIFY = TRUE
  )
  )
)

plot(dep ~ factor(treat), data = mock_data)

#one-way anova
lm1 <- lm(dep ~ treat, data = mock_data)
lm1
anova(lm1)
summary(lm1)
plot(lm1)

lm2 <- lm(dep ~ treat - 1, data = mock_data)
lm2
anova(lm2)
summary(lm2)
plot(lm2)

#you can use update to get to the same place
lm2_1 <- update(lm1, . ~ . - 1) 
lm2_1

#you can also supply a formula as a separate item
f1 <- formula(dep ~ treat - 1)
lm2_2 <- lm(f1, data = mock_data)
lm2_2

#This can be useful for programming functions that do lm fits etc
#because you can do this

a <- "dep"
b <- "treat"
f1_1 <- formula(paste(a, b, sep = "~"))
lm1_2 <- lm(f1_1, data = mock_data)
lm1_2

mock_data$indep <- mock_data$dep * rnorm(90, 1, 1)

plot(dep ~ indep, mock_data)

#linear regression
lm3 <- lm(dep ~ indep, data = mock_data)
lm3
anova(lm3)
summary(lm3)
plot(lm3)

#ancova
lm4 <- lm(dep ~ indep * treat, data = mock_data)
lm4
anova(lm4)
summary(lm4)
plot(lm4)

lm4.1 <- update(lm4, . ~ . - 1)
lm4.1
summary(lm4.1)

lm4.2 <- update(lm4, . ~ . - indep:treat)
lm4.2

anova(lm4, lm4.1)# these are actually the same model!

anova(lm4, lm4.2)# these are different models
anova(lm4)# equivalent test to the anova interaction,
# here based on likelihood ratio rather than sum of squares decomposition

#multiple regression
mock_data$indep2 <- mock_data$dep * rnorm(90, 0.6, 1)
lm5 <- lm(dep ~ indep + indep2, data = mock_data)
lm5
anova(lm5)
summary(lm5)
#plot(lm5)

#two-way anova
mock_data$treat2 <- rep(c("A", "B", "C"), 60)
lm6 <- lm(dep ~ treat * treat2, data = mock_data)
lm6
anova(lm6)
summary(lm6)
plot(lm6)

#Summarizing, the general linear model is a flexible framework for fitting
# models that can be described by a series of additive terms.
# The flexibility comes from an underlying matrix algebra representation,
# via a design matrix.

#General linear models require parametric assumptions to hold.
# These are assessed in terms of the residuals rather than the dependent variable
# because the residuals account for the impact on the dependent of all the
# predictor variables included in the model.
#A valid general linear model has
# independent and identically distributed residuals (iid residuals)
# The distribution is assumed to be a normal distribution;
# however, as long as standard errors remain a reasonable estimator of variance
# departures from normality are usually less important for accurate
# p-value estimation than independence of the residuals
# (that is the assumption of homoskedasticity, i.e. equal variances).
#plot.lm() provides the tools for assessing these assumptions

#If your residuals are not iid,
# the implication is something about the underlying distribution of your data
# is not being accounted for.
# For example, there could be correlation among
# measurements made close to one another in time or space, or the data 
# may have a non-normal distribution, e.g., Poisson.
#Non-normal distributions could be handled through transformation of the
# dependent, or use of general linear models where a link-function
# is incorporated along with robust estimation methods
# for the distribution in question.
#Correlations among data points, or differences in variance linked with
# treatments or predictors (e.g. greater variance in size on island A than B)
# can be handled by adding random effects terms that estimate how sampling
# has affected your data 