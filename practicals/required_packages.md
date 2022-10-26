---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.11.5
kernelspec:
  display_name: R 4.2.0
  language: R
  name: ir420
---

# Required packages and data

If you are running these practicals on your own laptop then you will need to install
quite a few packages to get the code to run

## Required packages

The following sections give the core packages required and then practical specific
packages.

## Core GIS function and data packages

``` {code-cell} r
install.packages('terra')    # Core raster GIS data package
install.packages('sf')       # Core vector GIS data package
install.packages('raster')   # Older raster GIS package required by some packages
install.packages('geodata')  # Data downloader

install.packages('sp')        # Older vector GIS package - replaced by sf in most cases
install.packages('rgeos')     # Extended vector data functionality
install.packages('rgdal')     # Interface to the Geospatial Data Abstraction Library
install.packages('lwgeom')    # Lightweight geometry engine
```

### Practical 1

``` {code-cell} r
install.packages('openxlsx')   # Read data from Excel 
install.packages('ggplot2')    # Plotting package
install.packages('gridExtra')  # Extensions to ggplot
```

### Practical 2

``` {code-cell} r
install.packages('dismo')      # Species distribution models
```

### Practical 3

``` {code-cell} r
install.packages('ncf')          
install.packages('SpatialPack')  # Spatial clifford test
install.packages('spdep')        # Spatial dependence models
install.packages('spatialreg')   # Spatial regression using lags
install.packages('nlme')         # GLS models
install.packages('spgwr')        # Geographic weighted regression
install.packages('spmoran')      # Moran's I and Geary C
```

### Landscape Ecology Week

``` {code-cell} r
install.packages('landscapemetrics')
install.packages('vegan')
```

## Required Data

Download and extract the `data.zip` file into your R project working directory. This is
a single large (~190 MB) file that contains all of the data required for all the
practicals.

Make sure that:

* the resulting folder is called `data` and,
* that your practical scripts are in the root of the project.

This should ensure that the paths used in the practical match your local setup.
