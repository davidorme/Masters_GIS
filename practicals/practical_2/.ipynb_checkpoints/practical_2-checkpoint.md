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

[https://github.com/mrmaxent/Maxent/blob/master/ArchivedReleases/3.3.3k/maxent.jar?raw=true]()

2. Save that into the `dismo/java` folder in your R library.

MaxEnt is a very widely used program that uses a Maximum Entropy approach to fit species models. We are *not* going to be getting into the details of the way the algorithm works, but you can read up on that here:

> Elith, J., Phillips, S.J., Hastie, T., Dudík, M., Chee, Y.E. and Yates, C.J. (2011), A statistical explanation of MaxEnt for ecologists. Diversity and Distributions, 17: 43-57. [doi:10.1111/j.1472-4642.2010.00725.x](https://doi.org/10.1111/j.1472-4642.2010.00725.x)

It [has been pointed out](https://methodsblog.com/2013/02/20/some-big-news-about-maxent/) that MaxEnt is actually equivalent to a Generalised Linear Model (GLM), but we will use a few approaches here and MaxEnt is a framework that has been widely used and discussed.



## Introduction

This practical gives a basic introduction to species distribution modelling using R. We will be using R to characterise a selected species environmental requirements under present day climatic conditions and then projecting the availability of suitable climatic conditions into the future. This information will then be used to analyse projected range changes due to climate change. During this process we will analyse the performance of species distribution models and the impacts of threshold choice, variable selection and data availability on model quality.


### Focal species 

We will be using the Mountain Tapir (_Tapirus pinchaque_) as an example species.

![_Tapirus pinchaque_. © Diego Lizcano](images/tapirus-pinchaque.jpg)
_Tapirus pinchaque_. © Diego Lizcano

I have picked this because it has a fairly narrow distribution but also because there is reasonable data in two distribution data sources:

* The IUCN Red List database: [Mountain Tapir](https://www.iucnredlist.org/species/21473/45173922), which is a good source of polygon species ranges. These ranges are usually _expert drawn maps_: interpretations of sighting data and local information.

* The GBIF database: [Mountain Tapir](https://www.gbif.org/species/2440899), which is a source of point observations of species. It is hugely important to be critical of point observation data and carefully clean it. There is a great description of this process in the `dismo` vignette on species distribution modelling:

```r
vignette('sdm')
```
