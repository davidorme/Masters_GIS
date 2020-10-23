---
title: Remote Sensing
author: David Orme
---

# Overview

  1. Remote sensing concepts
  2. Resolution:
    - Spectral
    - Spatial
    - Temporal
  3. Earth observation products

---

# Mapping landscapes manually

<div class='leftpad'>

**Pros**

  - Very fine level of detail

**Cons**

  - Expensive
  - Slow
  - Inconsistency between locations and sampling periods

</div>

---

# Maps from images

<div class='container'>
<div class='col1'>

Aerial photography  
(1900s)
![](images/Illustrating-the-procedure-of-taking-photographs.jpg)

</div>
<div class='col1'>

Satellite imagery  
(1950s)
![](images/First_photo_from_space.jpg)

</div>
</div>

Notes: 
Elifrits et al. 1978 Mapping land cover from satellite images: A basic, low cost approach. EARTH RESOURCES AND REMOTE SENSING. Image taken from a V2 rocket in 1946

---

# Remote sensing

<div class='leftpad'>

Remote sensors can be:

**Passive**: sense reflected solar radiation

**Active**:  emit and sense reflected

  - LIDAR (light)
  - RADAR (microwaves)
  - Alteration in reflected light 
  - Trip time gives heights

</div>

---

# Reflectance

**Albedo**: the proportion of radiation reflected from a surface, **strongly** affected by texture and angle of incidence.

<div class='container'>
<div class='col1'>

![Snow](images/snow.jpg)

</div>
<div class='col1'>

![Vantablack](images/Vantablack_01.JPG)

</div>
</div>

----

# Electromagnetic spectrum

![](images/electromagnetic-spectrum.png)

----

# Reflectance

<div class='container'>
<div class='col1'>

**Monochrome images**

  - Different objects have different albedo
  - Construct maps by looking at contrast, texture and edges

</div>
<div class='col1'>

![](images/svetistefan_bw.jpg)

</div>
</div>

----

# Reflectance

<div class='container'>
<div class='col1'>

**Multispectral images**  

  - Albedo of surfaces vary with wavelength 
  - Compare **bands** recording reflectance in different wavelengths

</div>
<div class='col1'>

![](images/svetistefan.jpg)

</div>
</div>

----

## Reflectance

![](images/svetistefan.jpg)<!-- .element width="50%" --> 

<div class='container'>
<div class='col1'>

![Red](images/SvetiStefan_red.jpg)

</div>
<div class='col1'>

![Green](images/SvetiStefan_green.jpg)

</div>
<div class='col1'>

![Blue](images/SvetiStefan_blue.jpg)

</div>
</div>

---

# Satellite orbits

<div class='container'>
<div class='col1'>

  - **High earth** geostationary orbits (weather satellites), 
  - **Mid earth orbits** (navigation and communications)
  - **Low earth orbits**   
  (earth observation)
  -  **Sun synchronous** orbit (same time of day)

</div>
<div class='col1'>

![rrsgdf](images/sun-synchronous.gif)

</div>
</div>

Notes: 
HEO: stationary, MEO: 2-24 hour orbits, LEO: 90 - 120 minutes

---

# Spatiotemporal resolution

<div class='container'>
<div class='col1 rightpad'>

**Low earth orbits**:

 - Close to the planet
 - High spatial resolution
 - Narrow path widths
 - Small scenes
 - Less frequent images
 - Use **constellations** of satellites

</div>
<div class='col1'>

![](images/spatiotemporal.jpg)

</div>
</div>

----

# Spatiotemporal resolution

<div class='container'>
<div class='col1 rightpad'>

**High earth orbits**:

 - Far out in space
 - Low spatial resolution
 - No path width
 - Global scenes
 - Can take images constantly

</div>
<div class='col1'>

![](images/spatiotemporal.jpg)

</div>

----

## Spatiotemporal resolution

To put it another way:

<div class='container'>
<div class='col1'>

**Meteosat**
![HEO: Meteosat](images/meteosat-msg_ir039.jpg)

</div>
<div class='col1'>

**Pleiades**
![LEO: Pleiades](images/SAFE_from_space_Pleiades.png)<!-- .element width="80%" --> 

</div>
</div>

---

# Spectral resolution

  - Determined by the satellite mission
  - Constrained by absorption of radiation by the atmosphere
  - Light gathering sets resolution and band width

![](images/landsat_aster_bands.jpg)

Notes:
Pink areas on image show atmospheric absorption / transmission

---

# Example platforms


| Satellite 	| N 	| Bands	| Revisit	| Resolution (m)	|
|---|---:|---:|---:|---|
| Pleiades 	| 2 	| 5	| 1	| 2 / 0.5	|
| Rapid  Eye	| 5 	| 5	| 1	| 5	|
| Spot  7	| 1 	| 5	| 2-3	| 6 / 1.5	|
| ASTER 	| 1 	| 14	| 16 	| 90 / 30 / 15	|
| Landsat  8	| 1 	| 11	| 16 	| 100 / 30 / 15	|
| MODIS Terra	| 1 	| 36	| 1 - 2 | 1000 / 500 / 250	|

---

# Using satellite images

![](images/1278119-Ben-Goldacre-Quote-I-think-you-ll-find-it-s-a-bit-more-complicated.jpg)

----

# Using satellite images

<div class='leftpad'>

Multiple steps may be needed to use data:

  - **Georeferencing**: where is the image?
  - **Orthorectification**: remove perspective and terrain effects
  - **Calibration**: convert the sensor value (an integer ) to an actual reflectance value
  - **Atmospheric correction**: aerosols and water vapour can all impose spectral biases on reflected light and vary on a daily basis.

</div>

----

# Using satellite images

![](images/LE07_L1TP_117057_20160721_20161010_01_T1_REFL.jpg)<!-- .element width="65%" --> 

Notes:
Failure of the scan line corrector in 2003

----

# Earth observation products

<div class='leftpad'>
	
Use satellite reflectance data to produce derived maps

  - Use standardised algorithms
  - Map land surface traits at global scale 
  - Temporal scales: daily to annual 
  - Resolution: 250 m to > 8 km spatial resolution
  - Validation: many have pixel by pixel 'accuracy'

Four examples of increasing complexity

</div>

----

# Vegetation indices

<div class='leftpad'>

Simple direct calculation from sensor values:

  - Normalized Difference Vegetation Index:

$${\mbox{NDVI}}={\frac  {({\mbox{NIR}}-{\mbox{RED}})}{({\mbox{NIR}}+{\mbox{RED}})}}$$

  - Enhanced Vegetation Index:

$${\displaystyle EVI=G\cdot {\frac {(\mbox{NIR}-\mbox{RED})}{(\mbox{NIR}+C_1\cdot \mbox{RED}-C_2\cdot \mbox{Blue}+L)}}}$$

<!--- Soil and Atmospherically Resistant Vegetation Index:  
$${\displaystyle {\mbox{SAVI}}={\frac {({\mbox{1}}+{\mbox{L}})({\mbox{NIR}}-{\mbox{Red}})}{({\mbox{NIR}}+{\mbox{Red}}+{\mbox{L}})}}}$$ -->

</div>

----

# Digital elevation models

<div class='container'>
<div class='col1'>

  - Shuttle Radar Topography Mission (SRTM)
  - ASTER Terra DEM (stereoscopy)
  - Both near global with 30 metre resolution

</div>
<div class='col1'>

![](images/aster_v_srtm.png)<!-- .element width="85%" --> 

</div>
</div>

---

# Fire signatures

<div class='leftpad'>

Live fires:

   - Spectral signature in **Infrared bands**
   - [http://fires.globalforestwatch.org/map](http://fires.globalforestwatch.org/map)
   - MODIS daily and 8 day fire observations at 1km resolution 
   - SPOT: annual fire frequencies (2000 - 2007)

Burned area:

  - Change detection in successive images around fire pixels
  - MODIS: monthly burned area in 500m pixels

</div>

---

# Land cover

Spectral signatures differ **between different surfaces**:

![](images/Reflectance_by_wavelength.png)<!-- .element width="85%" --> 

----

# Land cover

Spectral signatures differ **over time**:

![](images/Reflectance_seasonality.png)<!-- .element width="75%" --> 

----

# Land cover

 **Ground sampling** ties spectral signatures to habitats

![](images/tres_a_674230_o_f0013g.jpeg)<!-- .element width="85%" --> 

----

# Land cover

Profiles can then be used to **classify** pixels to habitats

![](images/121557main_landCover.jpg)<!-- .element width="70%" --> 

----

# Land cover

<div class='leftpad'>

Examples:

  - MODIS: Annual summaries at 500 metre resolution using five different classification schemes
  - [http://landcover.org/data/](http://landcover.org/data/)
  - [Global Forest Change](https://earthenginepartners.appspot.com/science-2013-global-forest)

</div>

---

# Productivity

<div class='leftpad'>

Plants use light to store carbon.  If we know:

  - The amount of **photosynthetically active light** absorbed
  - The **radiation conversion efficiency**, given
     - the temperature and
     - humidity.
  - Respiration costs.
  
Then we can predict gross and net primary productivity.

</div>

---

# Productivity

<div class='container'>
<div class='col1 rightpad'>

  - Remotely sensed reflected light
  - Ground measured incident light
  - Biome based models for:
     - conversion efficiency
     - respiration

</div>
<div class='col1'>

![](images/MODIS_Productivity.png)

</div>
</div>

---

# Obtaining data

  - [http://reverb.echo.nasa.gov/](http://reverb.echo.nasa.gov/)
  - [http://earthexplorer.usgs.gov/](http://earthexplorer.usgs.gov/)
  - [http://srtm.csi.cgiar.org/](http://srtm.csi.cgiar.org/)
  - [https://earth.esa.int/web/guest/eoli](https://earth.esa.int/web/guest/eoli)

