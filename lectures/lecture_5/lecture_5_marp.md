---
marp: true
title: Spatial modelling
author: David Orme
theme: gaia-local
---

<!-- markdownlint-disable MD024 MD025 MD033 MD035 MD036-->

# Spatial modelling

## David Orme

![bg width:400px](../shared_images/World3D_600.png)

---

# Spatial modelling tools

- The examples presented here use R
- Another excellent program with a nice GUI interface:
    - Spatial Analysis in Macroecology
    - http://www.ecoevol.ufg.br/sam/

<center>

![Samlogo w:250](Images/samlogo.jpg)

</center>

---

# Overview

- Example data: Afrotropical bird diversity
- Naive models
- Describing spatial autocorrelation
- Accounting for spatial autocorrelation



---

# Afrotropical bird species richness

![plot of chunk bird_rich](figure/bird_rich-1.png)

<!--
Introducing the data
Projected data - coordinates in km on Behrmann grid
100km resolution
-->
----

# Explanatory variables

![plot of chunk bird_rich_pred](figure/bird_rich_pred-1.png)

<!--
A few simple observations:
- lots of rain and vegetation in the congo.
- pretty warm in the sahara
- the great rift is called that for a reason.

Smoothers on the data
- No way you’d want to fit this as a simple linear model
-->

----

# A simple linear model

**Richness ~ AET + Temperature + Elevation**


|            |    Est|    SE|     t|p       |
|:-----------|------:|-----:|-----:|:-------|
|(Intercept) | 189.45| 21.33|  8.88|< 0.001 |
|MeanAET     |   0.18|  0.00| 37.34|< 0.001 |
|MeanAnnTemp |  -4.18|  0.72| -5.79|< 0.001 |
|MeanElev    |   0.08|  0.01| 13.85|< 0.001 |

----

# A simple GAM

**Richness ~ s(AET) +s( Temperature) + s(Elevation)**

![plot of chunk simple_glm](figure/simple_glm-1.png)

----

# Model predictions

![plot of chunk simple_pred](figure/simple_pred-1.png)

<!--
Not great models:
 - Overpredict in Madagascar
 - GAM does better in Congo

OK - so what is the problem?
-->

---


# Neighbourhoods



<div class='columns'>
<div>

![plot of chunk nb_rook](figure/nb_rook-1.png)

</div>
<div>

**Rooks move**

All cells within one step: 

- vertically or
- horizontally

</div>
</div>

<!--
Neighbours on a grid
Bit different for polygons, shared edges etc. but similar concepts
-->

----

# Neighbourhoods


<div class='columns'>
<div class='col2'>

![plot of chunk nb_queen](figure/nb_queen-1.png)

</div>
<div>

**Queens move**

All cells within one step:

- vertically,
- horizontally or
- diagonally

</div>
</div>


----

# Neighbourhoods

<div class='columns'>
<div>


![plot of chunk nb_dnn](figure/nb_dnn-1.png)

</div>
<di>

**Distance based**

All cells within:

- 2.4 units

</div>
</div>


----

# Neighbourhoods



<div class='columns'>
<div>

![plot of chunk nb_knn](figure/nb_knn-1.png)

</div>
<div>

**_k_ nearest**

The closest _k_ cells


</div>
</div>

----

# Spatial autocorrelation

<div class='columns'>
<div>

![plot of chunk moran_real](figure/moran_real-1.png)

</div>
<div>

Global Moran's I 

- I = 0.922
- p << 0.001


Global Geary's C 

- C = 0.070
- p << 0.001

</div>
</div>

<!--
Point close together are similar
 - how do we characterise this?
 - useful summary - global value
 - is there spatial autocorrelation - well, duh!

 Moran’s I - correlation measure (usually 0 to 1)
 Geary's C - 1 to 0
-->

----

# Spatial autocorrelation

<div class='columns'>
<div>

![plot of chunk moran_rand](figure/moran_rand-1.png)

</div>
<div>

Global Moran's I

- I = -0.001
- p =  0.534


Global Geary's C 

- C = 0.999
- p =  0.475

</div>
</div>

----

# Local autocorrelation
 
Local indicators of spatial autocorrelation (LISA)
 
![plot of chunk lisa](figure/lisa-1.png)

<!--
Look at strength of spatial autocorrelation within neighbourhoods
Using species richness data
Blocks of colour show significant autocorrelation
Not a monotonic process - will return to this later
-->

---

# Effects of Spatial Autocorrelation
 
- Data points **not independent**
- Degrees of freedom reduced: 
    - **standard errors and significance testing affected**
- Not equally weighted :
    - **parameter estimation affected**

<!--
Degrees of freedom - tends to bias towards finding significance
Parameters - can affect estimates in unpredictable ways
-->

----

# Dealing with Spatial Autocorrelation

- Modify the degrees of freedom in significance testing
- Account for autocorrelation in models:
    - Simultaneous autoregressive models
    - Generalised least squares
    - Eigenvector filtering
    - Geographically weighted regression

----

# Degrees of freedom correction 


![plot of chunk clifford_t_pre](figure/clifford_t_pre-1.png)

<!--
Clifford test for correlation
 - use all the lags to characterise the global autocorrelation
 - work out the effective degrees of freedom
 - 2484 down to...

Other methods can correct the degrees of freedom in a simple linear model
-->

----

# Degrees of freedom correction 


![plot of chunk clifford_t](figure/clifford_t-1.png)

<!--
Clifford test for correlation
 - use all the lags to characterise the global autocorrelation
 - work out the effective degrees of freedom
 - 2484 down to...

Other methods can correct the degrees of freedom in a simple linear model
-->

----

# Spatial Autoregression

<div class="columns21">
<div>

| <span class='dot'></span>  | <span class='dot'></span>  | <span class='dot'></span>  | <span class='dot'></span>  |   |
|---|---|---|---|:---:|
| <span class='dotr'></span>	| <span class='dotg'></span>	| <span class='dot'></span>	| <span class='dot'></span> | $bx_1 +  \frac{1}{2}bx_2$  |
| <span class='dotg'></span>	| <span class='dotr'></span>	| <span class='dotg'></span>	| <span class='dot'></span> | $\frac{1}{2}bx_1 +  bx_2  + \frac{1}{2}bx_3$ |
| <span class='dot'></span>	| <span class='dotg'></span>	| <span class='dotr'></span>	| <span class='dotg'></span> | $\frac{1}{2}bx_2 +  bx_3  + \frac{1}{2}bx_4$  |
| <span class='dot'></span>	| <span class='dot'></span>	| <span class='dotg'></span>	| <span class='dotr'></span> | $\frac{1}{2}bx_3 +  \frac{1}{2}bx_4$  |
| $x_1$  |  $x_1$ |  $x_3$ |  $x_4$  |   |

</div>
<div>

The best fit for coefficient $b$ is influenced by the neighbour and weightings schemes.

</div>
</div>

<!--
Simple one dimensional example
- neighbour definition and _weights_ (red=1, green=0.5)
- influence of neighbouring values
- simultaneuous equations.
-->

----

# Spatial Autoregresssion



![plot of chunk sarlm_plot](figure/sarlm_plot-1.png)

<!--
Very good predictions - not even including interactions!
Autocorrelation in the residuals are very small
-->

---

# Spatial Autoregresssion

<small>

````{}

Call:lagsarlm(formula = Rich ~ MeanAETScaled + MeanAnnTempScaled + 
    MeanElevScaled, data = figDat@data, listw = figDat.lw, type = "lag")

Residuals:
        Min          1Q      Median          3Q         Max 
-266.301618   -9.585387   -0.050679    9.997008  105.697309 

Type: lag 
Coefficients: (asymptotic standard errors) 
                  Estimate Std. Error z value  Pr(>|z|)
(Intercept)        3.03299    0.70394  4.3086 1.643e-05
MeanAETScaled      2.84545    0.48197  5.9037 3.553e-09
MeanAnnTempScaled  1.34439    0.65707  2.0460   0.04075
MeanElevScaled     5.77947    0.69995  8.2570 2.220e-16

Rho: 0.98408, LR test value: 6043.7, p-value: < 2.22e-16
Asymptotic standard error: 0.0025867
    z-value: 380.44, p-value: < 2.22e-16
Wald statistic: 144730, p-value: < 2.22e-16

Log likelihood: -11459.21 for lag model
ML residual variance (sigma squared): 462.9, (sigma: 21.515)
Number of observations: 2484 
Number of parameters estimated: 6 
AIC: 22930, (AIC for lm: 28972)
LM test for residual autocorrelation
test value: 497.74, p-value: < 2.22e-16
````

</small>

----

# Correlogram

![plot of chunk correlogram](figure/correlogram-1.png)

<!--
Correlograms

2484 points
	2484*2483/2 = 3083886 pairwise distances
	distance falling into 100km bands

Distance at which correlation hits the x axis
Notice negative autocorrelation at distance
Reliability of measures at distance is very poor
-->

----

# Variogram

![plot of chunk variogram](figure/variogram-1.png)

<!--
Variograms
 - same idea but viewed from other end
 - if points are similar then the variance within nearby classes will be small
 - eventually get to a point where the variance is not distinguishably lower
 - about in the same place
-->

----

# Generalised Least Squares

<div class='columns'>
<div>
	
![plot of chunk gls1](figure/gls1-1.png)

</div>
<div>

- Model variance as a function of **distance** 
- Generate a covariance **matrix**

</div>
</div>


<!--
Not specifically a spatial method
 - allows for all sorts of structure in the data
 - mixed effects models
 - variance structures
 - correlation structure

Wider range of variance modelling
- define a function that captures the shape of the variogram with distance
- exponential, spherical, linear
- parameters: nugget, sill, range
-->



----

# Generalised Least Squares

<div class='columns21'>
<div>
	
![plot of chunk gls2](figure/gls2-1.png)

</div>
<div>

- Different shapes:
    - Exponential
    - Spherical
    - Linear

- Parameters

</div>
</div>

----

# Generalised Least Squares

<small>

````{}
Generalized least squares fit by REML
  Model: Rich ~ MeanAETScaled + MeanAnnTempScaled + MeanElevScaled 
  Data: figDat 
       AIC      BIC    logLik
  24676.89 24705.97 -12333.44

Correlation Structure: Gaussian spatial correlation
 Formula: ~e_centre_behr + n_centre_behr 
 Parameter estimate(s):
 range nugget 
 650.0    0.1 

Coefficients:
                      Value Std.Error   t-value p-value
(Intercept)       199.67323 16.755430 11.916927  0.0000
MeanAETScaled      17.65050  3.038337  5.809265  0.0000
MeanAnnTempScaled -27.53775  5.663121 -4.862645  0.0000
MeanElevScaled      3.59893  4.321932  0.832712  0.4051

 Correlation: 
                  (Intr) MnAETS MnAnTS
MeanAETScaled     0.048               
MeanAnnTempScaled 0.141  0.047        
MeanElevScaled    0.156  0.079  0.936 

Standardized residuals:
        Min          Q1         Med          Q3         Max 
-2.35080108  0.09376345  0.73813223  1.30659392  4.48588628 

Residual standard error: 97.85917 
Degrees of freedom: 2484 total; 2480 residual
````

</small>

---

# Stationarity and isotropy
	
Is the same process happening in:

- different locations (stationarity)?
- different directions (isotropy)?

Is the problem in:

- the spatial structure of autocorrelation?
- differences in the actual relationship?

----

# Eigenvector filtering

- Take the **eigendecomposition** of a spatial weights model
- Use the  **eigenvectors** as variables in the model
- Use a selection process to identify and include only important eigenvectors

<!--
- Identical process to principal component analysis
- Eigenvectors identify independent axes of variation in the model
- Separate out aspects of autocorrelation
- Tailor the autocorrelation
- Each eigenvector soaks up a residual degree of freedom
-->

----

# Eigenvector filtering



<div class="columns21">
<div>

![plot of chunk eigen_plot](figure/eigen_plot-1.png)

</div>
<div>

- First four eigenvector filters
- Independent components of spatial patterning 

</div>
</div>





<!--
First four eigenvectors
 - describe independent trends in the spatial autocorrelation
 - (actually real parts of complex eigenvectors)
-->

----

# Eigenvector filtering

	
`lm(Rich ~ MeanAET + MeanAnnTemp + MeanElev`

<small>


|            |    Est|    SE|     t|p       |
|:-----------|------:|-----:|-----:|:-------|
|(Intercept) | 189.45| 21.33|  8.88|< 0.001 |
|MeanAET     |   0.18|  0.00| 37.34|< 0.001 |
|MeanAnnTemp |  -4.18|  0.72| -5.79|< 0.001 |
|MeanElev    |   0.08|  0.01| 13.85|< 0.001 |

</small>


----

# Eigenvector filtering

`lm(Rich ~ ... + Re(spEV1) + Re(spEV2) + Re(spEV3) + Re(spEV4)`

<small>


|            |     Est|     SE|     t|p       |
|:-----------|-------:|------:|-----:|:-------|
|(Intercept) |   79.95|  33.00|  2.42|1.5e-02 |
|MeanAET     |    0.18|   0.01| 31.45|< 0.001 |
|MeanAnnTemp |    0.11|   1.14|  0.09|9.3e-01 |
|MeanElev    |    0.08|   0.01| 12.71|< 0.001 |
|Re(spEV1)   | 1617.43|  77.65| 20.83|< 0.001 |
|Re(spEV2)   | -964.81| 129.21| -7.47|< 0.001 |
|Re(spEV3)   |  813.41|  95.80|  8.49|< 0.001 |
|Re(spEV4)   |  147.25| 100.29|  1.47|1.4e-01 |

</small>

----

# Eigenvector filtering


`lm(Rich ~ ...  + Re(spEV1) + Re(spEV2) + Re(spEV3)`


<small>


|            |      Est|     SE|     t|p       |
|:-----------|--------:|------:|-----:|:-------|
|(Intercept) |    58.55|  29.62|  1.98|4.8e-02 |
|MeanAET     |     0.19|   0.00| 43.67|< 0.001 |
|MeanAnnTemp |     0.74|   1.06|  0.70|4.8e-01 |
|MeanElev    |     0.08|   0.01| 13.78|< 0.001 |
|Re(spEV1)   |  1610.70|  77.53| 20.78|< 0.001 |
|Re(spEV2)   | -1031.06| 121.10| -8.51|< 0.001 |
|Re(spEV3)   |   847.10|  93.03|  9.11|< 0.001 |

</small>

----

# Geographically weighted regression

Fit a model for **every cell**:

- Define a local **region size** and a **weighting function**
- Fit a weighted regression for each cell using the weights
- Look at how coefficients **vary in space**
- Possibly serious statistical issues!

----

# Geographically weighted regression



![plot of chunk gwr_pred](figure/gwr_pred-1.png)

<!--
Fit a weighted regression to geographic subsets of the data.

Neighbourhood size
 - bandwidth or proportion of data
Weighting
 - weighted by normal Gaussian curve (black)
 - weighted based on squared distance

Not fitting a single regression - fitting 2484 regressions - but they are simple
-->

----


# Geographically weighted regression

<div class="columns">
<div>

![plot of chunk gwr_rsq](figure/gwr_rsq-1.png)

</div>
<div>

- Local $r^2$ values
- Variation in the explanatory power of the model

</div>
</div>

---

# Problems

- Profusion of packages: sf, sp, spdep, mgcv, ncf, gstat, nlme, spgwr
- Different data structures
- Sometimes poor documentation
- Speed of calculation (= size of dataset)
- Memory hungry
- Too many options
