---
title: GIS concepts
author: David Orme
---

<!-- .slide: data-background-image="../shared_images/World3D_600.png"  data-background-position="right 10px bottom 20px"  data-background-size="40%" -->
# GIS concepts

### David Orme

---

# What is a GIS?

![](images/droppedImage-107.png)<!-- .element height="250px"  --> 
![](images/droppedImage-118.png)<!-- .element height="250px" --> 
![](images/droppedImage-110.png)<!-- .element height="250px" --> 
![ 113](images/droppedImage-113.png)<!-- .element height="200px"--> 
![](images/crime.png)<!-- .element height="200px" --> 

----

# What is a GIS?

Many things to many people but at core is any system used for:

  - creating,
  - storing,
  - manipulating,
  - analysing and
  - presenting geographic information

----

# What is <ins>geographic information</ins>?

<div class='container'>
<div class='col1'>

![](images/Treasure-Island-map-129.jpg)

</div>
<div class='col2 leftpad'>

Any piece of data that can be located in space, using:
 
 <div class='vs'></div>
 
  - A set of coordinates
  - A known coordinate system

 <div class='vs'></div>


Without **both** of these bits of information, we do not have geographic information!

</div>
</div>

---


# Spherical coordinates

<div class='container'>
<div class='col2 rightpad'>

**Latitude** 

  - an angle above or below the equator
  - points of equal latitude form a parallel
  - distance between parallels is constant*

</div>
<div class='col1'>

![](images/World3D_Lat-133.png)

</div>
</div>

Notes:
Not quite constant because of flattening. 1 degree of latitude is:

* 110574m at Equator
* 111694m at Poles

----

# Spherical coordinates

<div class='container'>
<div class='col2 rightpad'>

**Longitude**:

  - an angle around the equator
  - points of equal longitude form a meridian
  - distance between meridians varies

</div>
<div class='col1'>

![](images/World3D_Long-137.png)

</div>
</div>

----

# Spherical coordinates

<div class='container'>
<div class='col2 rightpad'>

**Latitude and longitude**:

  - 90°0’0” E, 30°0’0” N
  - 90.00 E, 30.00 N
  - Can include height:
  - Near Lhasa, Tibet   (c. 5,500 m)

</div>
<div class='col1'>

![](images/World3D_LL-141.png)

</div>
</div>

Notes:
* What is 5,500m a measurement from? 
* What do we need to make our coordinate system.

---

# Geographic coordinate system

* The Earth is not a sphere (~ 1 in 298 flattening)
* There are **many** reference ellipsoids or datums.

<div class='vs'></div>

| Name 	| r<sub>equator</sub> (m) 	| r<sub>poles</sub> (m) 	|
|---	|---:	|---:	|
| Airy 1830	| 6,377,563.4	| 6,356,256.91	|
| Clarke 1866	| 6,378,206.4	| 6,356,583.8	|
| International 1924	| 6,378,388	| 6,356,911.9	|
| WGS 1984	| 6,378,137	| 6,356,752.31	|

----

# Geographic coordinate system


  - Unfortunately, the Earth isn’t a ellipsoid either.
  - Distribution of mass is uneven and dynamic

<div class='vs'></div>
<div class='container'>
<div class='col1'>

![](images/droppedImage-149.png)

</div>
<div class='col1'>

![](images/droppedImage-146.png)

</div>
</div>

----

# Geographic coordinate system

<div class='container'>
<div class='col2 rightpad'>

**Geoid**

  - Surface of equal gravitational force
  - Up and down are **perpendicular** to the local geoid
  - A level surface is **tangent** to the local geoid

</div>
<div class='col1'>

 <div class='vs'></div>

![Grace Gravity Model 3](images/ggm01-200.gif) <!-- .element width="100%"  --> 

</div>
</div>

Notes:
* Down does not necessarily go through the centre of the earth

----

# Geographic coordinate system

![](images/cross_section-156.png)

Notes:
GPS uses height above ellipsoid
- can lead to problems relative to sea level.
- receivers contain a low resolution look up table for the separation.

----

# WGS 84

<div class='container'>
<div class='col2 rightpad'>

  - Combined datum and geoid giving a standard global coordinate system
  - Uses modern satellite data to provide ellipsoid measurements and gravity model
  - Used by GPS
  - Prime meridian: 0°0’5.31”E !

</div>
<div class='col1'>

![D8910 1](images/d8910_1.jpg)

</div>
</div>

Notes:
* International Reference Meridian
* Currently 100m East of Greenwich Meridian and moving!
* Local vs geocentric vertical

---

# Local geographic datum

<div class='container'>
<div class='col1 rightpad'>

  - The fit between a geoid and a datum varies in space
  - Global models, like WGS 84, work well on average
  - Countries adopt local datum models that fit better locally

</div>
<div class='col1'>

![](images/regional-163.png)

</div>
</div>

----

# Local geographic datum

<div class='container'>
<div class='col2 rightpad'>

  - British National Grid uses the **OSGB 36 datum**
  - Same latitude & longitude + different datum = datum shift
  - In Cornwall, a WGS 84 point is ~70 m east and ~ 70 m south of OSGB 36.
  - The shift varies nationally

</div>
<div class='col1'>

![](images/Silwood_1_25000-166.png)

</div>
</div>

----

# Datum shift

![](images/datum_shift.png)<!-- .element width="75%"  --> 

---

# Spherical geometry

<div class='container'>
<div class='col3 rightpad'>

  - Great circles
  - Spherical ‘triangle’
  - **Spherical** geometry:
     - exact and fast
  - **Ellipsoidal** geometry:
     - iterative and slow

</div>
<div class='col2'>

![](images/SphericalGeometry.svg)<!-- .element width="100%"  --> 

</div>
</div>

Notes:
Great circle
- where a plane through the centre hits the surface
 - shortest distance by haversine formula
Triangle
- angles sum to more than 180

----

# Spherical geometry

<div class='container'>
<div class='col3 rightpad'>

  - Globes not convenient or easily scalable
  - Precise calculations slow
  - Not easily useable on flat
screen or on paper
  - Need a flat representation of space

</div>
<div class='col2'>

![](images/SphericalGeometry.svg)<!-- .element width="100%"  --> 

</div>
</div>

---

# Projected coordinate systems


<div class='container'>
<div class='col2 rightpad'>

> It is impossible to project an spherical surface onto a plane without distortion (Gauss, 1827).

</div>
<div class='col3'>

![](images/terrys_chocolate_orange.png)<!-- .element width="90%"  --> 

</div>
</div>

Notes:
  - The ellipsoid surface of the Earth for small distances (~ 10 km) is flat enough for simple purposes but for anything else...

----

# Projected coordinate systems

<div class='leftpad'>

Map projections can preserve:

  - **Shape**: conformal maps
  - **Area**: equal-area maps
  - **Distance**: equi-distant maps   
  - **Direction**: azimuthal maps

But most projected coordinate systems can only preserve **one** of these things.

</div>

----

# Projected coordinate systems

<div class='container'>
<div class='col3 rightpad'>

**Tissot indicatrix**:

  - An circle on the surface of the Earth.
  - All points on the edge are equidistant from the center.
  - Show distortion of ellipsoid surface on planar projections

</div>
<div class='col2'>

![Orthographic](images/Orthographic.png)<!-- .element width="100%"  --> 

</div>
</div>

----

# Projected coordinate systems

**Equirectangular**:  latitude and longitude as X and Y

![Equirectangular](images/Equirectangular.png)

Notes:
Doesn’t preserve anything much,
- distance/scale along vertical lines (great circles)

----

# Projected coordinate systems

Classification according to mapping to planar surface:

![Planar     Cylindrical     Conical](images/Projection%20types-193.png)

----

# Projected coordinate systems

**Gnomonic**: planar, preserves bearings from a single central point, but little else.

<div class='container'>
<div class='col2'>

![](images/gnomon.svg)

</div>
<div class='col3'>

![](images/SilwoodGnomonic-197.png)<!-- .element width="65%"  --> 

</div>
</div>

Notes:
Great circles in all directions from centre of map

----

# Projected coordinate systems

**Cylindrical**: preserves area, not shape

<div class='container'>
<div class='col1'>

![](images/cylindrical.svg)

</div>
<div class='col3'>

![](images/Behrmann-205.png)

</div>
</div>

Notes:
Imagine running an old fluorescent tube down the middle and turning it on.
Behrmann projection
* Notice compression of higher latitudes

----

# Projected coordinate systems
 
 **Mercator**: preserves shape, not scale

![](images/Mercator-209.png)

Notes:
Inflate spherical balloon inside a cylinder coated with glue

----

# Projected coordinate systems

**Fuller Dymaxion**: compromise projection

![](images/Fuller-213.png)

Notes:
Local projections onto triangular planes Borders go through sea
No up or down

---

# Geographic data

<div class='leftpad'>

  - A **Coordinate system** and:
    - **Vector** data: coordinates of points, lines, polygons
    - **Raster** data
        - grid data
        - satellite and aerial images

</div>

----

# Raster data

<div class='leftpad'>

An **image** covering a continuous surface

  - Made up of individual **pixels**, each with a **value**
    - Categorical: land cover, species presence
    - Continuous: temperature, precipitation
  - Has a **resolution** (pixel size)
  - Needs **origin** and coordinate system

</div>

----

# Raster data

<div class='container'>
<div class='col1'>

![](images/UK_GTOPO-223.png)

</div>
<div class='col1'>

![](images/MammalThreat-226.png)
![](images/Silwood_1_25000-166.png)<!-- .element width="70%"  -->

</div>
</div>

----

# Vector Data

<div class='leftpad'>

A set of *features*, containing one of:

  - Individual **points**, or sets of connected points forming **lines** or **polygons**
  - Needs a coordinate system
  - Coordinates are  a precise location, but may have precision or accuracy information
  - Features may have an attribute table.

</div>

----

# Vector Data

<div class='container'>
<div class='col1'>

![](images/UK_Ecoregions-233.png)

</div>
<div class='col1'>

![](images/RedDeer-236.png)
![](images/SilwoodPointLine-239.png)<!-- .element width="70%"  -->

</div>
</div>

----

# Data comparison

<div class='container'>
<div class='col1 leftpad'>

**Raster**

* Fixed grid
* One value per pixel per bands
* Often multiple stacked bands
* Attribute tables for _values_ (VAT)

</div>
<div class='col1 leftpad'>

**Vector**

* Features with arbitrary shapes
* Attribute tables for _features_

</div>
</div>
