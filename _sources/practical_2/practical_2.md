---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.12
    jupytext_version: 1.6.0
kernelspec:
  display_name: R
  language: R
  name: ir
---

```{code-cell} r
:tags: [remove-input]

# Libraries just used for producing graphics in the page, not used 
# by any of the exercises.
```

# Practical Two: Species Distribution Modelling

## Required packages


There are many R packages available for species distribution modelling. If you search through the [CRAN package index](https://cran.r-project.org/web/packages/index.html) for 'species distribution', you will find over 20 different packages that do something - and that is only using a single search term. 

We are going to concentrate on the `dismo` package: it is a little old but provides a single framework to handle different model types. It also has an excellent **vignette** (a detailed tutorial on how to use the package) for further details:

https://cran.r-project.org/web/packages/dismo/vignettes/sdm.pdf

The following packages are required: these will be pre-installed in the RStudio Cloud project, but you will need to load them if you are working on your own machine

```r <!-- This is nicely styled but not executed by Jupyter. Basically, show don't run.-->
install.packages('raster') # Core raster GIS data package
install.packages('sf') # Core vector GIS data package
install.packages('sp') # Another core vector GIS package
install.packages('dismo') # Species Distribution Modelling
install.packages('rgdal') # Interface to the Geospatial Data Abstraction Library
install.packages('rJava') # R interface to the JAVA programming language
```

To load the packages:

```{code-cell} r
:tags: [remove-stderr]

library(rgdal)
library(raster)
library(sf)
library(sp)
library(dismo) # loads rJava
```

### Installing MaxEnt

We are going to be using the MAXENT species distribution modelling program. Using MaxEnt in R is a bit of a pain, because it requires the MAXENT program to be separately installed and also requires the `rJava` package. The RStudio Cloud project for this practical is all ready to go, but if you want to follow this on your own machine then you will need to:

1. Download the MAXENT program - this is a compiled Java program file `maxent.jar`:

[https://github.com/mrmaxent/Maxent/blob/master/ArchivedReleases/3.3.3k/maxent.jar?raw=true](https://github.com/mrmaxent/Maxent/blob/master/ArchivedReleases/3.3.3k/maxent.jar?raw=true)

2. Save that into the `dismo/java` folder in your R library.

MaxEnt is a very widely used program that uses a Maximum Entropy approach to fit species models. We are *not* going to be getting into the details of the way the algorithm works, but you can read up on that here:

> Elith, J., Phillips, S.J., Hastie, T., Dudík, M., Chee, Y.E. and Yates, C.J. (2011), A statistical explanation of MaxEnt for ecologists. Diversity and Distributions, 17: 43-57. [doi:10.1111/j.1472-4642.2010.00725.x](https://doi.org/10.1111/j.1472-4642.2010.00725.x)

It [has been pointed out](https://methodsblog.com/2013/02/20/some-big-news-about-maxent/) that MaxEnt is actually equivalent to a Generalised Linear Model (GLM), but we will use a few approaches here and MaxEnt is a framework that has been widely used and discussed.



## Introduction

This practical gives a basic introduction to species distribution modelling using R. We will be using R to characterise a selected species environmental requirements under present day climatic conditions and then projecting the availability of suitable climatic conditions into the future. This information will then be used to analyse projected range changes due to climate change. During this process we will analyse the performance of species distribution models and the impacts of threshold choice, variable selection and data availability on model quality.



## Data


There are two main inputs to a species distribution model. The first is a set of environmental raster layers – these are the variables that will be used to characterise the species’ environmental niche. The second is a set of points describing locations in which the species is known to be found – these points will be used to sample the environmental variables.

### Predictor variables

Several sources of different environmental data were mentioned in the lecture, but in this practical we will be using climatic variables to describe the environment. In particular, we will be using the BIOCLIM variables. These are based on simple temperature and precipitation values, but in 19 combinations that are thought to capture more biologically relevant aspects of the climate. These variables are described here:

[https://www.worldclim.org/data/bioclim.html](https://www.worldclim.org/data/bioclim.html)

The data we will us here have been downloaded using the `getData` function from the `raster` package, so should load directly. If you are using your own computer, this code will fetch the data first. The data consist of a stack of the 19 BIOCLIM variables at 10 arc-minute resolution (1/6th degree).

```{code-cell} r
# Load the data
bioclim_hist <- getData('worldclim', var='bio', res=10, path='data')
bioclim_2050 <- getData('CMIP5', var='bio', res=10, rcp=60, model='HD', year=50, path='data')

# Relabel the future variables to match the historical ones
names(bioclim_2050) <- names(bioclim_hist)

# Look at the data structure
print(bioclim_hist)
```

The two datasets loaded contain _historical_ climate data (1970-2000) and _projected future_ climate for 2050 taken from the Hadley model using [RCP 6.0](https://en.wikipedia.org/wiki/Representative_Concentration_Pathway). Note that this is CMIP5 data, which is now considered outdated, but is easy to download! Both these datasets are sourced from [http://www.worldclim.org](http://www.worldclim.org).

We can compare `BIO 1` (Mean Annual Temperature) between the two datasets:

```{code-cell} r
par(mfrow=c(3,1), mar=c(1,1,1,1))
# Create a shared colour scheme
breaks <- seq(-300, 350, by=20)
cols <- hcl.colors(length(breaks) - 1)
# Plot the historical and projected data
plot(bioclim_hist[[1]], breaks=breaks, col=cols)
plot(bioclim_2050[[1]], breaks=breaks, col=cols)
# Plot the temperature difference
plot(bioclim_2050[[1]] - bioclim_hist[[1]], col=hcl.colors(20, palette='Inferno'))
```

### Focal species distribution

We will be using the Mountain Tapir (_Tapirus pinchaque_) as an example species.

![_Tapirus pinchaque_. © Diego Lizcano](images/tapirus-pinchaque.jpg)
_Tapirus pinchaque_. © Diego Lizcano

I have picked this because it has a fairly narrow distribution but also because there is reasonable data in two distribution data sources:

* The IUCN Red List database: [Mountain Tapir](https://www.iucnredlist.org/species/21473/45173922), which is a good source of polygon species ranges. These ranges are usually _expert drawn maps_: interpretations of sighting data and local information.

* The GBIF database: [Mountain Tapir](https://www.gbif.org/species/2440899), which is a source of point observations of species. It is hugely important to be critical of point observation data and carefully clean it. There is a great description of this process in the `dismo` vignette on species distribution modelling:

```r
vignette('sdm')
```

We can view both kinds of data for this species. 

* The IUCN data is a single MULTIPOLYGON feature showing the discontinuous sections of the species' range. There are a number of feature attributes, described in detail in [this pdf](https://nc.iucnredlist.org/redlist/resources/files/1539098236-Mapping_Standards_Version_1.16_2018.pdf).

```{code-cell} r
tapir_IUCN <- st_read('data/iucn_mountain_tapir/data_0.shp')
print(tapir_IUCN)
```

* The GBIF data is a table of observations, some of which include coordinates. One thing that GBIF does is to publish a DOI for every download, to make it easy to track particular data use. This one is [https://doi.org/10.15468/dl.t2bkzx](https://doi.org/10.15468/dl.t2bkzx).

There are some tricks to loading the GBIF data. Although GBIF use the file `.csv` suffix, the file is in fact _tab_ delimited so we need to use `read.delim()`. There is a lot of text data in the file, so the option `stringsAsFactors=FALSE` to turn off R's daft default behaviour of turning all text fields into categorical variables is really useful. Lastly, we need to remove rows with no coordinates.

```{code-cell} r
# Load the data frame
tapir_GBIF <- read.delim('data/gbif_mountain_tapir.csv', 
                         stringsAsFactors=FALSE)
# Drop rows with missing coordinates
tapir_GBIF <- subset(tapir_GBIF, ! is.na(decimalLatitude) | ! is.na(decimalLongitude))
# Convert to an sf object
tapir_GBIF <- st_as_sf(tapir_GBIF, coords=c('decimalLongitude', 'decimalLatitude'))
print(tapir_GBIF)
```

We can now superimpose the two datasets to show they _broadly_ agree. There aren't any obvious problems that require data cleaning.

```{code-cell} r
# Load some (coarse) country background data
ne110 <- st_read('data/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp')
```

```{code-cell} r
# Create a cropping area to plot
model_extent <- extent(c(-85,-70,-5,12))

# Plot the species data over a basemap
plot(st_geometry(ne110), xlim=model_extent[1:2], ylim=model_extent[3:4], 
     bg='lightblue', col='ivory')
plot(st_geometry(tapir_IUCN), add=TRUE, col='grey', border=NA)
plot(st_geometry(tapir_GBIF), add=TRUE, col='red', pch=4, cex=0.6)
box()
```

### Pseudo-absence data

Many of the methods below require **absence data**, either for fitting a model or for evaluating the model performance. Rarely, we might actually have real absence data from exhaustive surveys, but usually we only have presence data.

A really useful starting point for this topic is the following study:

> Barbet‐Massin, M., Jiguet, F., Albert, C.H. and Thuiller, W. (2012), Selecting pseudo‐absences for species distribution models: how, where and how many?. Methods in Ecology and Evolution, 3: 327-338. [doi:10.1111/j.2041-210X.2011.00172.x](doi:10.1111/j.2041-210X.2011.00172.x)

### Testing and training dataset 

One important part of the modelling process is to keep separate data for *training* the model (the process of fitting the model to data) and for *testing* the model (the process of checking model performance). Here we will use a 20:80 split - retaining 20% of the data for testing. 

```{code-cell} R
# Use kfold to add labels to the data, splitting it into 5 parts
tapir_GBIF$kfold <- kfold(tapir_GBIF, k=5)
```

One other important concept in test and training is **cross validation**. This is where a model is fitted and tested multiple times, using different subsets of the data, to check that model performance is not dependent on one specific partition of the data. One common approach is *k-fold* cross-validation (hence the function name above). This splits the data into $k$ partitions and then uses each partition in turn as the test data.

If you come to use species distribution models in research, it is worth reading the following paper on an alternative approach to model evaluation that moves away from the standard performance statistics towards a more ecologically informed approach.

> Warren, DL, Matzke, NJ, Iglesias, TL. Evaluating presence‐only species distribution models with discrimination accuracy is uninformative for many applications. J Biogeogr. 2020; 47: 167– 180. [https://doi.org/10.1111/jbi.13705](https://doi.org/10.1111/jbi.13705).





## The BIOCLIM model

One of the earliest species distribution models is BIOCLIM. 

> Nix, H.A., 1986. A biogeographic analysis of Australian elapid snakes. In: Atlas of Elapid Snakes of Australia. (Ed.) R. Longmore, pp. 4-15. Australian Flora and Fauna Series Number 7. Australian Government Publishing Service: Canberra.

It is not a particularly good method, but it is possible to use it with **only species presence data**. The way the model works is to sample environmental layers at species locations. A cell in the wider map then gets a score based on how close to the species' median value for each layer it is. 

This kind of approach is often called a _bioclimatic envelope_, which is where the model name comes from. The BIOCLIM *variables* that we loaded earlier were designed to be used with the BIOCLIM algorithm.

The first thing to do is to crop the environmental data down to a sensible modelling region. What counts as _sensible_ here is very hard to define and you may end up changing it when you see model outputs, but here we use a small subset to make things run quickly.

```{code-cell} r
# Reduce the global maps down to the species' range
bioclim_hist_local <- crop(bioclim_hist, model_extent)
bioclim_2050_local <- crop(bioclim_2050, model_extent)
```
 We can now fit a bioclimatic envelope - we need the environmental layers and a matrix of XY coordinates for the training data showing where the species is observed. The `st_coordinates` function is a useful `sf` function for extracting point coordinates: it does also work with lines and polygons, but the output is much more complex!

```{code-cell} R
# Get the coordinates of 80% of the data for training 
train_locs <- st_coordinates(subset(tapir_GBIF, kfold != 1))
# Fit the model
bc <- bioclim(bioclim_hist_local, train_locs)
```

We can now plot the model output to show the envelopes. In the plots below, the argument `p` is used to show the climatic envelop that contains a certain proportion of the data. The `a` and `b` arguments set which layers in the environmental data are compared.

```{code-cell} r
par(mfrow=c(1,2))
plot(bc, a=1, b=2, p=0.9)
plot(bc, a=1, b=5, p=0.9)
```

In that second plot, note that these two variables (mean annual temperature `BIO1` and maximum temperature of the warmest month 'BIO5') are **extremely strongly correlated**. This is not likely to be an issue for this method, but in many models it is a **very bad idea** to have strongly correlated explanatory variables: it is called **[Multicollinearity](https://en.wikipedia.org/wiki/Multicollinearity)** and can cause serious statistical issues.

We've now fitted our model and can use the model parameters to predict the `bioclim` score for the whole map. Note that a lot of the map has a **score of zero**: none of the environmental variables in these cells fall within the range seen in the occupied cells.

```{code-cell} r
pb <- predict(bioclim_hist_local, bc)
# create a land map (scores of 0 or more) and then set the
# zero scores to be NA
land <- pb >= 0
pb[pb == 0] <- NA
plot(land, col='grey', legend=FALSE)
plot(pb, col=hcl.colors(20, palette='Blue-Red'), add=TRUE)
```

We can also now evaluate our model using the retained test data.

```
test_locs <- st_coordinates(subset(tapir_GBIF, kfold == 1))
evaluate(p=test_locs, a=NULL, bc)



## Fitting a MaxEnt model

```r
# This is crashing all over the shop
mod <- maxent(bioclim_hist, as(tapir_GBIF, 'Spatial'))
```


 plot(mod)
