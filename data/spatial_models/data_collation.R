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