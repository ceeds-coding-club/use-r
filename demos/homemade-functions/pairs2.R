#' Pairs plots for correlations
#' adapted from Zuur et al. Highland Statistics https://gist.github.com/jfroeschke/a7a900b41c7348b3c0b30a36766223e5
#' pairs2 creates Pearson correlations and scatterplots with LOESS for data diagnostics.
#' @param x is dataset containing y and all x covariates.

## plot correlations between numeric variables
pairs2 <-  function (x, labels, panel = points, ..., lower.panel = panel.smooth2, 
            upper.panel = panel.cor, diag.panel = panel.hist, text.panel = textPanel, 
            label.pos = 0.5 + has.diag/3, cex.labels = NULL, font.labels = 2,
            row1attop = TRUE, gap = 1) 
  {
    textPanel <- function(x = 0.5, y = 0.5, txt, cex, font) text(x, 
                                                                 y, txt, cex = cex, font = font)
    localAxis <- function(side, x, y, xpd, bg, col = NULL, main, 
                          oma, ...) {
      if (side%%2 == 1) 
        Axis(x, side = side, xpd = NA, ...)
      else Axis(y, side = side, xpd = NA, ...)
    }
    localPlot <- function(..., main, oma, font.main, cex.main) plot(...)
    localLowerPanel <- function(..., main, oma, font.main, cex.main) lower.panel(...)
    localUpperPanel <- function(..., main, oma, font.main, cex.main) upper.panel(...)
    localDiagPanel <- function(..., main, oma, font.main, cex.main) diag.panel(...)
    dots <- list(...)
    nmdots <- names(dots)
    if (!is.matrix(x)) {
      x <- as.data.frame(x)
      for (i in seq_along(names(x))) {
        if (is.factor(x[[i]]) || is.logical(x[[i]])) 
          x[[i]] <- as.numeric(x[[i]])
        if (!is.numeric(unclass(x[[i]]))) 
          stop("non-numeric argument to 'pairs'")
      }
    }
    else if (!is.numeric(x)) 
      stop("non-numeric argument to 'pairs'")
    panel <- match.fun(panel)
    if ((has.lower <- !is.null(lower.panel)) && !missing(lower.panel)) 
      lower.panel <- match.fun(lower.panel)
    if ((has.upper <- !is.null(upper.panel)) && !missing(upper.panel)) 
      upper.panel <- match.fun(upper.panel)
    if ((has.diag <- !is.null(diag.panel)) && !missing(diag.panel)) 
      diag.panel <- match.fun(diag.panel)
    if (row1attop) {
      tmp <- lower.panel
      lower.panel <- upper.panel
      upper.panel <- tmp
      tmp <- has.lower
      has.lower <- has.upper
      has.upper <- tmp
    }
    nc <- ncol(x)
    if (nc < 2) 
      stop("only one column in the argument to 'pairs'")
    has.labs <- TRUE
    if (missing(labels)) {
      labels <- colnames(x)
      if (is.null(labels)) 
        labels <- paste("var", 1L:nc)
    }
    else if (is.null(labels)) 
      has.labs <- FALSE
    oma <- if ("oma" %in% nmdots) 
      dots$oma
    else NULL
    main <- if ("main" %in% nmdots) 
      dots$main
    else NULL
    if (is.null(oma)) {
      oma <- c(4, 4, 4, 4)
      if (!is.null(main)) 
        oma[3L] <- 6
    }
    opar <- par(mfrow = c(nc, nc), mar = rep.int(gap/2, 4), oma = oma)
    on.exit(par(opar))
    dev.hold()
    on.exit(dev.flush(), add = TRUE)
    for (i in if (row1attop) 
      1L:nc
         else nc:1L) for (j in 1L:nc) {
           localPlot(x[, j], x[, i], xlab = '', ylab = "", axes = FALSE, 
                     type = "n", ...)
           if (i == j || (i < j && has.lower) || (i > j && has.upper)) {
             box()
             # edited here...
             #           if (i == 1 && (!(j%%2) || !has.upper || !has.lower)) 
             #           localAxis(1 + 2 * row1attop, x[, j], x[, i], 
             #                       ...)
             # draw x-axis
             if (i == nc & j != nc) 
               localAxis(1, x[, j], x[, i],
                                         ...)
             # draw y-axis
             if (j == 1 & i != 1) 
               localAxis(2, x[, j], x[, i], ...)
             #           if (j == nc && (i%%2 || !has.upper || !has.lower)) 
             #             localAxis(4, x[, j], x[, i], ...)
             mfg <- par("mfg")
             if (i == j) {
               if (has.diag) 
                 localDiagPanel(as.vector(x[, i]), ...)
               if (has.labs) {
                 par(usr = c(0, 1, 0, 1))
                 if (is.null(cex.labels)) {
                   l.wid <- strwidth(labels, "user")
                   cex.labels <- max(0.8, min(2, 0.9/max(l.wid)))
                 }
                 text.panel(0.5, label.pos, labels[i], cex = cex.labels, 
                            font = font.labels)
               }
             }
             else if (i < j) 
               localLowerPanel(as.vector(x[, j]), as.vector(x[, 
                                                              i]), ...)
             else localUpperPanel(as.vector(x[, j]), as.vector(x[, 
                                                                 i]), ...)
             if (any(par("mfg") != mfg)) 
               stop("the 'panel' function made a new plot")
           }
           else par(new = FALSE)
         }
    if (!is.null(main)) {
      font.main <- if ("font.main" %in% nmdots) 
        dots$font.main
      else par("font.main")
      cex.main <- if ("cex.main" %in% nmdots) 
        dots$cex.main
      else par("cex.main")
      mtext(main, 3, 3, TRUE, 0.5, cex = cex.main, font = font.main)
    }
    invisible(NULL)
  }


## create histograms on the diagonal
panel.hist <- function(x, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(usr[1:2], 0, 1.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, col = "grey", ...)
}

## create loess smoothers for strong correlations
panel.smooth2<-function (x, y, col = par("col"), bg = alpha('grey',0.5), pch = 21, 
    cex = 1,  span = 2/3, iter = 3, ...) 
{
    points(x, y, pch = pch, col = col, bg = bg, cex = cex)
    ok <- is.finite(x) & is.finite(y)
    if(abs(cor(x,y))>0.5) {col.smooth='red'} else {col.smooth='black'}
        lines(stats::lowess(x[ok], y[ok], f = span, iter = iter), 
            col = col.smooth, lwd=1.5, ...)
    }
 
## annotate pearson correlations
panel.cor <- function(x, y, digits=2, prefix="", cex.cor) 
{
    usr <- par("usr"); on.exit(par(usr)) 
    par(usr = c(0, 1, 0, 1)) 
    r <- abs(cor(x, y)) 
    txt <- format(c(r, 0.123456789), digits=digits)[1] 
    txt <- paste(prefix, txt, sep="") 
    if(missing(cex.cor)) cex <- 0.8/strwidth(txt) 
 
    test <- cor.test(x,y) 
    # # borrowed from printCoefmat
    # Signif <- symnum(test$p.value, corr = FALSE, na = FALSE, 
    #               cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1),
    #               symbols = c("***", "**", "*", ".", " ")) 
 
    text(0.5, 0.5, txt, cex = cex * r,  col = 'red') 
    # text(.8, .8, Signif, cex=cex, col=2) 
}
