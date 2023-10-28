---
marp: true
title: GIS concepts
author: David Orme
theme: gaia-local
---

<!-- markdownlint-disable MD024 MD025 MD033 MD035 MD036-->

# GIS concepts

## David Orme

![bg width:400px](../shared_images/World3D_600.png)

---

# What is a GIS?

<div class='columns3'>
<div>

![stack h:250px](images/droppedImage-107.png)
![remote image h:250px](images/droppedImage-118.png)

</div>
<div>

![watershed h:250px](images/droppedImage-110.png)
![mars h:250px](images/droppedImage-113.png)

</div>
<div>

![crime db h:250px](images/crime.png)

</div>
</div>
----

# What is a GIS?

Many things to many people but at core is any system used for:

- creating,
- storing,
- manipulating,
- analysing and
- presenting geographic information

----

# What is geographic information?

<div class='columns12'>
<div>

![treasure_island_map w:300px](images/Treasure-Island-map-129.jpg)

</div>
<div>

Any piece of data that can be located in space, using:

- A set of coordinates
- A known coordinate system

Without **both** of these bits of information, we do not have geographic information!

</div>

---

# Spherical coordinates

<div class='columns21'>
<div>

**Latitude**

- an angle **above or below** the equator
- points of equal latitude form a **parallel**
- distance between parallels is constant*

</div>
<div>

![world lat lines w:450px](images/World3D_Lat-133.png)

</div>

<!--
Not quite constant because of flattening. 1 degree of latitude is:

- 110574m at Equator
- 111694m at Poles
-->

----

# Spherical coordinates

<div class='columns21'>
<div>

**Longitude**:

- an angle **around** the equator
- points of equal longitude form a **meridian**
- distance between meridians **varies**

</div>
<div>

![world long lines w:450px](images/World3D_Long-137.png)

</div>
</div>

----

# Spherical coordinates

<div class='columns21'>
<div>

**Latitude and longitude**:

- 90° 0’ 0” E and 30° 0’ 0” N
- 90.00 E, 30.00 N

**3D coordinates**

- Can include height
- In Tibet: 5,500 m
- Height above **what?**

</div>
<div>

![world lat and long h:450px](images/World3D_LL-141.png)

</div>
</div>

<!--
- What is 5,500m a measurement from?
- What do we need to make our coordinate system.
-->

---

# Geographic coordinate system

- The Earth is not a sphere (~ 1 in 298 flattening)
- There are **many** reference ellipsoids or datums.

| Name | r<sub>equator</sub> (m)  | r<sub>poles</sub> (m)  |
|--- |---: |---: |
| Airy 1830 | 6,377,563.4 | 6,356,256.91 |
| Clarke 1866 | 6,378,206.4 | 6,356,583.8 |
| International 1924 | 6,378,388 | 6,356,911.9 |
| WGS 1984 | 6,378,137 | 6,356,752.31 |

----

# Geographic coordinate system

- Unfortunately, the Earth isn’t a ellipsoid either.
- Distribution of mass is uneven and dynamic

<div class='columns'>
<div>

![earth layers w:450](images/droppedImage-149.png)

</div>
<div>

![earth dynamics w:450](images/droppedImage-146.png)

</div>
</div>

----

# Geographic coordinate system

<div class='columns21'>
<div>

**Geoid**

- Surface of equal gravitational force
- Up and down are **perpendicular** to the local geoid
- A level surface is **tangent** to the local geoid

</div>
<div>

![Grace Gravity Model 3 w:400px](images/ggm01-200.gif)

</div>
</div>

<!--
- Down does not necessarily go through the centre of the earth
-->

----

# Geographic coordinate system

![geoid_surface_waterlevel_ellisoid w:900px](images/cross_section-156.png)

<!--
GPS uses height above ellipsoid
- can lead to problems relative to sea level.
- receivers contain a low resolution look up table for the separation.
-->

----

# WGS 84

<div class='columns21'>
<div>

- Combined datum and geoid giving a standard global coordinate system
- Uses modern satellite data to provide ellipsoid measurements and gravity model
- Used by GPS
- Prime meridian: 0°0’5.31”E !

</div>
<div>

![greenwich not zero w:300](images/d8910_1.jpg)

</div>
</div>

<!--
- International Reference Meridian
- Currently 100m East of Greenwich Meridian and moving!
- Local vs geocentric vertical
-->

---

# Local geographic datum

<div class='columns'>
<div>

- The fit between a geoid and a datum varies in space
- Global models, like WGS 84, work well on average
- Countries adopt local datum models that fit better locally

</div>
<div>

![w:500px](images/regional-163.png)

</div>
</div>

----

# Local geographic datum

<div class='columns21'>
<div>

- WGS84
  - -0.639875°W
  - 51.4090°N
- UK uses the **OSGB 36 datum**
  - -0.638331°W
  - 51.4085°N
- The shift varies nationally

</div>
<div>

![Silwood w:450px](images/Silwood_1_25000-166.png)

</div>
</div>

----

# Datum shift

![datum shifts w:700px](images/datum_shift.png)

---

# Spherical geometry

<div class='columns'>
<div>

- Great circles
- Spherical ‘triangle’
- **Spherical** geometry:
  - exact and fast
- **Ellipsoidal** geometry:
  - iterative and slow

</div>
<div>

![spherical geometry w:450px](images/SphericalGeometry.svg)

</div>
</div>

<!--
Great circle
- where a plane through the centre hits the surface
- shortest distance by haversine formula
Triangle
- angles sum to more than 180
-->

----

# Spherical geometry

<div class='columns'>
<div>

- Globes not convenient or easily scalable
- Precise calculations slow
- Not easily useable on flat screen or on paper
- Need a flat representation of space

</div>
<div >

![spherical geometry w:450px](images/SphericalGeometry.svg)

</div>
</div>

---

# Projected coordinate systems

<div class='columns'>
<div class='col2 rightpad'>

> It is impossible to project an spherical surface onto a plane without distortion
> (Gauss, 1827).

</div>
<div>

![chocolate orange w:450px](images/terrys_chocolate_orange.png)

</div>
</div>

<!--
- The ellipsoid surface of the Earth for small distances (~ 10 km) is flat enough for
  simple purposes but for anything else...
-->

----

# Projected coordinate systems

Map projections can preserve:

- **Shape**: conformal maps
- **Area**: equal-area maps
- **Distance**: equi-distant maps
- **Direction**: azimuthal maps

But most projected coordinate systems can only preserve **one** of these things.

----

# Projected coordinate systems

<div class='columns'>
<div>

**Tissot indicatrix**:

- An circle on the surface of the Earth.
- All points on the edge are equidistant from the center.
- Show distortion of ellipsoid surface on planar projections

</div>
<div>

![Orthographic w:450px](images/Orthographic.png)

</div>
</div>

----

# Projected coordinate systems

**Equirectangular**:  latitude and longitude as X and Y

![Equirectangular w:800](images/Equirectangular.png)

<!--
Doesn’t preserve anything much,
- distance/scale along vertical lines (great circles)
-->

----

# Projected coordinate systems

Classification according to mapping to planar surface:

![Planar Cylindrical Conical w:800](images/Projection_types-193.png)

----

# Projected coordinate systems

**Gnomonic**: planar, preserves bearings from a single central point, but little else.

<div class='columns12'>

<div>

![gnomonic w:400](images/gnomon.svg)

</div>
<div>

![gnomomic silwood centre w:400](images/SilwoodGnomonic-197.png)

</div>
</div>

<!--
Great circles in all directions from centre of map
-->

----

# Projected coordinate systems

**Cylindrical**: preserves area, not shape

<div class='columns12'>
<div>

![cylindrical ](images/cylindrical.svg)

</div>
<div>

![behrmann w:700px](images/Behrmann-205.png)

</div>
</div>

<!--
Imagine running an old fluorescent tube down the middle and turning it on.
Behrmann projection
- Notice compression of higher latitudes
-->

----

# Projected coordinate systems

**Mercator**: preserves shape, not scale

![mercator w:800px](images/Mercator-209.png)

<!--
Inflate spherical balloon inside a cylinder coated with glue
-->

----

# Projected coordinate systems

**Fuller Dymaxion**: compromise projection

![fuller dymaxion w:800px](images/Fuller-213.png)

<!--
- Local projections onto triangular planes Borders go through sea
- No up or down
-->

---

# Geographic data

- A **Coordinate system** and:
  - **Vector** data
    - coordinates of points, lines, polygons
  - **Raster** data
    - grid data
    - satellite and aerial images

----

# Raster data

An **image** covering a continuous surface

- Individual **pixels**, each with a **value**
  - Categorical: land cover, species presence
  - Continuous: temperature, precipitation
- Has a **resolution** (pixel size)
- Needs **origin** and coordinate system

----

# Raster data

<div class='columns'>
<div>

![uk gtopo w:450](images/UK_GTOPO-223.png)

</div>
<div>

![mammal threat w:450px](images/MammalThreat-226.png)
![silwood map w:450px](images/Silwood_1_25000-166.png)

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

<div class='columns'>
<div>

![ecoregions w:450px](images/UK_Ecoregions-233.png)

</div>
<div>

![species distribution w:450px](images/RedDeer-236.png)
![silwood vector w:450px](images/SilwoodPointLine-239.png)

</div>
</div>

----

# Data comparison

<div class='columns'>
<div>

**Raster**

- Fixed grid
- One value per pixel per bands
- Often multiple stacked bands
- Attribute tables for *values* (VAT)

</div>
<div>

**Vector**

- Features with arbitrary shapes
- Attribute tables for *features*

</div>
</div>
