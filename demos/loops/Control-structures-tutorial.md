CEEDS Coding group tutorial - Control structures
================
Lisa Boström Einarsson <l.bostromeinarsson@lancaster.ac.uk>
24 November, 2021

``` r
#Tutorial based on: https://bookdown.org/rdpeng/rprogdatascience/control-structures.html
```

***Disclaimers:***  
- *Loops ate data-heavy and relatively slow ways of working with data
(especially if you save objects along the way)*  
- *There are other ways to do it better (apply-suite of tools)*  
- *There’s a tendency of loops turning into a brute forcy way of doing
thing stuff*  
- *BUT: there’s nothing wrong with brute forcing things - it’s how we
all learn!*  
- *AND: for/while loops are a basic tool of programming in R, and a
useful tool to build up your coding skills.*

# What are control structures?!

*Control structures in R are a way to* **control the flow** *of the
execution of a series of R expressions, so that input/features of the
data alters the functions/expressions run and therefore the output of
the data*

Common control structures include:

-   `if` and `else`: *logical tests followed by output based on test
    outcome*  
-   `for`: *execute a loop a fixed number of times*  
-   `while`: *execute a loop while a condition is true*  
-   `repeat`, `break`, `next`: *less common*

### Introducing FizzBuzz:

*Write a program that prints the numbers from 1 to 100. But for
multiples of three print “Fizz” instead of the number and for the
multiples of five print “Buzz”. For numbers which are multiples of both
three and five print “FizzBuzz”*

## Solution 1: Base R (AKA Brute Force)

``` r
a <- data.frame(num=1:100, print=as.factor(1:100))  
fizz <- data.frame(num = a$num*3, print = "fizz")
buzz <- data.frame(num = a$num*5, print = "buzz")
fizzbuzz <- data.frame(num = a$num*15, print = "fizzbuzz")


b <- merge(a,fizz,all = T )
c <- merge(b,buzz,all = T )
d <- merge(c,fizzbuzz,all = T )
```

Sidenote: introducing base R, atomic notation: `vector[value.number]`,
`data.frame[row,column]`

``` r
x <- c(1:10)
x[3] 
```

    ## [1] 3

``` r
y=data.frame(x=x, y="foo")
y[3,1]
```

    ## [1] 3

back to fizzbuzz now that we understand atomic notations

``` r
e <- d[d$num<101,]
f <- e[with(e, order(num, print, decreasing = TRUE)),]
g <- f[!duplicated(f$num),]
h <- g[order(g$num, decreasing = FALSE),]
fzb <- as.character(h$print)

print(fzb)
```

    ##   [1] "1"        "2"        "fizz"     "4"        "buzz"     "fizz"    
    ##   [7] "7"        "8"        "fizz"     "buzz"     "11"       "fizz"    
    ##  [13] "13"       "14"       "fizzbuzz" "16"       "17"       "fizz"    
    ##  [19] "19"       "buzz"     "fizz"     "22"       "23"       "fizz"    
    ##  [25] "buzz"     "26"       "fizz"     "28"       "29"       "fizzbuzz"
    ##  [31] "31"       "32"       "fizz"     "34"       "buzz"     "fizz"    
    ##  [37] "37"       "38"       "fizz"     "buzz"     "41"       "fizz"    
    ##  [43] "43"       "44"       "fizzbuzz" "46"       "47"       "fizz"    
    ##  [49] "49"       "buzz"     "fizz"     "52"       "53"       "fizz"    
    ##  [55] "buzz"     "56"       "fizz"     "58"       "59"       "fizzbuzz"
    ##  [61] "61"       "62"       "fizz"     "64"       "buzz"     "fizz"    
    ##  [67] "67"       "68"       "fizz"     "buzz"     "71"       "fizz"    
    ##  [73] "73"       "74"       "fizzbuzz" "76"       "77"       "fizz"    
    ##  [79] "79"       "buzz"     "fizz"     "82"       "83"       "fizz"    
    ##  [85] "buzz"     "86"       "fizz"     "88"       "89"       "fizzbuzz"
    ##  [91] "91"       "92"       "fizz"     "94"       "buzz"     "fizz"    
    ##  [97] "97"       "98"       "fizz"     "buzz"

Gets the job done, BUT 12 objects created, 13 lines of code!

## “Solution 2”: `if else` statements

*Tests a condition, acts on it depending on whether the statement is
true or false*

**Sidenote:** here we use `%%`, the modulo operator, which evaluates the
remainder, following division. If the remainder is zero, the first
number is divisible by the second number.

``` r
#  Syntax: if(<condition>) {
#    ## do something
# }
# ## Continue with rest of code
```

if-statement

``` r
a <- 5

if(a%%3==0) {                # check if a is divisible by 3, 
   "fizz"                    # if true, return "fizz". If false, do nothing
}
```

`if, else` statement

``` r
if(a%%3==0) {                # check if a is divisible by 3,
   "fizz"                    # if true, return "fizz".
} else (a)                   # If false, return a
```

    ## [1] 5

nested `if, else`statements

``` r
if(a%%3==0) {                # check if a is divisible by 3,
   "fizz"                    # if true, return "fizz".
} else if(a%%5==0) {         # if false, check if a is divisible by 3,
   "buzz"                    # if true, return "buzz"
} else (a)                   # If false, return a
```

    ## [1] "buzz"

*very* nested `if, else` statements

``` r
a=2

if(a%%3==0 & a%%5==0) {      # check if a is divisible by 3 AND 5
   "fizzbuzz"                # if true, return "fizzbuzz"
} else if(a%%3==0) {         # check if a is divisible by 3,
   "fizz"                    # if true, return "fizz".
} else if(a%%5==0) {         # if false, check if a is divisible by 3,
   "buzz"                    # if true, return "buzz"
} else (a)                   # If false, return a
```

    ## [1] 2

Ok so now we know how to evaluate whether the number is divisible by 3,
5 or both, and to return the correct fizzbuzz word, but how do we get it
to apply this test to each row of the dataframe?

….enter for(loops)

## Solution 3: `for`-loops

*For loops take an interator (i) variable and assign it successive
values from a sequence or vector. For loops are most commonly used for
iterating over the elements of an object (list, vector, etc.)*

Syntax:

``` r
# for(i in `start value`:`end value`){ 
#   <do something>
# }

# basic loop
for(i in 1:5){                        # for every number between 1:5
   print(i*2)                         # multiply current number by 2
}
```

    ## [1] 2
    ## [1] 4
    ## [1] 6
    ## [1] 8
    ## [1] 10

``` r
# calling outside vectors

values <- c(1:5)                      # create vector 1:5
for(i in 1:length(values)){           # for every number between 1 and the number of values in vector 
   print(values[i]*2)                 # multiply the nth value (determined by i) in vector, by 2
}
```

    ## [1] 2
    ## [1] 4
    ## [1] 6
    ## [1] 8
    ## [1] 10

ok, but what about fizzbuzz?!

``` r
for (i in 1:100){                      # for every number in 1 to 100
   
   if(i%%3 == 0 & i%%5 == 0) {         # execute the following expressions
      print('FizzBuzz')
   }
   else if(i%%3 == 0) {
      print('Fizz')
   }
   else if (i%%5 == 0){
      print('Buzz')
   }
   else {
      print(i)                         #if neither are true, print current i
   }
   
}
```

    ## [1] 1
    ## [1] 2
    ## [1] "Fizz"
    ## [1] 4
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 7
    ## [1] 8
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 11
    ## [1] "Fizz"
    ## [1] 13
    ## [1] 14
    ## [1] "FizzBuzz"
    ## [1] 16
    ## [1] 17
    ## [1] "Fizz"
    ## [1] 19
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 22
    ## [1] 23
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 26
    ## [1] "Fizz"
    ## [1] 28
    ## [1] 29
    ## [1] "FizzBuzz"
    ## [1] 31
    ## [1] 32
    ## [1] "Fizz"
    ## [1] 34
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 37
    ## [1] 38
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 41
    ## [1] "Fizz"
    ## [1] 43
    ## [1] 44
    ## [1] "FizzBuzz"
    ## [1] 46
    ## [1] 47
    ## [1] "Fizz"
    ## [1] 49
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 52
    ## [1] 53
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 56
    ## [1] "Fizz"
    ## [1] 58
    ## [1] 59
    ## [1] "FizzBuzz"
    ## [1] 61
    ## [1] 62
    ## [1] "Fizz"
    ## [1] 64
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 67
    ## [1] 68
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 71
    ## [1] "Fizz"
    ## [1] 73
    ## [1] 74
    ## [1] "FizzBuzz"
    ## [1] 76
    ## [1] 77
    ## [1] "Fizz"
    ## [1] 79
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 82
    ## [1] 83
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 86
    ## [1] "Fizz"
    ## [1] 88
    ## [1] 89
    ## [1] "FizzBuzz"
    ## [1] 91
    ## [1] 92
    ## [1] "Fizz"
    ## [1] 94
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 97
    ## [1] 98
    ## [1] "Fizz"
    ## [1] "Buzz"

compared to brute force solution

``` r
fzb
```

    ##   [1] "1"        "2"        "fizz"     "4"        "buzz"     "fizz"    
    ##   [7] "7"        "8"        "fizz"     "buzz"     "11"       "fizz"    
    ##  [13] "13"       "14"       "fizzbuzz" "16"       "17"       "fizz"    
    ##  [19] "19"       "buzz"     "fizz"     "22"       "23"       "fizz"    
    ##  [25] "buzz"     "26"       "fizz"     "28"       "29"       "fizzbuzz"
    ##  [31] "31"       "32"       "fizz"     "34"       "buzz"     "fizz"    
    ##  [37] "37"       "38"       "fizz"     "buzz"     "41"       "fizz"    
    ##  [43] "43"       "44"       "fizzbuzz" "46"       "47"       "fizz"    
    ##  [49] "49"       "buzz"     "fizz"     "52"       "53"       "fizz"    
    ##  [55] "buzz"     "56"       "fizz"     "58"       "59"       "fizzbuzz"
    ##  [61] "61"       "62"       "fizz"     "64"       "buzz"     "fizz"    
    ##  [67] "67"       "68"       "fizz"     "buzz"     "71"       "fizz"    
    ##  [73] "73"       "74"       "fizzbuzz" "76"       "77"       "fizz"    
    ##  [79] "79"       "buzz"     "fizz"     "82"       "83"       "fizz"    
    ##  [85] "buzz"     "86"       "fizz"     "88"       "89"       "fizzbuzz"
    ##  [91] "91"       "92"       "fizz"     "94"       "buzz"     "fizz"    
    ##  [97] "97"       "98"       "fizz"     "buzz"

## 4. What next??

-   A common next step is to then make your loops into functions:

``` r
#define the function
fizz_buzz <- function(start_num=1, end_num=100){    # define the function, and values (with defaults)
   for (i in start_num:end_num){                    # insert our for-loop with if/else statements again
    if(i%%3 == 0 & i%%5 == 0) {
      print('FizzBuzz')
   }
   else if(i%%3 == 0) {
      print('Fizz')
   }
   else if (i%%5 == 0){
      print('Buzz')
   }
   else {
      print(i)
   }
   
}}

fizz_buzz(1,70)                              # run function, supplying start and end values (different from default values)
```

    ## [1] 1
    ## [1] 2
    ## [1] "Fizz"
    ## [1] 4
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 7
    ## [1] 8
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 11
    ## [1] "Fizz"
    ## [1] 13
    ## [1] 14
    ## [1] "FizzBuzz"
    ## [1] 16
    ## [1] 17
    ## [1] "Fizz"
    ## [1] 19
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 22
    ## [1] 23
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 26
    ## [1] "Fizz"
    ## [1] 28
    ## [1] 29
    ## [1] "FizzBuzz"
    ## [1] 31
    ## [1] 32
    ## [1] "Fizz"
    ## [1] 34
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 37
    ## [1] 38
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 41
    ## [1] "Fizz"
    ## [1] 43
    ## [1] 44
    ## [1] "FizzBuzz"
    ## [1] 46
    ## [1] 47
    ## [1] "Fizz"
    ## [1] 49
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 52
    ## [1] 53
    ## [1] "Fizz"
    ## [1] "Buzz"
    ## [1] 56
    ## [1] "Fizz"
    ## [1] 58
    ## [1] 59
    ## [1] "FizzBuzz"
    ## [1] 61
    ## [1] 62
    ## [1] "Fizz"
    ## [1] 64
    ## [1] "Buzz"
    ## [1] "Fizz"
    ## [1] 67
    ## [1] 68
    ## [1] "Fizz"
    ## [1] "Buzz"

## 5. While-loops

-   While loops start by testing a condition. If it is true `TRUE`, then
    they execute the loop. Once the loop body is executed, the condition
    is tested again, and so forth, until the condition is false, after
    which the loop exits.\*

``` r
count <- 0    #it's common to have some kind of counter in the while-loop, remember to include a reset!

while(count < 10) {                              # while count is less than zero
            print(count)                         # print count
            count <- count + 1                   # increase counter by one 
    }                                            # loop back to condition agin 
```

    ## [1] 0
    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5
    ## [1] 6
    ## [1] 7
    ## [1] 8
    ## [1] 9

Bonus! - progress bar

``` r
pb <- txtProgressBar(min = 0, max=30, style = 3) # 1. setting up the progress bar (outside loop)
   
   for(i in 1:30) {                              # for-loop nonsense to require progress bar!
      Sys.sleep(0.1)                             # nonsense
      setTxtProgressBar(pb, i)}                  # 2. updating the progress bar
   Sys.sleep(1)                                  # nonsense
   close(pb)                                     # 3. closing progress bar
```

## 6. Apply!

*Control structures are primarily useful for writing programs; for
command-line interactive work, the `apply` functions are more useful.
`Apply` functions are basically pre-written looping functions to shorten
number of rows needed for looping commands*

-   `lapply()`: Loop over a list and evaluate a function on each
    element  
-   `sapply()`: Same as lapply but try to simplify the result  
-   `apply()`: Apply a function over the margins of an array  
-   `tapply()`: Apply a function over subsets of a vector  
-   `mapply()`: Multivariate version of lapply

`Apply` version of FizzBuzz (courtesy of Sam Taylor!)

``` r
   fb2 <- function(.){                      # define function, "." = the list sapply runs down
      fizz <- . %% 3 == 0                   # is current number divisible by 3? (TRUE/FALSE)
      buzz <- . %% 5 == 0                   # is current number divisible by 5?   
      fizzbuzz <- fizz & buzz               # is current number divisible by 3 AND 5? 
      
      if (fizzbuzz) {                       # is fizzbuzz = TRUE?
         print("fizzbuzz") }                # If true, print "fizzbuzz"
      else {ifelse(fizz,                    # if false, check if fizz = TRUE?
                   print("fizz"),           # if TRUE print "fizz"
                   ifelse(buzz,             # if false, check if buzz is true
                          print("buzz"),    # if true print "buzz"
                          print(.))         # if none are true, print current number   
      )
         
      }
   }                                        # loop back to next value, run expressions from top again
   
   sapply(c(1:100), fb2)                    # run fb2 function on a list with numbers 1:100
```

    ## [1] 1
    ## [1] 2
    ## [1] "fizz"
    ## [1] 4
    ## [1] "buzz"
    ## [1] "fizz"
    ## [1] 7
    ## [1] 8
    ## [1] "fizz"
    ## [1] "buzz"
    ## [1] 11
    ## [1] "fizz"
    ## [1] 13
    ## [1] 14
    ## [1] "fizzbuzz"
    ## [1] 16
    ## [1] 17
    ## [1] "fizz"
    ## [1] 19
    ## [1] "buzz"
    ## [1] "fizz"
    ## [1] 22
    ## [1] 23
    ## [1] "fizz"
    ## [1] "buzz"
    ## [1] 26
    ## [1] "fizz"
    ## [1] 28
    ## [1] 29
    ## [1] "fizzbuzz"
    ## [1] 31
    ## [1] 32
    ## [1] "fizz"
    ## [1] 34
    ## [1] "buzz"
    ## [1] "fizz"
    ## [1] 37
    ## [1] 38
    ## [1] "fizz"
    ## [1] "buzz"
    ## [1] 41
    ## [1] "fizz"
    ## [1] 43
    ## [1] 44
    ## [1] "fizzbuzz"
    ## [1] 46
    ## [1] 47
    ## [1] "fizz"
    ## [1] 49
    ## [1] "buzz"
    ## [1] "fizz"
    ## [1] 52
    ## [1] 53
    ## [1] "fizz"
    ## [1] "buzz"
    ## [1] 56
    ## [1] "fizz"
    ## [1] 58
    ## [1] 59
    ## [1] "fizzbuzz"
    ## [1] 61
    ## [1] 62
    ## [1] "fizz"
    ## [1] 64
    ## [1] "buzz"
    ## [1] "fizz"
    ## [1] 67
    ## [1] 68
    ## [1] "fizz"
    ## [1] "buzz"
    ## [1] 71
    ## [1] "fizz"
    ## [1] 73
    ## [1] 74
    ## [1] "fizzbuzz"
    ## [1] 76
    ## [1] 77
    ## [1] "fizz"
    ## [1] 79
    ## [1] "buzz"
    ## [1] "fizz"
    ## [1] 82
    ## [1] 83
    ## [1] "fizz"
    ## [1] "buzz"
    ## [1] 86
    ## [1] "fizz"
    ## [1] 88
    ## [1] 89
    ## [1] "fizzbuzz"
    ## [1] 91
    ## [1] 92
    ## [1] "fizz"
    ## [1] 94
    ## [1] "buzz"
    ## [1] "fizz"
    ## [1] 97
    ## [1] 98
    ## [1] "fizz"
    ## [1] "buzz"

    ##   [1] "1"        "2"        "fizz"     "4"        "buzz"     "fizz"    
    ##   [7] "7"        "8"        "fizz"     "buzz"     "11"       "fizz"    
    ##  [13] "13"       "14"       "fizzbuzz" "16"       "17"       "fizz"    
    ##  [19] "19"       "buzz"     "fizz"     "22"       "23"       "fizz"    
    ##  [25] "buzz"     "26"       "fizz"     "28"       "29"       "fizzbuzz"
    ##  [31] "31"       "32"       "fizz"     "34"       "buzz"     "fizz"    
    ##  [37] "37"       "38"       "fizz"     "buzz"     "41"       "fizz"    
    ##  [43] "43"       "44"       "fizzbuzz" "46"       "47"       "fizz"    
    ##  [49] "49"       "buzz"     "fizz"     "52"       "53"       "fizz"    
    ##  [55] "buzz"     "56"       "fizz"     "58"       "59"       "fizzbuzz"
    ##  [61] "61"       "62"       "fizz"     "64"       "buzz"     "fizz"    
    ##  [67] "67"       "68"       "fizz"     "buzz"     "71"       "fizz"    
    ##  [73] "73"       "74"       "fizzbuzz" "76"       "77"       "fizz"    
    ##  [79] "79"       "buzz"     "fizz"     "82"       "83"       "fizz"    
    ##  [85] "buzz"     "86"       "fizz"     "88"       "89"       "fizzbuzz"
    ##  [91] "91"       "92"       "fizz"     "94"       "buzz"     "fizz"    
    ##  [97] "97"       "98"       "fizz"     "buzz"
