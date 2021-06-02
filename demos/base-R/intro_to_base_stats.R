#' ---
#' title: "Some things I think are useful to know in base R"
#' author: "Sam Taylor"  
#' date: "`r format(Sys.time(), '%d %B, %Y')`"
#' output: github_document
#' ---
#' 

#'The aim here is to demonstrate base R objects and functions.
#'There are endless opportunities to do whatever flavour of statistics have
#'been incorporated into packages in R, but a quick tour of simple tests of
#'difference and association is a good way to get a functional understanding of
#'inputs, outputs, and what they look like under the bonnet, which links with
#'getting the most out of help files  
#'  
#'To do anything in R, you need to create objects  
#'  
#'The assignment operator `<-` creates an object
a <- "b"
#'Once the object is assigned, you can print it by calling it
a

#'Vectors, i.e. one dimensional arrays, can be made using combine `c()`
b <- c(1, 2, 3)
b

#'To get a sequence of integers
b <- c(1:3)
b

#'To get a sequence with some fixed interval
b <- seq(1, 3, 0.1)
b

#'Repeating things
b <- rep(c("a", "b", "c"), 3)
b

b <- rep(c("a", "b", "c"), each = 3)
b

#'R also has a suite of functions that let you do simulation  
#'For example, a random draw from a normal distribution
a <- rnorm(9)
a

a <- rnorm(9, mean = 20, sd = 5)
a

#'Once you have objects you can use them as inputs for stats  
#'  
#'*Linear model* `lm()` output is presented in terms of 'coefficients'
#'from a linear equation. Linear models are the favourite tool in R
#'because they are relatively robust to things like departures from normality
#'and unbalanced designs
lm(a ~ b)

#'Traditional *ANOVA* can be obtained with `aov()`  
#'*(This is running lm, then reporting the variance decomposition
#'and is only strictly appropriate when sample sizes are balanced
#'i.e. type I ANOVA)*
aov(a ~ b)

#'Non-parametric stats
kruskal.test(a ~ b)
#'Great, but if you just call a naked function this way you only
#'retrieve the output of its associated print method  
#'  
#'This is what the complete output looks like for the lm call above
lm(a ~ b)[]
#'Yuck! This multi-level list object is described in the help for `lm()`
#'Use `?lm` in the console to access the help page and scroll down
#'to the 'Value' heading  
#'  
#'To return the structure of the object, we can use `str()` 
str(lm(a ~ b))
#'In this case, `str()` is almost as verbose as just printing the
#'object using `[]`, but it does help you quickly identify
#'names of list components, nesting structure etc.  
#'  
#'Any of the components can be accessed using combinations of `[]`, `$`,
#'etc  

#'For example, here's the first element of the list
lm(a ~ b)[1]
#'Since this is an S3 list object using `$'name'` can also be used  
#'(For S4 objects, `@` plays a similar role)
lm(a ~ b)$coefficients
#'To just get the intercept
lm(a ~ b)$coefficients['(Intercept)']
#'Note that the name `'(Intercept)'` has to be surrounded by quotes
#'or this will not work; if you type `[(Intercept)]` you get an error
#'because the `()` has a special meaning of its own within R code
#'There are lots of quirks like this to handle when doing this kind of thing...
#'Too many to cover here... **FUN TIMES!!!**  
#'  
#'In each of the examples above, we were literally re-running `lm()`
#'each time it was called.  
#'  
#'It is far more powerful to assign the output of lm()
c <- lm(a ~ b)
#'just calling this object gives the print output
c
print(c)
#'In addition, objects created from functions have 'methods'
#'that can be used to interpret them.  
#'R identifies kinds of objects using `- attr(*, "class")`,
#'which is the last thing listed in `str()` output above.  
#'It can also be accessed using    
class(c)
#'The consequence is, when I do the below, it runs the function
#'documented as `?<function>.lm`  
#'  
#'e.g. ?plot.lm (noting that the obejct we created prints an error instead
#'of a third plot here)
plot(c)
#'e.g. ?anova.lm
anova(c)
#'e.g. ?summary.lm
summary(c)
#'In contributed packages you might not get much help from 'class-type'-help
#'but in base R, it's useful to know that `?plot` is not going to tell you
#'much about what is implemented when you call plot on e.g. an `lm()` object.  
#'  
#'More generally, if you use e.g. `?lm`, you should find a section at the
#'bottom called **See Also**. This is where you'll find tips about methods you
#'might need to interpret your output, or similar methods with specific goals  
#'  
#'So far, we've been making direct use of a couple of vector objects
#'in our calls to stats functions, but you probably won't do this most of the
#'time.  
#'  
#'You're more likely to use a `data.frame`
#'(though if you're tidy minded, you'll probably be using a tibble,
#'which is OK most of the time...)
d <- data.frame(meas = a, group = b)
d
#'To use a data.frame, you tell R where to look for input with `data =`
#'and use the names of columns to identify which bits to use 
lm(meas ~ group, data = d)
#'Note that this doesn't work
# lm(meas ~ group)
#'Because meas and group aren't available objects in the R Environment
objects()
#'meas and group are only accessible from within the d object
d$meas
d$group
#'If you're super efficient and import one data object
#'with no need to manipulate it in R you can `attach` it and forgo
#'the `data =`
attach(d)
lm(meas ~ group)
#'Note that this does not cause meas and group to be created as objects
#'in the workspace
objects()
#'Instead, it enables R to search within `d` when looking for objects.  
#'  
#'The caveat with this approach is you may get confused about what you attached
#'If you use `data =` then you are always being explicit about what data is  
#'  
#'You can also 
detach(d)
# lm(meas ~ group)

#'###More complex examples of formulae in lm  
#'Using the palmer penguins... realised too late that this might not be
#'accessible to everyone, especially if using a managed computer. Also, despite
#'a lot of interesting built in datasets (check `data()`) this one worked best
#'for this purpose
library(palmerpenguins)
head(penguins)
#'There are `NA` (missing data) in the sex column, which affected the examples
#', so fixing that.
penguins <- penguins[!is.na(penguins$sex), ]
#'Simple two-way categorical anova
e <- lm(bill_length_mm ~ species * sex, data = penguins)
anova(e)
#'Pairwise post hoc tests in their most simple form
TukeyHSD(aov(e))
#'(There are packages out there with more user friendly output...)
#'  
#'And, testing for the key assumption of ANOVA - homoskedasticity
#'    
#'Because you need to test at the lowest level I'm first making
#'a grouping factor by pasting together the two other categories
penguins$spp_sx <- paste(penguins$species, penguins$sex, sep ="_")
bartlett.test(bill_length_mm ~ spp_sx, data = penguins)

#'The same outcome can be appreciated visually using `plot()`
#'changing the layout to 2 x 2 makes this easier to handle
#'(you don't have to press return for each plot,
#'useful when you want your whole script to run uninterrupted)
par(mfrow = c(2, 2))
plot(e)
#'There appear to be some high outliers
#'that cause the homoskedasticity test to fail  

#'Here's a way to filter these (likely not as elegant as a tidyverse method)
oln <- names(resid(e))[!resid(e) < 7]
oln
ol <- row.names(penguins) %in% names(resid(e))[!resid(e) < 7]
ol
bartlett.test(bill_length_mm ~ spp_sx, data = penguins[!ol, ])

e2 <- lm(bill_length_mm ~ species * sex, data = penguins[!ol, ])
plot(e2)
anova(e2)
#'with outliers excluded, the sex effect on species comparisons is significant
#'this matches the outcome of an AIC based model minimisation,
#'which is that the species:sex term is valuable in the model
e3 <- step(e)

#'You'd be hard pushed to argue this significant result was important though...
#'which is to say, modelling with a hypothesis in mind is better than
#'just fiddling around with some data
par(mfrow = c(1, 1))
boxplot(bill_length_mm ~ spp_sx,
        data = penguins,
        las = 3,
        xlab = "",
        ylim = c(30,60)
        )
#'An alternative way to write out the same model
#' where `:` specifies the interaction term
f <- lm(bill_length_mm ~ species + sex + species:sex, data = penguins)
anova(f)

#'Linear models let you mix categorical and continuous variables
g <- lm(bill_length_mm ~ body_mass_g * species * sex, data = penguins)
anova(g)
#'Ideally, you'll have clear hypotheses about what you expect is important
#'and your p-values will inform you about those hypotheses.
#'Here I just bunged-in some things, and it's clear that 
#'several terms in this model are not explaining much variation
#'In this case you can do an AIC (Aikake's Information Criterion) search
#'looking for a minimal model that explains the data effectively
g2 <- step(g)
#'Ends up minimising to e
#'  
#'If you're after t-tests
t.test(bill_length_mm ~ sex, data = penguins)

#'Or Kruskal-Wallis tests
kruskal.test(bill_length_mm ~ species, data = penguins)

#'Useful to know that the base correlation testing function syntax is
#' a bit different from the one for linear models etc.
cor.test(~ bill_length_mm + body_mass_g,
         data = penguins,
         method = "pearson"
         )
#'Notice that this gives a warning
cor.test(~ bill_length_mm + body_mass_g,
         data = penguins,
         method = "spearman"
         )
#'Meaning that while it's not broken to the point of no output,
#'something isn't quite right.
#'    
#'In this case, you can silence the warning
cor.test(~ bill_length_mm + body_mass_g,
         data = penguins,
         method = "spearman",
         exact = FALSE
         )

#'Or
cor.test(penguins$bill_length_mm, penguins$body_mass_g, method = "pearson")
#'or, if you don't like typing `penguins$` you could
attach(penguins)
cor.test(bill_length_mm, body_mass_g, method = "pearson")

