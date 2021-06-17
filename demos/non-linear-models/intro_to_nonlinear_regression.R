#' ---
#' title: "Non-linear regression and some tools for doing it"
#' author: "Sam Taylor"  
#' date: "`r format(Sys.time(), '%d %B, %Y')`"
#' output: html_document
#' ---
#' 

#'The aim here is to show what non-linear regression does and show some tools
#'that help with success in applying it.  
#'  
#'A key disclaimer is that when you are using non-linear models,
#'your data might be worse than you think, so some parameters
#'may not identify as non-zero or estimate stably.  
#'  
#'Another useful hint is that when you are using complex (and even simple)
#'functions, you will have a better chance of understanding why they fit
#'(or don't) if you play around with your function of choice.
#'Going between trying to fit models and seeing what range is sensible for 
#'parameters by just trying out the maths is important for getting to grips
#'with how sensitive each parameter is. It will help you establish what makes
#'sense to 'fix' versus 'estimate'. 
#'  
#'I haven't managed to fit mixed-effects into this demo',
#'but they can be an important way of handling replication in non-linear models,
#'where a 'replicate' commonly consists of a data series from one source.  
#'  
#'## Let's start by reviewing a basic linear model
#'  $y = mx + c$ is obviously linear
#'  We can make a function that evaluates it
sl <- function(m, c, x){
  m * x + c
}

sl1 <- sl(m = 0.5,
          c = 0,
          x = c(0:10)
          )

plot(sl1 ~ c(0:10),
     xlab = "x",
     ylab= "y",
     xlim = c(-1, 11),
     ylim = c(-1, 11),
     las = 1
     )

#trying some different parameters
sl2 <- sl(m = 1,
          c = 0.3,
          x = c(0:10)
          )
points(sl2 ~ c(0:10), col = "red")

#use sl() with rnorm() to generate a model dataset
sl1df <- data.frame(
  x = c(0:10),
  y = rnorm(11, sl1)
)
points(y ~ x, pch = 19, data = sl1df)

#'`lm()` will fit linear models
lm.sl1 <- lm(y ~ x, data = sl1df)
#look at coefficients and their difference from 0
summary(lm.sl1)
#add the best fit line to the plot
plot(y ~ x,
      xlab = "x",
      ylab= "y",
      xlim = c(-1, 11),
      ylim = c(-1, 11),
      pch = 19,
      data = sl1df,
      las = 1
      )
abline(lm.sl1)

#'Note that the coefficients here don't exactly match the input values:  
#'$m = 0.5$ but `x` $\neq0.5$ (`x` is the slope of the regression)  
#'$c = 0$ but `(Intercept)` $\neq0$  
#'From a statistical standpoint, 
#'these estimates are consistent with the inputs:
#'e.g. `(Intercept)` is not significantly different from 0  
#'  
#'If we increase the replication, estimates get better. 

sl1df_ext <- data.frame(
  x = rep(c(0:10), 3),
  y = rnorm(33, rep(sl1, 3))
)

lm.sl1_ext <- lm(y ~ x, data = sl1df_ext)

summary(lm.sl1_ext)

plot(y ~ x,
     xlab = "x",
     ylab= "y",
     xlim = c(-1, 11),
     ylim = c(-1, 11),
     pch = 19,
     data = sl1df_ext,
     las = 1
)
abline(lm.sl1)
#'This is hopefully not news to you, but a useful reminder when tearing your
#'hair over failure to fit non-linear model parameters - 
#'issues with non-linear models usually stem from not having
#'enough data to get good estimates of parameters.
#'  
#'## When is a model non-linear?
#'    
#'`lm()` deals with any function of the form 
#'$y = ax + bx +  cx$ and with transformations, and extend to models with $\log$ 
#'or exponents e.g. $y = ax + bx +  cx^2$

sl1df$x2 <- sl1df$x^2
lm.sl2 <- lm(y ~ x2, data = sl1df)
plot(fitted(lm.sl2) ~ sl1df$x,
     col = "blue",
     las = 1
)

#'This is clearly not a 'linear equation'  
#'  
#'Similarly, empirical, *wiggly* polynomial functions, can also be fit using
#'non-parametric `loess()` or parametric GAM methods 
#'(GAM is a whole topic unto itself).  
#'  
#''Non-linear models' are thus subtly different from 'non-linear equations' :-o  
#''Non-linear models' are usually pre-defined and chosen for their form/
#'theoretical underpinning.  
#'  
#'An ecologist might model a
#'saturating function for Holling predation responses 
#'$C = \frac{\alpha N^n}{1 + \alpha tN^n}$.  
#'  
#'A biochemist might be interested in Michaelis-Menten models for
#'enzyme kinetics
#'$v = V_{max}\frac{[S]}{K_M + [S]}$.  
#'  
#'These are both non-linear models because they are not expressed as
#'$y = ax + bx +  cx$.  
#'  
#'The old school method was to linearise models like these before analysis.
#'e.g., the Lineweaver-Burk linearisation of the Michaelis-Menten equation:
#'$\frac {1}{v}=\frac {K_M}{V_{max}}\cdot \frac {1}{[S]}+\frac {1}{V_{max}}$
#'horrible in this case because you end up with
#'compound variables ($y = \frac{1}{V}, m = \frac{K_M}{V_{max}}$). 
#'These old methods are often robust alternatives to non-linear regression,
#'but in some cases they may be so robust they will provide parameter estimates 
#'even when the data is of dubious quality.
#'  
#'##Let's fit a non-linear model!
#'In my world of plant physiology, a relatively commonly used model for 
#'the response of photosynthesis to light is the non-rectangular hyperbola
#'$A = \frac{\phi Q + A_{sat} -
#' \sqrt{(\phi Q + A_{sat})^2 - (4\theta\phi QA_{sat})}
#' }{2\theta} - R_d$.  
#'This isn't mechanistic, but its parameters align with biological expectations

#create a function that evaluates the non-rectangular hyperbola
AQ.form <- function(phi, Asat, theta, Rd, Q){
  (phi * Q + Asat - sqrt((phi * Q + Asat)^2 - (4 * theta * phi * Q * Asat))) /
      (2 * theta) - Rd
}

#reasonable theoretical values for a C3 plant
c3 <- AQ.form(phi = 0.07,
              Asat = 25,
              theta = 0.8,
              Rd = 2,
              Q = seq(0, 2000, 10)
              )
par(mar = c(4, 5, 1, 1))
plot(c3 ~ seq(0, 2000, 10),
     ylab = expression(italic(A)~~(mu*mol~~m^-2~~s^-1)),
     xlab = expression(PPFD~~(mu*mol~~m^-2~~s^-1)),
     las = 1
     )

#most protocols would look more like this
Qexpt <- c(2000, 1500, 1250, 1000, 750, 600, 500, 400,
           300, 250, 200, 150, 100, 50, 0
           )
c3ideal <- AQ.form(phi = 0.07,
                  Asat = 25,
                  theta = 0.8,
                  Rd = 2,
                  Q = Qexpt
)
c3expt <- data.frame(
  A = rnorm(n = length(Qexpt), mean = c3ideal, sd = 1/20),
  Q = Qexpt
)
points(A ~ Q, data = c3expt, pch = 19, col = "red")

#'The most convenient way to fit this function uses non-linear least squares `nls`
#'Several settings are worth noting here:  
#'-`start =` this names vector/list holds the all-critical initial values 
#'if it is missing the model will fail because it can't find all the parameters
#'it needs for its first interation  
#'-`algorithm =` is the optimisation algorithm used to find minima for multiple
#'parameters. The default is Gauss-Newton, which does not work with this model
#'because it is unbounded so can explore negative parameter values that result 
#'in non-real values for this function. `"port"` enables setting bounds.  
#'-`lower =` actually setting the bounds for all of the parameters  
#'-`trace = TRUE` is a handy diagnostic if you're struggling to guess good
#'starting values because it prints each round of values tried by the algorithm.
#'You can use it to identify starting values that might need bounds setting, or
#'to home in on values that will work well.    
c3m1 <- nls(
  formula = A ~
    (phi * Q + Asat - sqrt((phi * Q + Asat)^2 - (4 * theta * phi * Q * Asat))) /
      (2 * theta) - Rd,
  data = c3expt,
  start = c(phi = 0.05, Asat = 20, theta = 0.5, Rd = 1.5),
  algorithm = "port",
  lower = c(phi = 0, Asat = 0, theta = 0, Rd = 0),
  trace = TRUE
)

summary(c3m1)
#'This is still least squares with parametric assumptions, so you should check
#'distribution of residual and normality.  
#'  
#'Residuals checks are really important to ensure your model is roughly
#'the right shape.  
#'  
#'In this example, they're both adequate because the data were derived as a
#'normal distribution around the theoretical model.
plot(resid(c3m1) ~ fitted(c3m1))
qqnorm(resid(c3m1))

#'It's a bit of a misuse of the data, since the values are *A* versus [CO$_2$]
#'but we can illustrate how to handle multiple curves with the R's 'CO2' data.  
#'  
#'Excuse my use of lattice rather than ggplot...
library(lattice)
xyplot(uptake ~ conc | Plant, data = CO2)

#'You can get a quick evaluation of parameters for every plant using `nlsList()`
#'from `nlme` provided you don't need bounds... (so the example I was building
#'died right here - a more manual approach is needed for that one... probably,
#'build a function that fits the nls and reports coefficients,
#'then loop or `tapply` it).  
#'  
#'Points to note  
#'- it's `model`, not `formula`, and there's grouping using `|`
#'- I'm also using a built in `SSasympOff()` function - akin to AQ.form above (I'll add formula here later)
#'and tweaked to get running nicely
library(nlme)
CO2m1 <- nlsList(
  model = uptake ~ SSasympOff(conc, Asym, lrc, c0) | Plant,
  data = CO2,
  start = c(Asym = 30, lrc = -4.5, c0 = 52)
)

#'Convenient output with stats
summary(CO2m1)

#' You can plot validations simply
plot(resid(CO2m1)~fitted(CO2m1))
qqnorm(resid(CO2m1))

#'or more usefully
xyplot(resid(CO2m1) ~ fitted(CO2m1) | CO2$Plant)

#'and there are tools for more detailed visualisation
plot(coef(CO2m1))
plot(augPred(CO2m1))

#'The story of `nlme()` (mixed effects) will need to wait for another time...
#'And, if you feel really brave, and none of these pre-built functions work
#'there's always the option of building your own by using `optim()` to do
#'parameter searches while minimising sums of squares...
