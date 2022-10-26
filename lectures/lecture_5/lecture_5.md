
```{raw-cell}

---
title: Spatial modelling
author: David Orme
---
```

<!-- .slide: data-background-image="../shared_images/World3D_600.png"  data-background-position="right 10px bottom 20px"  data-background-size="40%" -->
# Spatial modelling

### David Orme

---

# Spatial modelling tools

* The examples presented here use R
* Another excellent program with a nice GUI interface:
    * Spatial Analysis in Macroecology
    * http://www.ecoevol.ufg.br/sam/

![Samlogo](Images/samlogo.jpg)<!-- .element width="30%" -->

---

# Overview

* Example data: Afrotropical bird diversity
* Naive models
* Describing spatial autocorrelation
* Accounting for spatial autocorrelation

```{code-cell} r
:name: load_birds
:tags: [remove_input]


    suppressPackageStartupMessages(library(sp))
    suppressPackageStartupMessages(library(spdep))
    suppressPackageStartupMessages(library(spatialreg))
    suppressPackageStartupMessages(library(mgcv)) # for GAM
    suppressPackageStartupMessages(library(ncf)) # for correlog
    suppressPackageStartupMessages(library(gstat)) # for variogram
    suppressPackageStartupMessages(library(nlme)) # for gls
    suppressPackageStartupMessages(library(spgwr)) # for gwr
    suppressPackageStartupMessages(library(knitr)) # for kable
    suppressPackageStartupMessages(library(sjPlot)) # for tab_model display
    suppressPackageStartupMessages(library(stargazer)) # for tab_model display
    suppressPackageStartupMessages(library(SpatialPack)) # for clifford t test
    
    suppressPackageStartupMessages(library(hexbin))
    suppressPackageStartupMessages(library(lattice))
    
    load('../../data/spatial_models/SpatialDataExample.rda')
    
    # getting a theme with less padding at the sides
    theme.loPadding <-
        list(layout.heights = list(top.padding = 0.5, main.key.padding = 0.5, 
                 key.axis.padding = 0.5, axis.xlab.padding = 0.5, xlab.key.padding = 0.5, 
                 key.sub.padding = 0.5, bottom.padding = 0.3),
             layout.widths = list(left.padding = 0.5, key.ylab.padding = 0.5,
                 ylab.axis.padding = 0.5, axis.key.padding = 0.5, right.padding = 0.5), 
             lwd=2, cex=2)
```

---

# Afrotropical bird species richness

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=24]'
:name: bird_rich
:tags: [remove_input]


    brpal <- hcl.colors(20, 'Blue-Red')

    spplot(figDat, 'Rich', col.regions=brpal, scales=list(cex=1, draw=TRUE), 
           par.settings=theme.loPadding)
```

Notes:
Introducing the data
Projected data - coordinates in km on Behrmann grid
100km resolution

----

# Explanatory variables

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=24]'
:fig.width: 12
:name: bird_rich_pred
:tags: [remove_input]


    panelFun <- function(x,y,...){
        panel.xyplot(x,y,...)
        panel.loess(x,y,col.line='black',...)
    }
    
    print(spplot(figDat, 'MeanAET', col.regions=brpal, 
            main='Actual Evapotranspiration (AET)',  par.settings=theme.loPadding),
        split=c(1,1,3,2), more=TRUE)
    print(xyplot(Rich ~ MeanAET, data=figDat@data, 
            panel= panelFun,  par.settings=theme.loPadding), 
        split=c(1,2,3,2), more=TRUE)
    print(spplot(figDat, 'MeanAnnTemp', col.regions=brpal, 
            main='Mean Annual Temperature',  par.settings=theme.loPadding), 
        split=c(2,1,3,2), more=TRUE)
    print(xyplot(Rich ~ MeanAnnTemp, data=figDat@data,
            panel= panelFun,  par.settings=theme.loPadding), 
        split=c(2,2,3,2), more=TRUE)
    print(spplot(figDat, 'MeanElev', col.regions=brpal, 
            main='Mean Elevation',  par.settings=theme.loPadding), 
        split=c(3,1,3,2), more=TRUE)
    print(xyplot(Rich ~ MeanElev, data=figDat@data, 
            panel= panelFun,  par.settings=theme.loPadding),
        split=c(3,2,3,2))
```

Notes:
A few simple observations:
- lots of rain and vegetation in the congo.
- pretty warm in the sahara
- the great rift is called that for a reason.

Smoothers on the data
- No way you’d want to fit this as a simple linear model

----

# A simple linear model

**Richness ~ AET + Temperature + Elevation**

```{code-cell} r
:name: simple_lm
:results: asis
:tags: [remove_input]


    simpleLM <- lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat)
    
    cf <- data.frame(coef(summary(simpleLM)))
    colnames(cf) <- c('Est','SE','t', 'p')
    cf$p <- ifelse(cf$p >= 0.001, cf$p, '< 0.001')
    print(kable(cf, digits=2))
```

----

# A simple GAM

**Richness ~ s(AET) +s( Temperature) + s(Elevation)**

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=20]'
:fig.height: 5
:fig.width: 12
:name: simple_glm
:tags: [remove_input]


    simpleGAM <- gam(Rich ~ s(MeanAET) + s(MeanAnnTemp) + s(MeanElev), data=figDat)
    
    par(mfrow=c(1,3), mar=c(3,3,1,1), mgp=c(2,0.8,0))
    plot(simpleGAM)
    
    # kable(summary(simpleGAM)$s.table)
```

----

# Model predictions

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=24]'
:fig.height: 6
:fig.width: 14
:name: simple_pred
:tags: [remove_input]


    figDat$simpleLM.pred <- predict(simpleLM)
    figDat$simpleGAM.pred <- predict(simpleGAM)
    
    atRich <- seq(0,700, length=21)
    print(spplot(figDat, 'simpleLM.pred', col.regions=brpal, at=atRich, 
                 main='Linear Model (r2 = 0.45)',  par.settings=theme.loPadding), 
          split=c(1,1,3,1), more=TRUE)
    print(spplot(figDat, 'Rich', col.regions=brpal, at=atRich, 
                 main='Observed richness',  par.settings=theme.loPadding), 
          split=c(2,1,3,1), more=TRUE)
    print(spplot(figDat, 'simpleGAM.pred', col.regions=brpal, 
                 at=atRich, main='GAM (r2 = 0.57)',  par.settings=theme.loPadding), 
          split=c(3,1,3,1))
```

Notes:
Not great models:
 - Overpredict in Madagascar
 - GAM does better in Congo

OK - so what is the problem?

---

+++

# Neighbourhoods

```{code-cell} r
:name: nb_setup
:tags: [remove_input]


    # Setup for the next few slides
    n <- 6
    box <- st_polygon(list(matrix(c(0,0,0,n,n,n,n,0,0,0), byrow=TRUE, ncol=2)))
    box_cells <- st_make_grid(box, cellsize=1, what='centers')
    box_cells_sp <- as(box_cells, 'Spatial')
    
    # Rook and Queen
    rook <- cell2nb(n,n)
    queen <- cell2nb(n,n, 'queen')
    knn <- knearneigh(box_cells_sp, k=8)
    dnn <- dnearneigh(box_cells_sp, 0, 2.4)
    
    
    nb_plotter <- function(nb1_idx, nb2_idx, pts=c(1,19), cex=3){
    
        plot(box_cells, type='n')
    
        # Draw lines connecting points 1 and 2 to neighbours
        nb1 <-  box_cells[nb1_idx]
        nb2 <-  box_cells[nb2_idx]
        pt1 <- box_cells[pts[1]]
        pt2 <- box_cells[pts[2]]
        
        for(row in nb1){
            lines(rbind(st_coordinates(pt1), st_coordinates(row)))
        }
        
        for(row in nb2){
            lines(rbind(st_coordinates(pt2), st_coordinates(row)))
        }
        
        plot(box_cells, add=TRUE, cex=cex, lwd=3)
        plot(box_cells[pts], add=TRUE, col='red', pch=20, cex=cex)
        plot(nb1, add=TRUE, col='darkgreen', pch=20, cex=cex)
        plot(nb2, add=TRUE, col='darkgreen', pch=20, cex=cex)
    }
```

<div class='container'>
<div class='col2'>

```{code-cell} r
:name: nb_rook
:tags: [remove_input]


    nb_plotter(rook[[1]], rook[[29]], c(1,29))
```

</div>
<div class='col1'>

**Rooks move**

All cells within one step: 

* vertically or
* horizontally

</div>
</div>

Notes:
Neighbours on a grid
Bit different for polygons, shared edges etc. but similar concepts

----

# Neighbourhoods

+++

<div class='container'>
<div class='col2'>

```{code-cell} r
:name: nb_queen
:tags: [remove_input]


    nb_plotter(queen[[1]], queen[[29]], c(1,29))
```

</div>
<div class='col1'>

**Queens move**

All cells within one step:

* vertically,
* horizontally or
* diagonally

</div>
</div>

+++

----

# Neighbourhoods

<div class='container'>
<div class='col2'>

```{code-cell} r
:name: nb_dnn
:tags: [remove_input]


nb_plotter(dnn[[1]], dnn[[29]], c(1,29))
```

</div>
<div class='col1'>

**Distance based**

All cells within:

* 2.4 units

</div>
</div>

+++

----

# Neighbourhoods

+++

<div class='container'>
<div class='col2'>

```{code-cell} r
:name: nb_knn
:tags: [remove_input]


nb_plotter(knn$nn[1,], knn$nn[29,], pts=c(1,29))
```

</div>
<div class='col1'>

**_k_ nearest**

The closest _k_ cells

+++

</div>
</div>

----

# Spatial autocorrelation

<div class='container'>
<div class='col2'>

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=24]'
:name: moran_real
:tags: [remove_input]


    figDat.nb <- knn2nb( knearneigh(figDat, k=8))
    figDat.lw <- nb2listw(figDat.nb)
    figDatCoords <- as.data.frame(coordinates(figDat))
    globalMoranRich <- moran.test(figDat$Rich, figDat.lw)
    globalGearyRich <- geary.test(figDat$Rich, figDat.lw)

    spplot(figDat, 'Rich', col.regions=brpal, scales=list(cex=1, draw=TRUE), 
           par.settings=theme.loPadding)
```

</div>
<div class='col1 leftpad'>

Global Moran’s I 

* I = `r sprintf('%0.3f', globalMoranRich$estimate[1])`
* p << 0.001

<div class='vs'></div>

Global Geary’s C 

* C = `r sprintf('%0.3f', globalGearyRich$estimate[1])`
* p << 0.001

</div>
</div>

Notes:
Point close together are similar
 - how do we characterise this?
 - useful summary - global value
 - is there spatial autocorrelation - well, duh!

 Moran’s I - correlation measure (usually 0 to 1)
 Geary's C - 1 to 0

----

# Spatial autocorrelation

<div class='container'>
<div class='col2'>

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=24]'
:name: moran_rand
:tags: [remove_input]


    figDat$randRich <- sample(figDat$Rich)
    globalMoranRandRich <- moran.test(figDat$randRich, figDat.lw)
    globalGearyRandRich <- geary.test(figDat$randRich, figDat.lw)
	
    spplot(figDat, 'randRich', col.regions=brpal, 
          scales=list(draw=TRUE), par.settings=theme.loPadding)
```

</div>
<div class='col1 leftpad'>

Global Moran’s I

* I = `r sprintf('%0.3f', globalMoranRandRich$estimate[1])`
* p =  `r sprintf('%0.3f', globalMoranRandRich$p)`

<div class='vs'></div>

Global Geary’s C 

* C = `r sprintf('%0.3f', globalGearyRandRich$estimate[1])`
* p =  `r sprintf('%0.3f', globalGearyRandRich$p)`

</div>
</div>

----

# Local autocorrelation
 
Local indicators of spatial autocorrelation (LISA)

`````{code-cell} r
:fig.height: 6
:fig.width: 12
:name: lisa
:tags: [remove_input]


    richLISA <- localmoran(figDat$Rich, figDat.lw)
    figDat$richLISA.I <- richLISA[,1]
    figDat$richLISA.Z <- richLISA[,4]
    
    print(spplot(figDat, 'richLISA.I', col.regions=heat.colors(20), at=quantile(figDat$richLISA.I, 
                 at=seq(0,1,by=0.05)), main="Local Moran's I",  par.settings=theme.loPadding),
          split=c(1,1,2,1), more=TRUE)
    print(spplot(figDat, 'richLISA.Z', col.regions=c('blue','grey20',heat.colors(20)), 
                 at=c(-5, qnorm(0.025), seq(qnorm(0.975), 30, length=21)), 
                 main='Z value', par.settings=theme.loPadding), 
          split=c(2,1,2,1))

 ```
 
 Notes:
 Look at strength of spatial autocorrelation within neighbourhoods
 Using species richness data
 Blocks of colour show significant autocorrelation
 Not a monotonic process - will return to this later
 
---

# Effects of Spatial Autocorrelation
 
* Data points **not independent**
* Degrees of freedom reduced: 
    * **standard errors and significance testing affected**
* Not equally weighted :
    * **parameter estimation affected**

Notes:
Degrees of freedom - tends to bias towards finding significance
Parameters - can affect estimates in unpredictable ways

----

# Dealing with Spatial Autocorrelation

* Modify the degrees of freedom in significance testing
* Account for autocorrelation in models:
	* Simultaneous autoregressive models
	* Generalised least squares
	* Eigenvector filtering
	* Geographically weighted regression

----

# Degrees of freedom correction 


```{r clifford_t_pre, echo=FALSE, cache=TRUE, fig.width=12, fig.height=6}

    tempCliff <- modified.ttest(figDat$Rich, figDat$MeanAnnTemp, coordinates(figDat))
    aetCliff <- modified.ttest(figDat$Rich, figDat$MeanAET, coordinates(figDat))
    elevCliff <- modified.ttest(figDat$Rich, figDat$MeanElev, coordinates(figDat))
    
    print(spplot(figDat, 'Rich', col.regions=brpal, 
                 par.settings=theme.loPadding, colorkey=NULL, main='Richness'), 
          split=c(1,2,4,2), more=TRUE)
    print(spplot(figDat, 'MeanAET', col.regions=brpal, 
                 main='AET',  par.settings=theme.loPadding, colorkey=NULL), 
          split=c(2,1,4,2), more=TRUE)
    print(hexbinplot(Rich ~ MeanAET, data=figDat@data, asp=1, colramp=hcl.colors,
                     par.settings=theme.loPadding, scales=list(draw=FALSE), colorkey=FALSE), 
          split=c(2,2,4,2), more=TRUE)
    
    print(spplot(figDat, 'MeanAnnTemp', col.regions=brpal, 
                 main='Temperature',  par.settings=theme.loPadding, colorkey=NULL), 
          split=c(3,1,4,2), more=TRUE)
    print(hexbinplot(Rich ~ MeanAnnTemp, data=figDat@data,  asp=1, colramp=hcl.colors,
                     par.settings=theme.loPadding, scales=list(draw=FALSE), colorkey=FALSE), 
          split=c(3,2,4,2), more=TRUE)
    
    print(spplot(figDat, 'MeanElev', col.regions=brpal, 
                 main='Elevation',  par.settings=theme.loPadding, colorkey=NULL), 
          split=c(4,1,4,2), more=TRUE)
    print(hexbinplot(Rich ~ MeanElev, data=figDat@data, asp=1, colramp=hcl.colors,
                     par.settings=theme.loPadding, scales=list(draw=FALSE), colorkey=FALSE),
          split=c(4,2,4,2))

````

Notes:
Clifford test for correlation
 - use all the lags to characterise the global autocorrelation
 - work out the effective degrees of freedom
 - 2484 down to...

Other methods can correct the degrees of freedom in a simple linear model

----

# Degrees of freedom correction 


```{r clifford_t, echo=FALSE, cache=TRUE, fig.width=12, fig.height=6}

    
    add_r <- function(test, ...){
        trellis.focus("toplevel")
        text <- sprintf('r = %0.3f\nn= %0.2f\np=%0.3f', 
                        test$corr, test$ESS, test$p.value)
        panel.text(0.5, 0.5, text, ...)
        trellis.unfocus()
    }
    
	fadedramp <- function(n){ grey(seq(0.7, 0.9, length=n))}
	
    print(spplot(figDat, 'Rich', col.regions=brpal, 
                 par.settings=theme.loPadding, colorkey=NULL, main='Richness'), 
          split=c(1,2,4,2), more=TRUE)
    print(spplot(figDat, 'MeanAET', col.regions=brpal, 
                 main='AET',  par.settings=theme.loPadding, colorkey=NULL), 
          split=c(2,1,4,2), more=TRUE)
    print(hexbinplot(Rich ~ MeanAET, data=figDat@data, asp=1, colramp=fadedramp,
                     par.settings=theme.loPadding, scales=list(draw=FALSE), colorkey=FALSE), 
          split=c(2,2,4,2), more=TRUE)
    
    add_r(aetCliff, cex=2.5)
    
    print(spplot(figDat, 'MeanAnnTemp', col.regions=brpal, 
                 main='Temperature',  par.settings=theme.loPadding, colorkey=NULL), 
          split=c(3,1,4,2), more=TRUE)
    print(hexbinplot(Rich ~ MeanAnnTemp, data=figDat@data,  asp=1, colramp=fadedramp,
                     par.settings=theme.loPadding, scales=list(draw=FALSE), colorkey=FALSE), 
          split=c(3,2,4,2), more=TRUE)
    
    add_r(tempCliff, cex=2.5)
    
    print(spplot(figDat, 'MeanElev', col.regions=brpal, 
                 main='Elevation',  par.settings=theme.loPadding, colorkey=NULL), 
          split=c(4,1,4,2), more=TRUE)
    print(hexbinplot(Rich ~ MeanElev, data=figDat@data, asp=1, colramp=fadedramp,
                     par.settings=theme.loPadding, scales=list(draw=FALSE), colorkey=FALSE),
          split=c(4,2,4,2))
    
    add_r(elevCliff, cex=2.5)

````

Notes:
Clifford test for correlation
 - use all the lags to characterise the global autocorrelation
 - work out the effective degrees of freedom
 - 2484 down to...

Other methods can correct the degrees of freedom in a simple linear model

----

# Spatial Autoregression

Solve for $b$:


| <span class='dot'></span>  | <span class='dot'></span>  | <span class='dot'></span>  | <span class='dot'></span>  |   |
|---|---|---|---|:---:|
| <span class='dotr'></span>	| <span class='dotg'></span>	| <span class='dot'></span>	| <span class='dot'></span> | $bx_1 +  \frac{1}{2}bx_2$  |
| <span class='dotg'></span>	| <span class='dotr'></span>	| <span class='dotg'></span>	| <span class='dot'></span> | $\frac{1}{2}bx_1 +  bx_2  + \frac{1}{2}bx_3$ |
| <span class='dot'></span>	| <span class='dotg'></span>	| <span class='dotr'></span>	| <span class='dotg'></span> | $\frac{1}{2}bx_2 +  bx_3  + bx_4$  |
| <span class='dot'></span>	| <span class='dot'></span>	| <span class='dotg'></span>	| <span class='dotr'></span> | $\frac{1}{2}bx_3 +  bx_4$  |
| $x_1$  |  $x_1$ |  $x_3$ |  $x_4$  |   |

Notes:
Simple one dimensional example
- neighbour definition and _weights_ (red=1, green=0.5)
- influence of neighbouring values
- simultaneuous equations.

----

# Spatial Autoregresssion

```{r sarlm_fit, echo=FALSE, cache=TRUE}

    # rescaling variables to allow convergence
    scaledExpl <- as.data.frame(scale(figDat@data[,c('MeanAET','MeanAnnTemp','MeanElev')]))
    figDat$MeanAETScaled <- scaledExpl$MeanAET
    figDat$MeanAnnTempScaled <- scaledExpl$MeanAnnTemp
    figDat$MeanElevScaled <- scaledExpl$MeanElev

    # SAR
    figDatSARlag <- lagsarlm(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled,
                             data=figDat@data, figDat.lw, type='lag')

    # Correlogram
    figDatSARlagCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr,
                                   z=residuals(figDatSARlag), na.rm=TRUE, increment=100, resamp=1)
`````

```{code-cell} r
:cache: true
:name: sarlm_plot
:tags: [remove_input]


    plot.correlog <- function (x, ...){ # replacement for ncf version that handles '...'
        obj <- x
        plot(obj$mean.of.class, obj$correlation, ylab = "correlation", 
            xlab = "distance (mean-of-class)", ...)
        lines(obj$mean.of.class, obj$correlation)
        if (!is.null(obj$p)) {
            points(obj$mean.of.class[obj$p < 0.025], obj$correlation[obj$p < 
                0.025], pch = 21, bg = "black")
        }
    }

    panel.correl <- function(x,y,...){
        panel.xyplot(x,y, type='l', ...)
        panel.xyplot(x,y)
        panel.abline(h=0, lty=2)
    }
    
    figDat$SARlagPred <- suppressMessages(predict(figDatSARlag))
    
    print(spplot(figDat, 'SARlagPred', col.regions=heat.colors(20), at=seq(0,700, length=21), 
          main='Predicted richness'), split=c(1,1,2,2), more=TRUE)
    print(with(figDat@data, 
               xyplot(SARlagPred ~ Rich, 
                      panel=function(x,y,...){
                              panel.xyplot(x,y)
                              panel.abline(a=0,b=1)
                              },
                      ylab = 'Predicted', xlab='Observed', par.settings=theme.loPadding)), 
          split=c(1,2,2,2), more=TRUE)
    print(with(richCorrel, 
               xyplot(correlation ~ mean.of.class, panel=panel.correl, xlim=c(0,6000), ylim=c(-0.3,0.8), 
                      xlab = 'Distance (km)', ylab='Correlation', par.settings=theme.loPadding,
                      main='Autocorrelation in richness')),
          split=c(2,1,2,2), more=TRUE)
    print(with(figDatSARlagCorrel, 
               xyplot(correlation ~ mean.of.class, panel=panel.correl, xlim=c(0,6000), ylim=c(-0.3,0.8), 
                       xlab = 'Distance (km)', ylab='Correlation', par.settings=theme.loPadding,
                       main='Residual autocorrelation')), 
          split=c(2,2,2,2))
```

Notes:
Very good predictions - not even including interactions!
Autocorrelation in the residuals are very small

+++

----

# Correlogram

```{code-cell} r
:cache: true
:dev.args: '#R_CODE#[pointsize=24]'
:fig.height: 6
:fig.width: 12
:name: correlogram
:tags: [remove_input]


    richCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, 
                           figDat$Rich, increment=100, resamp=1)
    par(mfrow=c(1,2), mar=c(3,3,1,1), mgp=c(2,0.8,0), cex=1.2)
    with(richCorrel, plot(mean.of.class, n, xlab='Distance (km)', ylab='Count'))
    with(richCorrel, plot(mean.of.class, correlation, xlab='Distance (km)', 
                          ylab='Correlation', pch=21)) 
    abline(h=0)
```

Notes:
Correlograms

2484 points
	2484*2483/2 = 3083886 pairwise distances
	distance falling into 100km bands

Distance at which correlation hits the x axis
Notice negative autocorrelation at distance
Reliability of measures at distance is very poor

----

# Variogram

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=24]'
:fig.height: 6
:fig.width: 12
:name: variogram
:tags: [remove_input]


    richVariog <- variogram(list(figDat$Rich), list(coordinates(figDat)), width=100, cutoff=8500)
    par(mfrow=c(1,2), mar=c(3,3,1,1), mgp=c(2,0.8,0), cex=1.2)
    with(richVariog, plot(dist, np, xlab='Distance (km)', ylab='Count'))
    with(richVariog, plot(dist, gamma, xlab='Distance (km)', ylab='Semivariance', pch=21))
    abline(h=0)
```

Notes:
Variograms
 - same idea but viewed from other end
 - if points are similar then the variance within nearby classes will be small
 - eventually get to a point where the variance is not distinguishably lower
 - about in the same place

----

# Generalised Least Squares

<div class='container'>
<div class='col1'>

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=24]'
:fig.height: 6
:fig.width: 6
:name: gls1
:tags: [remove_input]


    par(mar=c(3,3,1,1), mgp=c(2,0.8,0))
    with(richVariog, plot(dist, gamma, xlab='Distance (km)', ylab='Semivariance', pch=21))
```

</div>
<div class='col1'>

* Model correlation as a function of **distance** 
* Generate a correlation **matrix**

</div>
</div>

+++

Notes:
Not specifically a spatial method
 - allows for all sorts of structure in the data
 - mixed effects models
 - variance structures
 - correlation structure

Wider range of variance modelling
- define a function that captures the shape of the variogram with distance
- exponential, spherical, linear
- parameters: nugget, sill, range

```{code-cell} r
:cache: true
:name: gls_setup
:tags: [remove_input]

	
    simpleGLS <- gls(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled, data=figDat)
	
    # Gaussian
    glsGauss <- update(simpleGLS,  corr=corGaus(c(650), 
					   form=~e_centre_behr+n_centre_behr, fixed=TRUE, nugget=TRUE))
    glsGaussVar <- Variogram(glsGauss)	
```

----

# Generalised Least Squares

<div class='container'>
<div class='col2'>

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=24]'
:fig.height: 6
:fig.width: 6
:name: gls2
:tags: [remove_input]


    par(mar=c(3,3,1,1), mgp=c(2,0.8,0))
    plot(variog ~ dist, data=glsGaussVar, xlim=c(0,7000), ylim=c(0,1.3), cex=1.2, 
         xlab='Distance (km)', ylab='Semivariance')
    lines(variog ~ dist, data=attr(glsGaussVar, 'modelVariog'), lwd=3, col='red')

    arrows(0,0.1,2000,0.1, col='blue', code=0, lwd=3)
    text(1000,0.04, 'Nugget', col='blue')
    arrows(650, 0.6, 650, 1.2, col='forestgreen', code=0, lwd=3)
    text(700, 1.2, 'Range', col='forestgreen', adj=c(0,1))
    arrows(5000, 0, 5000, 1, col='orange', code=3, lwd=3)
    text(6000, 0.5, 'Sill', col='orange')
```

</div>
<div class='col1'>

* Different shapes:
    * Exponential
    * Spherical
    * Linear

* Parameters

</div>
</div>

----

# Generalised Least Squares

<small>

```{code-cell} r
:name: gls_output
:results: asis
:tags: [remove_input]


    # output model description avoiding reveal code box
    xx <- capture.output(summary(glsGauss))
    cat(paste(c('<pre>', xx, '</pre>')), collapse="", sep='\n')
    # cat(xx, sep='</br>')
```

<!-- .element width="100%" -->

</small>

---

# Stationarity and isotropy

<div class='leftpad'>
	
Is the same process happening in:

* different locations (stationarity)?
* different directions (isotropy)?

<div class='vs'>
Is the problem in:

* the spatial structure of autocorrelation?
* differences in the actual relationship?

</div>

----

# Eigenvector filtering

* Take the **eigendecomposition** of a spatial weights model
* Use the  **eigenvectors** as variables in the model
* Use a selection process to identify and include only important eigenvectors

Notes:
* Identical process to principal component analysis
* Eigenvectors identify independent axes of variation in the model
* Separate out aspects of autocorrelation
* Tailor the autocorrelation
* Each eigenvector soaks up a residual degree of freedom

----

# Eigenvector filtering

```{code-cell} r
:cache: true
:name: eigen_setup
:tags: [remove_input]


    Wmat <- listw2mat(figDat.lw)
    n <- ncol(Wmat)
    Cent <- diag(n) - (matrix(1, n, n)/n)
    eV <- eigen(Cent %*% Wmat %*% Cent, EISPACK = TRUE)$vectors

    figDat$spEV1 <- eV[,1]
    figDat$spEV2 <- eV[,2]
    figDat$spEV3 <- eV[,3]
    figDat$spEV4 <- eV[,4]
```

```{code-cell} r
:name: eigen_plot
:tags: [remove_input]


    print(spplot(figDat, 'spEV1', col.regions=heat.colors(20), main='EV1',
          par.settings=theme.loPadding), split=c(1,1,2,2), more=TRUE)
    print(spplot(figDat, 'spEV2', col.regions=heat.colors(20),  main='EV2',
          par.settings=theme.loPadding), split=c(2,1,2,2), more=TRUE)
    print(spplot(figDat, 'spEV3', col.regions=heat.colors(20),  main='EV3',
          par.settings=theme.loPadding), split=c(1,2,2,2), more=TRUE)
    print(spplot(figDat, 'spEV4', col.regions=heat.colors(20),  main='EV4',
          par.settings=theme.loPadding), split=c(2,2,2,2))
```

Notes:
First four eigenvectors
 - describe independent trends in the spatial autocorrelation
 - (actually real parts of complex eigenvectors)

----

# Eigenvector filtering

<div class='leftpad'>

**lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev**

</div>

<small>

```{code-cell} r
:name: simple_lm_reprise
:results: asis
:tags: [remove_input]



    cf <- data.frame(coef(summary(simpleLM)))
    colnames(cf) <- c('Est','SE','t', 'p')
    cf$p <- ifelse(cf$p >= 0.001, format(cf$p, digits=2), '< 0.001')
    print(kable(cf, digits=2))
```

</small>

+++

----

# Eigenvector filtering

<div class='leftpad'>

**lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev + Re(spEV1) + Re(spEV2) + Re(spEV3) + Re(spEV4)**

</div>

<small>

```{code-cell} r
:name: eigen_mod1
:results: asis
:tags: [remove_input]


    badEV1 <- lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev + Re(spEV1) + Re(spEV2) +
                        Re(spEV3) + Re(spEV4) , data=figDat@data)

    cf <- data.frame(coef(summary(badEV1)))
    colnames(cf) <- c('Est','SE','t', 'p')
    cf$p <- ifelse(cf$p >= 0.001, format(cf$p, digits=2), '< 0.001')
    print(kable(cf, digits=2))

```

</small>

----

# Eigenvector filtering

<div class='leftpad'>

**lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev + Re(spEV1) + Re(spEV2) + Re(spEV3)**

</div>

<small>

```{code-cell} r
:name: eigen_mod2
:results: asis
:tags: [remove_input]


    badEV2 <- lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev + Re(spEV1) + 
                        Re(spEV2) + Re(spEV3) , data=figDat@data)

    cf <- data.frame(coef(summary(badEV2)))
    colnames(cf) <- c('Est','SE','t', 'p')
    cf$p <- ifelse(cf$p >= 0.001, format(cf$p, digits=2), '< 0.001')
    print(kable(cf, digits=2))

```

</small>

----

# Geographically weighted regression

Fit a model for **every cell**:

* Define a local **region size** and a **weighting function**
* Fit a weighted regression for each cell using the weights
* Look at how coefficients **vary in space**
* Possibly serious statistical issues!

----

# Geographically weighted regression

```{code-cell} r
:cache: true
:name: gwr_setup
:tags: [remove_input]


    # ~ 130 seconds
	suppressWarnings(
        simpleGWR.se <- gwr(Rich ~ MeanAET + MeanAnnTemp + MeanElev, 
                            data=figDat, adapt=0.05, se.fit=TRUE)
	)

    simpleGWR.data <- simpleGWR.se$SDF
    gwrCoords <- coordinates(simpleGWR.data)
    gwrDat <- SpatialPixelsDataFrame(gwrCoords, data=simpleGWR.data@data, tolerance=0.01)

    colScheme <- function(dat, var, n2=20){

        est <- dat@data[, var]
        # se <- dat@data[, paste(var, 'se', sep='_')]
        n <- dat@data[,'sum.w']
    
        estR <- range(est)
        absMax <- max(abs(estR))
    
        pos <- pretty(c(0, absMax), n=n2)
        neg <- rev(-pos)
    
        scale <- c(neg, pos[-1])
        # cols <- hcl(h=seq(2/3*360, 0.0,length=length(scale)), l=65, c=100)
        # cols <- rev(rainbow(n=length(scale), end=2/3))
        cols <- hcl.colors(n=length(scale), palette = "viridis")
        return(list(at=scale,col.regions=cols))
    }
```

```{code-cell} r
:dev.args: '#R_CODE#[pointsize=24]'
:fig.height: 8
:fig.width: 12
:name: gwr_pred
:tags: [remove_input]


    print(spplot(figDat, 'MeanAET', col.regions=brpal, main='AET', 
          par.settings=theme.loPadding), split=c(1,1,3,2), more=TRUE)
    currCols <- colScheme(gwrDat, 'MeanAET')
    print(spplot(gwrDat, 'MeanAET', at=currCols$at, col.regions=currCols$col.regions, main='AET slope'), 
          split=c(1,2,3,2), more=TRUE)
    
    print(spplot(figDat, 'MeanAnnTemp', col.regions=brpal, main='Temperature', 
          par.settings=theme.loPadding), split=c(2,1,3,2), more=TRUE)
    currCols <- colScheme(gwrDat, 'MeanAnnTemp')
    print(spplot(gwrDat, 'MeanAnnTemp', at=currCols$at, col.regions=currCols$col.regions, main='Temp slope'), 
          split=c(2,2,3,2), more=TRUE)

    print(spplot(figDat, 'MeanElev', col.regions=brpal,main='Elevation', 
          par.settings=theme.loPadding), split=c(3,1,3,2), more=TRUE)
    currCols <- colScheme(gwrDat, 'MeanElev')
    print(spplot(gwrDat, 'MeanElev', at=currCols$at, col.regions=currCols$col.regions, main='Elev slope'), 
          split=c(3,2,3,2))
```

Notes:
Fit a weighted regression to geographic subsets of the data.

Neighbourhood size
 - bandwidth or proportion of data
Weighting
 - weighted by normal Gaussian curve (black)
 - weighted based on squared distance

Not fitting a single regression - fitting 2484 regressions - but they are simple

----

+++

# Geographically weighted regression
 
 ```{r gwr_rsq, echo=FALSE, dev.args=list(pointsize=24)}

    spplot(gwrDat, 'localR2', at=seq(0,1,length=41), col.regions=hcl.colors(40), 
           main=expression(Local~~GWR~r^2))

```

---

# Problems

* Profusion of packages: sf, sp, spdep, mgcv, ncf, gstat, nlme, spgwr
* Different data structures
* Sometimes poor documentation
* Speed of calculation (= size of dataset)
* Memory hungry
* Too many options
