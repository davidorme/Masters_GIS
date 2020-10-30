---
title: Spatial modelling
author: David Orme
geometry: margin=2cm
fontsize: '12pt'
mainfont: "Georgia"
monofontoptions: "Scale=0.9"
---



This practical looks at some of the problems of fitting statistical models to spatial data, using the statistical software R.

# The dataset

This practical will use some data taken from a paper that looked at trying to predict what limits species ranges:

McInnes, L., Purvis, A., \& Orme, C. D. L. (2009). Where do species' geographic ranges stop and why? Landscape impermeability and the Afrotropical avifauna. Proceedings of the Royal Society Series B - Biological Sciences, 276(1670), 3063-3070. [http://doi.org/10.1098/rspb.2009.0656]

We won't actually be looking at range edges but we're going to use four variables taken from the data used in this paper. The data is all saved as GeoTIFF files, so we're starting with raster data. The files cover the Afrotropics and are all  projected in the Behrmann equal area projection with a resolution of 96.268 km. That might seem like an odd number: it is chosen to make the resolution of the data comparable to a degree longitude at $30^\circ$ N. Unlike a one degree resolution grid, however, these grid cells all cover an equal area on the ground ($96.268 \times 96.268 = 9309.6 \text{km}^2$, roughly the land area of Cyprus).

The variables for each grid cell are:

* the avian species richness across the Afrotropics,
* the mean elevation,
* the average annual temperature, and
* the average annual actual evapotranspiration.


<div style='background-color:lightgreen'>
* As a first step, start up QGIS and load in the four TIFF files and the cntry98 shapefile and make sure that you are looking at the data in your project using the Behrmann projection. Like the MODIS sinusoidal projection, this isn't one of the standard choices so you might need to look in the  user generated projection definitions.
* Take a look at the variables and think about the patterns in each. Where is each highest and why? Are there any areas where they show similar patterns?
</div>

# Statistical models of the data

In order to use statistics on the data, we are going to use the R programming.

* Do **not** panic.

I know that not all of you will have used R. It is not an easy program: telling R to do something usually involves typing in code, not choosing options from menus. The intention in this practical is to show some options that are available for spatial models in R, not to learn R, so you can just copy and paste the code. The main thing is to think about what the options are available, not in learning how to do it all in one afternoon!


# Installing packages

You may need to install some R packages to run this pracitical. If you are using your own laptop or a Linux laptop, then you should be able to just install them using:


```r
install.packages('package_name')
```

On the College computers, you should have them all but we are missing one that we will need. So, if you are on a College Windows computer, then copy in the following code, which will create a temporary copy of the `ncf` package for us to use.


```r
install.packages('ncf', lib="C:/Temp")
library(ncf, lib.loc='C:/Temp')
```



# Loading the data into R

One of the core ideas of data handling in R is the **data frame**. This is a data table where each column holds the values of a single variable and a row shows the values of each variable for a particular observation. It is superficially pretty similar to a spreadsheet in Excel except that it is a lot more picky about only having one kind of data in a column!

We need to get our raster data into R and into a data frame.

<div style='background-color:lightgreen'>
* First, you will need to change the working directory to the practical folder. The 'working directory' is the folder that R will look in when you give it a file name, so has to be set to allow use to read the data. There will be a menu option to choose it or you can use `setwd('path/to/the/practical')` if you're feeling confident!.

* Next, you will need to copy in the following code. The coloured lines starting with the `#` symbol are comments, annotating the R code, which you can just copy straight across.
</div>


```r
# load the raster library to handle GIS data files
library(raster)
```

```
## Loading required package: sp
```

```r
# load the four variables from their TIFF files
rich <- raster('data/avian_richness.tif')
aet <- raster('data/mean_aet.tif')
temp <- raster('data/mean_temp.tif')
elev <- raster('data/elev.tif')
```

What that just did is to load each raster into R and store it in an R **object**: that is basically just a slot of memory in R that can save data and results and which we can refer to by name. We can look at one in more detail by typing its name - note that in this example code and other blocks below,  information that R prints on the screen is shown as lines starting with `##`.


```r
# type in the raster object name to view some
# details and check it loaded!
rich
```

```
## class       : RasterLayer 
## dimensions  : 75, 78, 5850  (nrow, ncol, ncell)
## resolution  : 96.48627, 96.48627  (x, y)
## extent      : -1736.753, 5789.176, -4245.396, 2991.074  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=cea +lon_0=0 +lat_ts=30 +x_0=0 +y_0=0 +datum=WGS84 +units=km +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/dorme/Teaching/MSc_GIS_2016/SpatialMethods/Practical/data/avian_richness.tif 
## names       : avian_richness 
## values      : 10, 667  (min, max)
```


<div style='background-color:lightgreen'>
* Repeat this with each of the new raster objects: there is a lot of GIS information which hopefully now is less obscure and then at the bottom is the range of the values in each raster.
</div>

We can use R to explore this data more. First we'll use the `hist()` function to plot the distribution of the values in each variable, not just look at the minimum and maximum. 

<div style='background-color:lightgreen'>
* Copy and paste in the code below. The first command allows us to put four plots in a single figure.
</div>



```r
# split the figure area into a two by two layout
par(mfrow=c(2,2))
# plot a histogram of the values in each raster, setting nice 'main' titles
hist(rich, main='Avian species richness')
hist(aet, main='Mean AET')
hist(temp, main='Mean annual temperature')
hist(elev, main='Elevation')
```

![plot of chunk raster_hist](figure/raster_hist-1.pdf)

We can also look at the rasters as spatial objects by plotting them. In most cases, QGIS is the simpler way to display and explore maps, but we can do it in R too. In this case, the `plot()` command knows that the rasters are spatial data, so displays them as maps with a scale bar. 


```r
# split the figure area into a two by two layout
par(mfrow=c(2,2))
# plot a map of the values in each raster, setting nice 'main' titles
plot(rich, main='Avian species richness')
plot(aet, main='Mean AET')
plot(temp, main='Mean annual temperature')
plot(elev, main='Elevation')
```

![plot of chunk raster_plot](figure/raster_plot-1.pdf)

Before we do anything further statistical, look at those maps. One key skills in being a good scientist and statistician is in looking at data and a model and saying: 

*$?&!, that doesn't make any sense, I must have done it wrong.*

It is **really important** to think beforehand about the kinds of predictions we might expect from our data, so:

<div style='background-color:lightgreen'>
* What are the conditions that predict high species richness? There may not be a single set of conditions, but what are the general features of diverse areas?
</div>

Now, we have the data as rasters - 2 dimensional grids of values - but we need to get our data frame. We'll need to use two commands: 

* `stack()` allows us to superimpose the four rasters into a single object. Note that this only works because all of these rasters have the same projection, extent and resolution. In your own use, you would need to use GIS to set up your data so it can be stacked like this.

* `as()` allows us to convert an R object from one format to another. There are a set of predefined conversion recipes and one takes a stack of rasters and turns it into something called a SpatialPixelDataFrame, which is just our values in a table but with a record of their spatial position.



```r
data <- stack(rich, aet, elev, temp)
print(data)
```

```
## class       : RasterStack 
## dimensions  : 75, 78, 5850, 4  (nrow, ncol, ncell, nlayers)
## resolution  : 96.48627, 96.48627  (x, y)
## extent      : -1736.753, 5789.176, -4245.396, 2991.074  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=cea +lon_0=0 +lat_ts=30 +x_0=0 +y_0=0 +datum=WGS84 +units=km +no_defs +ellps=WGS84 +towgs84=0,0,0 
## names       : avian_richness,  mean_aet,      elev, mean_temp 
## min values  :        10.0000,   32.0600,    1.0000,   10.5246 
## max values  :       667.0000, 1552.6500, 2750.2800,   30.3667
```

```r
data_df <- as(data, 'SpatialPixelsDataFrame')
summary(data_df)
```

```
## Object of class SpatialPixelsDataFrame
## Coordinates:
##         min      max
## x -1736.753 5789.176
## y -4245.396 2991.074
## Is projected: TRUE 
## proj4string :
## [+proj=cea +lon_0=0 +lat_ts=30 +x_0=0 +y_0=0
## +datum=WGS84 +units=km +no_defs +ellps=WGS84
## +towgs84=0,0,0]
## Number of points: 2484
## Grid attributes:
##    cellcentre.offset cellsize cells.dim
## s1         -1688.510 96.48627        78
## s2         -4197.153 96.48627        75
## Data attributes:
##  avian_richness     mean_aet            elev       
##  Min.   : 10.0   Min.   :  32.06   Min.   :   1.0  
##  1st Qu.:202.0   1st Qu.: 439.70   1st Qu.: 317.7  
##  Median :269.5   Median : 754.59   Median : 548.8  
##  Mean   :268.4   Mean   : 732.07   Mean   : 672.0  
##  3rd Qu.:341.0   3rd Qu.: 996.60   3rd Qu.:1023.2  
##  Max.   :667.0   Max.   :1552.65   Max.   :2750.3  
##    mean_temp    
##  Min.   :10.52  
##  1st Qu.:21.83  
##  Median :24.71  
##  Mean   :24.25  
##  3rd Qu.:27.15  
##  Max.   :30.37
```
Note that the names of the variables in the data frame have been set from the original TIFF filenames!

# Exploring the data

So, where does that get us? We now have a new data structure that know where it is in space and has matched up  different variables across cells. We can still plot the data as a map by making use of the `spplot()` function, which is a specific plot function for making spatial plots of our new data structure:


```r
# plot a map of the data in data_df, chosing the column
# holding the richness data, changing the default colours and
# showing the geographic scales
spplot(data_df, zcol = "avian_richness", col.regions = heat.colors(20), 
    scales = list(draw = TRUE))
```

![plot of chunk spplot](figure/spplot-1.pdf)

But we can also plot the variables against each other, by treating the new object as a data frame:


```r
# Create three figures in a single panel
par(mfrow = c(1, 3))
# Now plot richness as a function of each environmental
# variable
plot(avian_richness ~ mean_aet, data = data_df)
plot(avian_richness ~ mean_temp, data = data_df)
plot(avian_richness ~ elev, data = data_df)
```

![plot of chunk plot_vars](figure/plot_vars-1.pdf)

# Correlations and spatial data

A **correlation coefficient** is a standardised measure between -1 and 1 showing how much observations of two variables tend to co-vary. For a positive correlation, both variables tend to have high values in the same locations and low values in the same locations. Negative correlations show the opposite. Once you've calculated a correlation, you need to assess how strong that correlation is _given the amount of data you have_: it is easy to get large $r$ values in small datasets by chance.

However, correlation coefficients assume that the data points are independent and this is not true for spatial data. Nearby data points tend to be similar: if you are in a warm location, surrounding areas will also tend to be warm. One relatively simple way of removing this non-independence is to calculate the significance of tests as if you had fewer data points.

We will use this approach to  compare standard measures of correlation to spatially corrected ones. We need to load a new set of functions that implement a modification to the correlation test that accounts for spatial similarity, described in (this paper)[https://jstor.org/stable/2532039]. The modified test does not change the correlation statistic itself but calculates a new effective sample size (ess) that is then used to calculate the test significance: $r$ will not change, but the degrees of freedom, $t$ statistic and the $p$ value will change.


<div style='background-color:lightgreen'>
* The `source()` function loads the new test and then the following two commands run the standard correlation test and the spatially corrected one.
* The code produces these results for the correlation between avian species richness and mean AET: run this and then modify it to see how it changes the results for mean temperature and elevation. 
</div>



```r
# load the new function: clifford.test()
source("clifford.test.R")
# run the standard test
cor.test(~avian_richness + mean_aet, data = data_df)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  avian_richness and mean_aet
## t = 31.115, df = 2482, p-value < 2.2e-16
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.5008302 0.5574404
## sample estimates:
##      cor 
## 0.529725
```

```r
# run the modified test. It needs matrices (grids) of the two
# variables to calculate the corrections.
clifford.test(as.matrix(rich), as.matrix(aet))
```

```
## 
## Correlation test accounting for autocorrelation (Clifford et al., 1989)
## 
## Data - Matrix A: as.matrix(rich) 
##      - Matrix B: as.matrix(aet) 
## 
##  rpearson    n         ncc    var.xy      var.r      ess
##  0.529725 2484 7.14048e+14 115724216 0.07316509 14.66772
##         w       t           p
##  1.958387 2.74931 0.008446161
```

# Measuring spatial autocorrelation

There are a number of statistics that quantify the level of spatial autocorrelation. We will be looking at Moran's I statistic, but others exist, such as Geary's C statistic, so look out for these in any modelling papers. Moran's I takes values between -1 and 1, with the central value of 0 showing that there is no spatial autocorrelation. Values close to -1 show strong negative autocorrelation, which is the unusual case that nearby cells have unexpectedly **different** values and values close to 1 show that nearby cells have unexpectedly **similar** values.

Spatial autocorrelation is all about saying how similar nearby points are to each other, so we first need to define 'nearby'. There are two main ways of doing this - you can choose the $k$ nearest neighbours of a point or you can choose all points within a particular distance. We will take this second approach using the `dnearneigh()` function, but for reference the function `knearneigh()` allows you to do the first one.

If we use a distance cutoff of 150 km then all cells that share an edge or a corner with a given cell will be considered its neighbour. Using chess as an analogy, this is sometimes called Queen's move connections (although it is actually like a King's move!) and the alternative where only cells sharing an edge are neighbours is called Rook's move. In the code below, we also have to set `zero.policy=TRUE`: this allows the code to ignore some checks on isolated points that have no neighbours within 150 km.


```r
# load the spatial dependence analysis package
library(spdep)
# All cells with centres closer than 150km are neighbours of
# a cell
neighbours <- dnearneigh(data_df, d1 = 0, d2 = 150)
# convert that to a weighted list of neighbours
neighbours.lw <- nb2listw(neighbours, zero.policy = TRUE)
# global Moran's I for avian richness
rich.moran <- moran.test(data_df$avian_richness, neighbours.lw, 
    zero.policy = TRUE)
rich.moran
```

```
## 
## 	Moran I test under randomisation
## 
## data:  data_df$avian_richness  
## weights: neighbours.lw  
## 
## Moran I statistic standard deviate = 88.419, p-value
## < 2.2e-16
## alternative hypothesis: greater
## sample estimates:
## Moran I statistic       Expectation          Variance 
##      0.9264783441     -0.0004032258      0.0001098905
```

The `moran.test()` function gives a single value representing the overall level of spatial autocorrelation in a variable, but we can also look at local indicators of spatial autocorrelation (LISA), which can reveal areas of stronger or weaker similarity. These calculate a similar statistic but only within a window around each cell and report back the calculated value for each cell, which we can then map. Local Moran's I is still centred on zero for no spatial autocorrelation but values are not constrained between -1 and 1.


```r
# Use the same neighbour definition to get local
# autocorrelation
rich.lisa <- localmoran(data_df$avian_richness, neighbours.lw, 
    zero.policy = TRUE)
# The rich.lisa results contain several variables in columns:
# we add one to our dataframe to plot it
data_df$rich_lisa <- rich.lisa[, 1]
# plot the values.
spplot(data_df, zcol = "rich_lisa", col.regions = heat.colors(20), 
    scales = list(draw = TRUE))
```

![plot of chunk lisa](figure/lisa-1.pdf)

<div style='background-color:lightgreen'>
* As we might predict, avian richness shows strong positive spatial autocorrelation, which seems to be particularly strong in the mountains around Lake Victoria. Try these measures out on the other variables!
</div>


# Autoregressive models

Our definition of a set of neighbours allows us to fit a spatial autoregressive (SAR) model. This is a statistical model that predicts the value of a response variable in a cell using the predictor variables and values of the response variable in neighbouring cells. This is why they are called autoregressive models: they fit the response variable partly as a response to itself.

They come in many different possible forms. This is a great paper explaining some of the different forms with some great appendices including example R code:

Kissling, W. D., & Carl, G. (2008). Spatial autocorrelation and the selection of simultaneous autoregressive models. Global Ecology and Biogeography, 17(1), 59–71. 



```r
# Fit a simple linear model
simple_model <- lm(avian_richness ~ mean_aet + elev + mean_temp, 
    data = data_df)
summary(simple_model)
```

```
## 
## Call:
## lm(formula = avian_richness ~ mean_aet + elev + mean_temp, data = data_df)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -354.09  -53.25   -0.93   52.64  325.58 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 189.452772  21.328794   8.882  < 2e-16 ***
## mean_aet      0.176412   0.004724  37.342  < 2e-16 ***
## elev          0.076027   0.005490  13.849  < 2e-16 ***
## mean_temp    -4.178441   0.722002  -5.787 8.05e-09 ***
## ---
## Signif. codes:  
## 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 82.4 on 2480 degrees of freedom
## Multiple R-squared:  0.4554,	Adjusted R-squared:  0.4548 
## F-statistic: 691.4 on 3 and 2480 DF,  p-value: < 2.2e-16
```

```r
# Fit a spatial autoregressive model: this is much slower and
# can take minutes to calculate
sar_model <- errorsarlm(avian_richness ~ mean_aet + elev + mean_temp, 
    data = data_df, listw = neighbours.lw, zero.policy = TRUE)
summary(sar_model)
```

```
## 
## Call:
## errorsarlm(formula = avian_richness ~ mean_aet + elev + mean_temp, 
##     data = data_df, listw = neighbours.lw, zero.policy = TRUE)
## 
## Residuals:
##         Min          1Q      Median          3Q         Max 
## -218.359135   -8.991092   -0.054733    9.643101  109.813234 
## 
## Type: error 
## Regions with no neighbours included:
##  1311 1817 2204 
## Coefficients: (asymptotic standard errors) 
##                Estimate  Std. Error z value  Pr(>|z|)
## (Intercept) -1.2964e+02  3.3814e+01 -3.8340 0.0001261
## mean_aet     5.6957e-02  6.9750e-03  8.1659 2.220e-16
## elev         4.8364e-02  6.7019e-03  7.2165 5.336e-13
## mean_temp    3.1011e+00  1.2642e+00  2.4530 0.0141688
## 
## Lambda: 0.99573, LR test value: 6522.3, p-value: < 2.22e-16
## Asymptotic standard error: 0.0011623
##     z-value: 856.7, p-value: < 2.22e-16
## Wald statistic: 733940, p-value: < 2.22e-16
## 
## Log likelihood: -11219.94 for error model
## ML residual variance (sigma squared): 362.3, (sigma: 19.034)
## Number of observations: 2484 
## Number of parameters estimated: 6 
## AIC: 22452, (AIC for lm: 28972)
```

Lets look at the **predictions** of those models. We can extract the predicted values for each point and put them into our spatial data frame and then map them. 


```r
# extract the predictions from the model into the spatial
# data frame
data_df$simple_fit <- predict(simple_model)
data_df$sar_fit <- predict(sar_model)
# Compare those two predictions with the data
spplot(data_df, c("avian_richness", "simple_fit", "sar_fit"), 
    col.regions = heat.colors(20), scales = list(draw = TRUE))
```

![plot of chunk model_pred](figure/model_pred-1.pdf)

We can also look at the **residuals** of those models -  the differences between the prediction and the actual values - to highlight where the models aren't working well. We'll manipulate the colours so negative residuals are blue and positive residuals are red.


```r
# extract the residuals from the model into the spatial data
# frame
data_df$simple_resid <- residuals(simple_model)
data_df$sar_resid <- residuals(sar_model)
# Create a 21 colour ramp from blue to red, centred on zero
colPal <- colorRampPalette(c("cornflowerblue", "grey", "firebrick"))
colours <- colPal(21)
breaks <- seq(-600, 600, length = 21)
# plot the residuals side by side
spplot(data_df, c("simple_resid", "sar_resid"), col.regions = colours, 
    at = breaks, scales = list(draw = TRUE))
```

![plot of chunk model_resid](figure/model_resid-1.pdf)

# Correlograms

Correlograms are another way of visualising spatial autocorrelation. They show how the correlation within a variable changes as the distance between pairs of points being compared increases. To show this, we need the coordinates of the spatial data and the values of a variable at each point.


```r
# Install a missing library to calculate correlograms
library(ncf)
# extract the X and Y coordinates
data_xy <- data.frame(coordinates(data_df))
# calculate a correlogram for avian richness: a slow process!
rich.correlog <- correlog(data_xy$x, data_xy$y, data_df$avian_richness, 
    increment = 100, resamp = 0)
plot(rich.correlog)
```

![plot of chunk correlogram](figure/correlogram-1.pdf)

To explain that a bit further: we take a focal point and then make pairs of the value of that point and all other points. These pairs are assigned to bins based on how far apart the points are: the *increment* is the width of those bins. Once we've done this for all points - yes, that is a lot of pairs! - we calculate the correlations between the sets of pairs in each bin. Each bin has a mean distance among the points in that class.

We can get the significance of the correlations at each distance by resampling the data, but it is a very slow process, which is why the correlograms here have been set not to do any resampling (`resamp=0`).

We can get more control on that by creating a data frame. First, we can see that the number of pairs in a class drops off dramatically at large distances: that upswing on the right is based on few pairs, so we can generally ignore it and look at just shorter distances.


```r
par(mfrow = c(1, 2))
# convert three key variables into a data frame
rich.correlog <- data.frame(rich.correlog[1:3])
# plot the size of the distance bins
plot(n ~ mean.of.class, data = rich.correlog, type = "o")
# plot a correlogram for shorter distances
plot(correlation ~ mean.of.class, data = rich.correlog, type = "o", 
    subset = mean.of.class < 5000)
# add a horizontal zero correlation line
abline(h = 0)
```

![plot of chunk correlogram_control](figure/correlogram_control-1.pdf)

One key use of correlograms is to assess how well models have controlled for spatial autocorrelation by looking at the correlation in the residuals. We can compare our two models like this and see how much better the SAR is at controlling for the autocorrelation in the data.


```r
# Calculate correlograms for the residuals in the two models
simple.correlog <- correlog(data_xy$x, data_xy$y, data_df$simple_resid, 
    increment = 100, resamp = 0)
sar.correlog <- correlog(data_xy$x, data_xy$y, data_df$sar_resid, 
    increment = 100, resamp = 0)
# Convert those to make them easier to plot
simple.correlog <- data.frame(simple.correlog[1:3])
sar.correlog <- data.frame(sar.correlog[1:3])

# plot a correlogram for shorter distances
plot(correlation ~ mean.of.class, data = simple.correlog, type = "o", 
    subset = mean.of.class < 5000)
# add the data for the SAR model to compare them
lines(correlation ~ mean.of.class, data = sar.correlog, type = "o", 
    subset = mean.of.class < 5000, col = "red")

# add a horizontal zero correlation line
abline(h = 0)
```

![plot of chunk correlogram_models](figure/correlogram_models-1.pdf)




