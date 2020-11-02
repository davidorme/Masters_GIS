---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  display_name: R
  language: r
  name: ir
---


```{code-cell} R
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

```{code-cell} R
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
