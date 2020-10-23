library(sp)
library(spdep)
library(mgcv) # for GAM
library(ncf) # for correlog
library(gstat) # for variogram
library(nlme) # for gls
library(spgwr) # for gwr

# load the example data as a sp package SpatialPixelsDataFrame

load(file='SpatialDataExample.rda')

# data plots

    # getting a lattice graphics theme with less padding at the sides
    theme.loPadding <-
        list(layout.heights = list(top.padding = 0.5, main.key.padding = 0.5, 
              key.axis.padding = 0.5, axis.xlab.padding = 0.5, xlab.key.padding = 0.5, 
              key.sub.padding = 0.5, bottom.padding = 0.3),
             layout.widths = list(left.padding = 0.5, key.ylab.padding = 0.5,
              ylab.axis.padding = 0.5, axis.key.padding = 0.5, right.padding = 0.5), lwd=2)


    spplot(figDat, 'Rich', col.regions=heat.colors(20), scales=list(draw=TRUE), par.settings=theme.loPadding)
    
        
    panelFun <- function(x,y,...){
        panel.xyplot(x,y,...)
        panel.loess(x,y,col.line='black',...)
    }

    # two panel plots of a map and scattergraph against richness
    print(spplot(figDat, 'MeanAET', col.regions=heat.colors(20), main='Actual Evapotranspiration (AET)',  par.settings=theme.loPadding), split=c(1,1,1,2), more=TRUE)
    print(xyplot(Rich ~ MeanAET, data=figDat@data, panel= panelFun,  par.settings=theme.loPadding), split=c(1,2,1,2))
    
    print(spplot(figDat, 'MeanAnnTemp', col.regions=heat.colors(20), main='Mean Annual Temperature',  par.settings=theme.loPadding), split=c(1,1,1,2), more=TRUE)
    print(xyplot(Rich ~ MeanAnnTemp, data=figDat@data, panel= panelFun,  par.settings=theme.loPadding), split=c(1,2,1,2))

    print(spplot(figDat, 'MeanElev', col.regions=terrain.colors(20), main='Mean Elevation',  par.settings=theme.loPadding), split=c(1,1,1,2), more=TRUE)
    print(xyplot(Rich ~ MeanElev, data=figDat@data, panel= panelFun,  par.settings=theme.loPadding), split=c(1,2,1,2))



    # Basic models
    simpleLM <- lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat)
    simpleGAM <- gam(Rich ~ s(MeanAET) + s(MeanAnnTemp) + s(MeanElev), data=figDat)
    
    par(mfrow=c(1,3), mar=c(3,3,1,1), mgp=c(2,0.8,0))
    plot(simpleGAM)
    
    figDat$simpleLM.pred <- predict(simpleLM)
    figDat$simpleGAM.pred <- predict(simpleGAM)
    
    
    # compare plots of simple model residuals against observed
    col <- heat.colors(20)
    atRich <- seq(0,700, length=21)
    print(spplot(figDat, 'simpleLM.pred', col.regions=col, at=atRich, main='Linear Model (r2 = 0.45)',  par.settings=theme.loPadding), split=c(1,1,3,1), more=TRUE)
    print(spplot(figDat, 'Rich', col.regions=col, at=atRich, main='Observed richness',  par.settings=theme.loPadding), split=c(2,1,3,1), more=TRUE)
    print(spplot(figDat, 'simpleGAM.pred', col.regions=col, at=atRich, main='GAM (r2 = 0.57)',  par.settings=theme.loPadding), split=c(3,1,3,1))

    
# spatial autocorrelation (SAC)

    # get an 8 nearest neighbour connectivity setup and grab the coordinates for the points
    figDat.nb <- knn2nb( knearneigh(figDat, k=8))
    figDat.lw <- nb2listw(figDat.nb)
    figDatCoords <- as.data.frame(coordinates(figDat))
    
    # global SAC measure in richness
    globalMoranRich <- moran.test(figDat$Rich, figDat.lw)
    
    # an example of no SAC using random data
    figDat$randRich <- sample(figDat$Rich)
    spplot(figDat, 'randRich', col.regions=heat.colors(20), scales=list(draw=TRUE), par.settings=theme.loPadding)
    globalMoranRandRich <- moran.test(figDat$randRich, figDat.lw)
    
    # 'grams of two kinds
        
    # correlogram - increment sets the distance classes, resamp is used to control randomisations to get significance
    # uses the coordinates and the values
    richCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, figDat$Rich, increment=100, resamp=1)
    aetCorrel  <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr,  figDat$MeanAET, increment=100, resamp=1)
    tempCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, figDat$MeanAnnTemp, increment=100, resamp=1)
    elevCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, figDat$MeanElev, increment=100, resamp=1)
    
    # correlograms of multiple variables - all of them and the explanatory ones
    allCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, 
                          figDat@data[, c("Rich","MeanAET","MeanAnnTemp","MeanElev")], increment=100, resamp=1)
    explCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, 
                           figDat@data[, c("MeanAET","MeanAnnTemp","MeanElev")], increment=100, resamp=1)
    
    # a plot of the number of pairs in each bin and the correlogram
    par(mfrow=c(1,2), mar=c(3,3,1,1), mgp=c(2,0.8,0))
    with(richCorrel, plot(mean.of.class, n, xlab='Distance (km)', ylab='Count'))
    with(richCorrel, plot(mean.of.class, correlation, xlab='Distance (km)', ylab='Correlation', pch=21)) 
    abline(h=0)
    
    # variogram 
    richVariog <- variogram(list(figDat$Rich), list(coordinates(figDat)), width=100, cutoff=8500)
    
    par(mfrow=c(1,2), mar=c(3,3,1,1), mgp=c(2,0.8,0))
    with(richVariog, plot(dist, np, xlab='Distance (km)', ylab='Count'))
    with(richVariog, plot(dist, gamma, xlab='Distance (km)', ylab='Semivariance', pch=21))
    abline(h=0)

    # Local indicators of spatial autocorrelation -gives a matrix of values
    richLISA <- localmoran(figDat$Rich, figDat.lw)
    figDat$richLISA.I <- richLISA[,1] # the autocorrelation value
    figDat$richLISA.Z <- richLISA[,4] # the z value - standard normal for significance testing
    
    # plot LISA and significance
    print(spplot(figDat, 'richLISA.I', col.regions=heat.colors(20), at=quantile(figDat$richLISA.I, 
          seq(0,1,by=0.05)), main="Local Moran's I",  par.settings=theme.loPadding), split=c(1,1,2,1), more=TRUE)
    print(spplot(figDat, 'richLISA.Z', col.regions=c('blue','grey20',heat.colors(20)), at=c(-5,
          qnorm(0.025), seq(qnorm(0.975), 30, length=21)), main='Z value',  par.settings=theme.loPadding), split=c(2,1,2,1))


# CLIFFORD TEST
    
    clFiles <- dir('/Users/dorme/Scripts/Pendek_devel/pendek/R', pattern='clifford', full=TRUE)
    for(f in clFiles) source(f)
    
    tempCliff <- clifford.test(as.image.SpatialGridDataFrame(figDat[,'Rich'])$z, as.image.SpatialGridDataFrame(figDat[,'MeanAnnTemp'])$z)
    aetCliff <- clifford.test(as.image.SpatialGridDataFrame(figDat[,'Rich'])$z, as.image.SpatialGridDataFrame(figDat[,'MeanAET'])$z)
    elevCliff <- clifford.test(as.image.SpatialGridDataFrame(figDat[,'Rich'])$z, as.image.SpatialGridDataFrame(figDat[,'MeanElev'])$z)
    

# SARs - borrowing heavily from Kissling and Carl (2008)
    
    # rescaling variables to allow convergence
    scaledExpl <- as.data.frame(scale(figDat@data[,c('MeanAET','MeanAnnTemp','MeanElev')]))
    figDat$MeanAETScaled <- scaledExpl$MeanAET
    figDat$MeanAnnTempScaled <- scaledExpl$MeanAnnTemp
    figDat$MeanElevScaled <- scaledExpl$MeanElev

    
    system.time(figDatSARerr <- errorsarlm(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled, data=figDat@data, figDat.lw)) # 58.212 seconds
    system.time(figDatSARlag <- lagsarlm(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled, data=figDat@data, figDat.lw, type='lag')) #  67.943 seconds
    system.time(figDatSARmix <- lagsarlm(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled, data=figDat@data, figDat.lw, type='mixed')) # 68.745 seconds

    summary(figDatSARerr)
    summary(figDatSARlag)
    summary(figDatSARmix)
    
    # plot of residual autocorrelation
    simpleLMCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(simpleLM), na.rm=TRUE, increment=100, resamp=1)
    figDatSARerrCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(figDatSARerr), na.rm=TRUE, increment=100, resamp=1)    
    figDatSARlagCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(figDatSARlag), na.rm=TRUE, increment=100, resamp=1)    
    figDatSARmixCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(figDatSARmix), na.rm=TRUE, increment=100, resamp=1)
    
    # panel function for lattice graphics that joins the points and adds a zero line
    panel.correl <- function(x,y,...){
        panel.xyplot(x,y, type='l', ...)
        panel.xyplot(x,y)
        panel.abline(h=0, lty=2)
    }
    
    # get the predictions and then plot out a 2x2 figure of model outputs
    figDat$SARlagPred <- predict(figDatSARlag)
    
    print(spplot(figDat, 'SARlagPred', col.regions=heat.colors(20), at=seq(0,700, length=21), 
          main='Predicted richness'), split=c(1,1,2,2), more=TRUE)
    print(with(figDat@data, xyplot(SARlagPred ~ Rich, panel=function(x,y,...){panel.xyplot(x,y); panel.abline(a=0,b=1)},
          ylab = 'Predicted', xlab='Observed', par.settings=theme.loPadding)), split=c(1,2,2,2), more=TRUE)
    print(with(richCorrel, xyplot(correlation ~ mean.of.class, panel=panel.correl, xlim=c(0,6000), 
          ylim=c(-0.3,0.8), xlab = 'Distance (km)', ylab='Correlation', par.settings=theme.loPadding,
          main='Autocorrelation in richness')), split=c(2,1,2,2), more=TRUE)
    print(with(figDatSARlagCorrel, xyplot(correlation ~ mean.of.class, panel=panel.correl, xlim=c(0,6000),
          ylim=c(-0.3,0.8), xlab = 'Distance (km)', ylab='Correlation', par.settings=theme.loPadding,
          main='Residual autocorrelation')), split=c(2,2,2,2))

# GLS model
    simpleGLS <- gls(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled, data=figDat)

    # update the model to include a linear spatial structure model - not good!
    system.time(fixedGLSLin <- update(simpleGLS,  corr=corLin(c(2000), form=~e_centre_behr+n_centre_behr, fixed=TRUE))) # 67 seconds 
    fixedGLSLin.vario <- Variogram(fixedGLSLin)
    plot(fixedGLSLin.vario)
        
    # exponential spatial model with correlograms and variograms - neither very good
    system.time(fixedGLSExp <- update(simpleGLS,  corr=corExp(c(2500), form=~e_centre_behr+n_centre_behr, fixed=TRUE))) # 67 seconds 
    
    fixedGLS.vario <- Variogram(fixedGLSExp)
    plot(fixedGLS.vario)

    fixedGLS.correl <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(fixedGLS), 
                                na.rm=TRUE, increment=100, resamp=1)
    plot(fixedGLS.correl)

    # # code to run an exponential model, allowing the model to optimise the range over which SAC occurs.
    # # This is SLOW (30 minutes or so)
    # system.time(spatialGLS <- update(simpleGLS,  corr=corExp(c(200), form=~e_centre_behr+n_centre_behr, fixed=FALSE))) # 2221.356 seconds
    
    
# Eigenvector filtering
    
    # There are functions to automate selection of eigenvectors but these are hideously slow:
    ## this ran for days and didn't show any sign of finishing
    ## system.time(spatialME <- ME(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat, listw=nb2listw(figDat.nb)))

    # A slightly crude demonstration of the basic idea
    # - this code calculates the eigenvectors on the centred weights matrix from the neighbourhood list
    Wmat <- listw2mat(figDat.lw)
    n <- ncol(Wmat)
    Cent <- diag(n) - (matrix(1, n, n)/n)
    eV <- eigen(Cent %*% Wmat %*% Cent, EISPACK = TRUE)$vectors

    # just put the first four eigenvectors into the dataset
    figDat$spEV1 <- eV[,1]
    figDat$spEV2 <- eV[,2]
    figDat$spEV3 <- eV[,3]
    figDat$spEV4 <- eV[,4]
        
    # plot them out to see what they look like
    print(spplot(figDat, 'spEV1', col.regions=heat.colors(20), par.settings=theme.loPadding), split=c(1,1,2,2), more=TRUE)
    print(spplot(figDat, 'spEV2', col.regions=heat.colors(20), par.settings=theme.loPadding), split=c(2,1,2,2), more=TRUE)
    print(spplot(figDat, 'spEV3', col.regions=heat.colors(20), par.settings=theme.loPadding), split=c(1,2,2,2), more=TRUE)
    print(spplot(figDat, 'spEV4', col.regions=heat.colors(20), par.settings=theme.loPadding), split=c(2,2,2,2))
    
    # include them in a model and simplify. NB - the eigenvectors are complex numbers and 
    # I have only used the real parts in the model.
    badEV1 <- lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev + Re(spEV1) + Re(spEV2) + Re(spEV3) + Re(spEV4) , data=figDat@data)
    badEV2 <- lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev + Re(spEV1) + Re(spEV2) + Re(spEV3) , data=figDat@data)
    
# GWR

    # using cross-validation to find a bandwidth or adaptive q (proportion of cells in local neighbourhood)
    # both of these converge on smaller and smaller bandwidths and qs....
    system.time(simpleGWR.bw <- gwr.sel(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat)) #752
    system.time(simpleGWR.adapt <- gwr.sel(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat, adapt=TRUE)) 

    # .. so use a smallish window of 1/20 th of the dataset, using the default gaussian weighting
    system.time(simpleGWR.se <- gwr(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat, adapt=0.05, se.fit=TRUE)) # 19 seconds

    # extract the data (estimates and standard errors) for each cell
    simpleGWR.data <- simpleGWR.se$SDF
    gwrCoords <- coordinates(simpleGWR.data)
    gwrDat <- SpatialPixelsDataFrame(gwrCoords, data=simpleGWR.data@data, tolerance=0.01)

    # function to get a colour scale centred on zero, given the range of slopes
    colScheme <- function(dat, var, n2=20){

        est <- dat@data[, var]
        se <- dat@data[, paste(var, 'se', sep='_')]
        n <- dat@data[,'sum.w']
    
        estR <- range(est)
        absMax <- max(abs(estR))
    
        pos <- pretty(c(0, absMax), n=n2)
        neg <- rev(-pos)
    
        scale <- c(neg, pos[-1])
        #cols <- hcl(h=seq(2/3*360, 0.0,length=length(scale)), l=65, c=100)
        cols <- rev(rainbow(n=length(scale), end=2/3))
    
        return(list(at=scale,col.regions=cols))
    }

    # a map of the coefficients for each term
    print(spplot(figDat, 'MeanAET', col.regions=heat.colors(20), main='AET', 
          par.settings=theme.loPadding), split=c(1,1,3,2), more=TRUE)
    currCols <- colScheme(gwrDat, 'MeanAET')
    print(spplot(gwrDat, 'MeanAET', at=currCols$at, col.regions=currCols$col.regions), split=c(1,2,3,2), more=TRUE)
    
    print(spplot(figDat, 'MeanAnnTemp', col.regions=heat.colors(20), main='Temperature', 
          par.settings=theme.loPadding), split=c(2,1,3,2), more=TRUE)
    currCols <- colScheme(gwrDat, 'MeanAnnTemp')
    print(spplot(gwrDat, 'MeanAnnTemp', at=currCols$at, col.regions=currCols$col.regions), split=c(2,2,3,2), more=TRUE)

    print(spplot(figDat, 'MeanElev', col.regions=terrain.colors(20),main='Elevation', 
          par.settings=theme.loPadding), split=c(3,1,3,2), more=TRUE)
    currCols <- colScheme(gwrDat, 'MeanElev')
    print(spplot(gwrDat, 'MeanElev', at=currCols$at, col.regions=currCols$col.regions), split=c(3,2,3,2))
    
    # map of the model explanatory power
    spplot(gwrDat, 'R2', at=seq(0,1,length=41), col.regions=rev(rainbow(n=40, end=2/3)), main=expression(Local~~GWR~r^2))
