library(sp)
library(spdep)
library(mgcv) # for GAM
library(ncf) # for correlog
library(gstat) # for variogram
library(nlme) # for gls
library(spgwr) # for gwr

# # get the land cell data in from the db
# cellData <- read.table("/Users/dorme/Work/ADHoC/ADHoC_Database/Behr_GridTable.txt")[,c(1,4,5)]
# names(cellData) <- c('gridid', 'e_centre_behr', 'n_centre_behr')



# cellData

gridid <- as.vector(mapply(function(x){1:360 + x*360}, 151:0, SIMPLIFY=T))

col <- rep(1:360, times=152)
row <- rep(152:1, each=360)

cellsize <- 96.486268
e_centre_behr <- rep(seq(cellsize * -179.5, cellsize * 179.5, cellsize), times=152)
n_centre_behr <- rep(seq(cellsize * 75.5, cellsize * -75.5, -cellsize), each=360)

cellData <- data.frame(gridid, e_centre_behr, n_centre_behr)

# get the data and add in the behr coords
figDat <- read.table('/Users/dorme/Work/Students/Lynsey_McInnes/MSc_AfricaData/ImpermeabilityMS/Figures/ImpermDataFuller.txt')
figDat <- merge(cellData, figDat)

# drop some fringing space
figDat <- subset(figDat, e_centre_behr > -1.9e3 & n_centre_behr < 3e3) 

# drop down to just the main variables for the demo
figDat <- subset(figDat, select=c(e_centre_behr, n_centre_behr, Rich, MeanAET, MeanElev, MeanAnnTemp))
figDat <- figDat[complete.cases(figDat),]

# convert to a spatial pixel data frame
# figCoords <- SpatialPoints(figDat[, c("e_centre_behr", "n_centre_behr")])
# figDat <- SpatialPixelsDataFrame(figCoords, data=figDat, tolerance=0.01)

coordinates(figDat) <-  ~ e_centre_behr + n_centre_behr
gridded(figDat) <- TRUE

save(figDat, file='SpatialDataExample.rda')

# data plots

    # getting a theme with less padding at the sides
    theme.loPadding <-
        list(layout.heights = list(top.padding = 0.5, main.key.padding = 0.5, 
              key.axis.padding = 0.5, axis.xlab.padding = 0.5, xlab.key.padding = 0.5, 
              key.sub.padding = 0.5, bottom.padding = 0.3),
             layout.widths = list(left.padding = 0.5, key.ylab.padding = 0.5,
              ylab.axis.padding = 0.5, axis.key.padding = 0.5, right.padding = 0.5), lwd=2)


    pdf(file = 'RichMap.pdf', width = 7, height = 6 )#, bg='white')
        spplot(figDat, 'Rich', col.regions=heat.colors(20), scales=list(draw=TRUE), par.settings=theme.loPadding)
    dev.off()
    
    pdf(file = 'RichMapSmall.pdf', width = 4.25, height = 4.25)#, bg='white')
        spplot(figDat, 'Rich', col.regions=heat.colors(20), scales=list(draw=TRUE), par.settings=theme.loPadding)
    dev.off()
    
    panelFun <- function(x,y,...){
        panel.xyplot(x,y,...)
        panel.loess(x,y,col.line='black',...)
    }

    pdf(file = 'AET_RichMap.pdf', width = 4.25, height = 8.5 )#, bg='white')
        print(spplot(figDat, 'MeanAET', col.regions=heat.colors(20), main='Actual Evapotranspiration (AET)',  par.settings=theme.loPadding), split=c(1,1,1,2), more=TRUE)
        print(xyplot(Rich ~ MeanAET, data=figDat@data, panel= panelFun,  par.settings=theme.loPadding), split=c(1,2,1,2))
    dev.off()
    
    pdf(file = 'Temp_RichMap.pdf', width = 4.25, height = 8.5 )#, bg='white')
        print(spplot(figDat, 'MeanAnnTemp', col.regions=heat.colors(20), main='Mean Annual Temperature',  par.settings=theme.loPadding), split=c(1,1,1,2), more=TRUE)
        print(xyplot(Rich ~ MeanAnnTemp, data=figDat@data, panel= panelFun,  par.settings=theme.loPadding), split=c(1,2,1,2))
    dev.off()

    pdf(file = 'Elev_RichMap.pdf', width = 4.25, height = 8.5 )#, bg='white')
        print(spplot(figDat, 'MeanElev', col.regions=terrain.colors(20), main='Mean Elevation',  par.settings=theme.loPadding), split=c(1,1,1,2), more=TRUE)
        print(xyplot(Rich ~ MeanElev, data=figDat@data, panel= panelFun,  par.settings=theme.loPadding), split=c(1,2,1,2))
    dev.off()

    pdf(file = 'CorrComparison.pdf', width = 4.25*2, height = 4.25 )#, bg='white')
        print(spplot(figDat, 'Rich', col.regions=heat.colors(20), par.settings=theme.loPadding, colorkey=NULL, main='Richness'), split=c(1,2,4,2), more=TRUE)
        print(spplot(figDat, 'MeanAET', col.regions=heat.colors(20), main='AET',  par.settings=theme.loPadding, colorkey=NULL), split=c(2,1,4,2), more=TRUE)
        print(xyplot(Rich ~ MeanAET, data=figDat@data,  par.settings=theme.loPadding, scales=list(draw=FALSE)), split=c(2,2,4,2), more=TRUE)
        print(spplot(figDat, 'MeanAnnTemp', col.regions=heat.colors(20), main='Temperature',  par.settings=theme.loPadding, colorkey=NULL), split=c(3,1,4,2), more=TRUE)
        print(xyplot(Rich ~ MeanAnnTemp, data=figDat@data,  par.settings=theme.loPadding, scales=list(draw=FALSE)), split=c(3,2,4,2), more=TRUE)
        print(spplot(figDat, 'MeanElev', col.regions=terrain.colors(20), main='Elevation',  par.settings=theme.loPadding, colorkey=NULL), split=c(4,1,4,2), more=TRUE)
        print(xyplot(Rich ~ MeanElev, data=figDat@data,  par.settings=theme.loPadding, scales=list(draw=FALSE)), split=c(4,2,4,2))
    dev.off()



    # Basic models
    simpleLM <- lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat)
    simpleGAM <- gam(Rich ~ s(MeanAET) + s(MeanAnnTemp) + s(MeanElev), data=figDat)
    
    pdf(file = 'simpleGAM.pdf', width = 9, height = 3 )#, bg='white')
        par(mfrow=c(1,3), mar=c(3,3,1,1), mgp=c(2,0.8,0))
        plot(simpleGAM)
        
        
    dev.off()
    
    figDat$simpleLM.pred <- predict(simpleLM)
    figDat$simpleGAM.pred <- predict(simpleGAM)
    
    pdf(file = 'simplePreds.pdf', width = 9, height = 4.5 )#, bg='white')
        col <- heat.colors(20)
        atRich <- seq(0,700, length=21)
        print(spplot(figDat, 'simpleLM.pred', col.regions=col, at=atRich, main='Linear Model (r2 = 0.45)',  par.settings=theme.loPadding), split=c(1,1,3,1), more=TRUE)
        print(spplot(figDat, 'Rich', col.regions=col, at=atRich, main='Observed richness',  par.settings=theme.loPadding), split=c(2,1,3,1), more=TRUE)
        print(spplot(figDat, 'simpleGAM.pred', col.regions=col, at=atRich, main='GAM (r2 = 0.57)',  par.settings=theme.loPadding), split=c(3,1,3,1))
    dev.off()

    
# spatial autocorrelation

    figDat.nb <- knn2nb( knearneigh(figDat, k=8))
    figDat.lw <- nb2listw(figDat.nb)
    figDatCoords <- as.data.frame(coordinates(figDat))
    
    
    globalMoranRich <- moran.test(figDat$Rich, figDat.lw)
    
    # no SAC
    figDat$randRich <- sample(figDat$Rich)
    pdf(file = 'RandomRichMap.pdf', width = 10, height = 8 )#, bg='white')
        spplot(figDat, 'randRich', col.regions=heat.colors(20), scales=list(draw=TRUE), par.settings=theme.loPadding)
    dev.off()
    
    globalMoranRandRich <- moran.test(figDat$randRich, figDat.lw)
    
    # 'grams of two kinds
        
    # correlogram
    
    richCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, figDat$Rich, increment=100, resamp=1)
    aetCorrel  <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr,  figDat$MeanAET, increment=100, resamp=1)
    tempCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, figDat$MeanAnnTemp, increment=100, resamp=1)
    elevCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, figDat$MeanElev, increment=100, resamp=1)
    
    
    allCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, 
                          figDat@data[, c("Rich","MeanAET","MeanAnnTemp","MeanElev")], increment=100, resamp=1)
    explCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, 
                           figDat@data[, c("MeanAET","MeanAnnTemp","MeanElev")], increment=100, resamp=1)
    
    pdf(file = 'richCorrelogram.pdf', width = 9, height = 4.5 )#, bg='white')
        par(mfrow=c(1,2), mar=c(3,3,1,1), mgp=c(2,0.8,0))
        with(richCorrel, plot(mean.of.class, n, xlab='Distance (km)', ylab='Count'))
        with(richCorrel, plot(mean.of.class, correlation, xlab='Distance (km)', ylab='Correlation', pch=21)) 
        abline(h=0)
    dev.off()
    
    # variogram
    richVariog <- variogram(list(figDat$Rich), list(coordinates(figDat)), width=100, cutoff=8500)
    
    pdf(file = 'richVariogram.pdf', width = 9, height = 4.5 )#, bg='white')
        par(mfrow=c(1,2), mar=c(3,3,1,1), mgp=c(2,0.8,0))
        with(richVariog, plot(dist, np, xlab='Distance (km)', ylab='Count'))
        with(richVariog, plot(dist, gamma, xlab='Distance (km)', ylab='Semivariance', pch=21))
        abline(h=0)
    dev.off()
    
    pdf(file = 'richVariogramExample.pdf', width = 5, height = 5 )#, bg='white')
        with(richVariog, plot(dist, gamma+2000, xlab='Distance (km)', ylab='Semivariance', pch=21, ylim=c(0,25000)))
        abline(h=0)
    dev.off()
    
    # lisa
    richLISA <- localmoran(figDat$Rich, figDat.lw)
    figDat$richLISA.I <- richLISA[,1]
    figDat$richLISA.Z <- richLISA[,4]
    
    pdf(file = 'richLISA.pdf', width = 8.5, height = 4.25 )#, bg='white')
        print(spplot(figDat, 'richLISA.I', col.regions=heat.colors(20), at=quantile(figDat$richLISA.I, 
              seq(0,1,by=0.05)), main="Local Moran's I",  par.settings=theme.loPadding), split=c(1,1,2,1), more=TRUE)
        print(spplot(figDat, 'richLISA.Z', col.regions=c('blue','grey20',heat.colors(20)), at=c(-5,
              qnorm(0.025), seq(qnorm(0.975), 30, length=21)), main='Z value',  par.settings=theme.loPadding), split=c(2,1,2,1))
    dev.off()

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

    
    system.time(figDatSARerr <- errorsarlm(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled, data=figDat@data, figDat.lw)) # 58.212
    system.time(figDatSARlag <- lagsarlm(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled, data=figDat@data, figDat.lw, type='lag')) #  67.943 
    system.time(figDatSARmix <- lagsarlm(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled, data=figDat@data, figDat.lw, type='mixed')) # 68.745  

    summary(figDatSARerr)
    summary(figDatSARlag)
    summary(figDatSARmix)
    
    # plot of residual autocorrelation
    simpleLMCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(simpleLM), na.rm=TRUE, increment=100, resamp=1)
    figDatSARerrCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(figDatSARerr), na.rm=TRUE, increment=100, resamp=1)    
    figDatSARlagCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(figDatSARlag), na.rm=TRUE, increment=100, resamp=1)    
    figDatSARmixCorrel <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(figDatSARmix), na.rm=TRUE, increment=100, resamp=1)
    
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
    
    figDat$SARlagPred <- predict(figDatSARlag)
    
    pdf(file='SARoutputs.pdf', width=9, height=9)
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
    dev.off()

        

    
# GLS model
    simpleGLS <- gls(Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled, data=figDat)

    # exponential spatial model
    system.time(fixedGLSExp <- update(simpleGLS,  corr=corExp(c(1000), form=~e_centre_behr+n_centre_behr, fixed=TRUE, nugget=TRUE))) # 67 seconds 
    fixedGLS.vario <- Variogram(fixedGLSExp)
    plot(fixedGLS.vario)

    # linear spatial model
    system.time(fixedGLSLin <- update(simpleGLS,  corr=corLin(c(2000), form=~e_centre_behr+n_centre_behr, fixed=TRUE))) # 67 seconds 
    fixedGLSLin.vario <- Variogram(fixedGLSLin)
    plot(fixedGLSLin.vario)


    system.time(spatialGLS <- update(simpleGLS,  corr=corExp(c(200), form=~e_centre_behr+n_centre_behr, fixed=FALSE))) # 2221.356 seconds

    system.time(fixedGLSSphere <- update(simpleGLS,  corr=corSpher(c(1500), form=~e_centre_behr+n_centre_behr, fixed=TRUE))) # 67 seconds 

    system.time(fixedGLSLin <- update(simpleGLS,  corr=corLin(c(1500), form=~e_centre_behr+n_centre_behr, fixed=TRUE, nugget=TRUE, fixed=FALSE))) # 67 seconds 
    
    # exponential spatial model
    system.time(fixedGLSExp <- update(simpleGLS,  corr=corExp(c(2500), form=~e_centre_behr+n_centre_behr, fixed=TRUE))) # 67 seconds 
    fixedGLS.vario <- Variogram(fixedGLSExp)
    plot(fixedGLS.vario)

    fixedGLS.correl <- correlog(figDatCoords$e_centre_behr, figDatCoords$n_centre_behr, z=residuals(fixedGLS), 
                                na.rm=TRUE, increment=100, resamp=1)
    plot(fixedGLS.correl)

    # example correlation matrix on simple linear spatial data
    
    spatDat <- data.frame(x=2000 * seq(0,1,length=4), y=rep(0,4))
    expCS <- corExp(1500, form = ~ x + y, fixed=TRUE)
    expCS <- Initialize(expCS, spatDat)
    corMatrix(expCS)
    
    # plot of the curve...
    pdf('corModelExample.pdf',width=8, height=4, pointsize=14)
        par(mar=c(3,3,1,1), mgp=c(2,0.8,0))
        curve(exp(-x/1500), xlim=c(0,6000), ylim=c(-0.05, 1.05), xlab = 'Distance (km)', ylab='Correlation')
    dev.off()
    
# Eigenvector filtering

    Wmat <- listw2mat(figDat.lw)
    n <- ncol(Wmat)
    Cent <- diag(n) - (matrix(1, n, n)/n)
    eV <- eigen(Cent %*% Wmat %*% Cent, EISPACK = TRUE)$vectors

    figDat$spEV1 <- eV[,1]
    figDat$spEV2 <- eV[,2]
    figDat$spEV3 <- eV[,3]
    figDat$spEV4 <- eV[,4]
        
    pdf('EigFilt_examples.pdf', width=8, height=7)
        print(spplot(figDat, 'spEV1', col.regions=heat.colors(20), par.settings=theme.loPadding), split=c(1,1,2,2), more=TRUE)
        print(spplot(figDat, 'spEV2', col.regions=heat.colors(20), par.settings=theme.loPadding), split=c(2,1,2,2), more=TRUE)
        print(spplot(figDat, 'spEV3', col.regions=heat.colors(20), par.settings=theme.loPadding), split=c(1,2,2,2), more=TRUE)
        print(spplot(figDat, 'spEV4', col.regions=heat.colors(20), par.settings=theme.loPadding), split=c(2,2,2,2))
    dev.off()
    
    badEV1 <- lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev + Re(spEV1) + Re(spEV2) + Re(spEV3) + Re(spEV4) , data=figDat@data)
    badEV2 <- lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev + Re(spEV1) + Re(spEV2) + Re(spEV3) , data=figDat@data)
        
## DOG SLOW - ran for days and didn't show any sign of finishing
## system.time(spatialME <- ME(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat, listw=nb2listw(figDat.nb)))


# GWR

    # using cross-validation to find a bandwidth or adaptive q 
    # both of these converge on smaller and smaller bandwidths and qs....
    system.time(simpleGWR.bw <- gwr.sel(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat)) #752
    system.time(simpleGWR.adapt <- gwr.sel(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat, adapt=TRUE)) 

    system.time(simpleGWR <- gwr(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat, adapt=0.05)) # 19 seconds
    system.time(simpleGWR.se <- gwr(Rich ~ MeanAET + MeanAnnTemp + MeanElev, data=figDat, adapt=0.05, se.fit=TRUE))

    simpleGWR.data <- simpleGWR.se$SDF
    gwrCoords <- coordinates(simpleGWR.data)
    gwrDat <- SpatialPixelsDataFrame(gwrCoords, data=simpleGWR.data@data, tolerance=0.01)

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

    pdf('GWR_output.pdf', width=12, height=8)
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
    dev.off()
    

    pdf(file='GWR_r2.pdf', width=4, height=4)
        spplot(gwrDat, 'R2', at=seq(0,1,length=41), col.regions=rev(rainbow(n=40, end=2/3)), main=expression(Local~~GWR~r^2))
    dev.off()
        
    
    
    

