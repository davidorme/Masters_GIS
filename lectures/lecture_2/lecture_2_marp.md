---
marp: true
title: Remote Sensing
author: David Orme
theme: gaia-local
---

<!-- markdownlint-disable MD024 MD025 MD033 MD035 MD036-->

# Remote Sensing

## David Orme

![bg width:400px](../shared_images/World3D_600.png)

---

# Overview

- Remote sensing concepts
- Resolution
  - Spectral
  - Spatial
  - Temporal
- Earth observation products

---

# Mapping landscapes manually

**Pros**

- Very fine level of detail

**Cons**

- Expensive
- Slow
- Inconsistency between locations and sampling periods

---

# Maps from images

<div class='columns'>
<div>

Aerial photography  
(1900s)
![aerial photos w:450px](images/Illustrating-the-procedure-of-taking-photographs.jpg)

</div>
<div>

Satellite imagery  
(1950s)
![v2 image w:450px](images/First_photo_from_space.jpg)

</div>
</div>

<!--
Elifrits et al. 1978 Mapping land cover from satellite images: A basic, low cost
approach. EARTH RESOURCES AND REMOTE SENSING. Image taken from a V2 rocket in 1946
-->

---

# Remote sensing

Remote sensors can be:

**Passive**: sense reflected solar radiation

**Active**:  emit radiation and sense reflection

- LIDAR (light)
- RADAR (microwaves)
- Alteration in reflected light
- Trip time gives heights

---

# Reflectance

**Albedo**: the proportion of radiation reflected from a surface, **strongly** affected by texture and angle of incidence.

<div class='columns'>
<div>

![Snow w:450px](images/snow.jpg)

</div>
<div>

![Vantablack w:450px](images/Vantablack_01.JPG)

</div>
</div>

----

# Electromagnetic spectrum

![em spectrum w:850px](images/electromagnetic-spectrum.png)

----

# Reflectance

<div class='columns'>
<div>

**Monochrome images**

- Different objects have different albedo
- Construct maps by looking at contrast, texture and edges

</div>
<div>

![svetistefan_bw w:550px](images/svetistefan_bw.jpg)

</div>
</div>

<!--
Sveti Stefan, Montenegro: five star island hotel resort
-->

----

# Reflectance

<div class='columns'>
<div>

**Multispectral images**  

- Albedo of surfaces vary with wavelength
- Compare **bands** recording reflectance in different wavelengths

</div>
<div>

![svetistefan_rgb w:550px](images/svetistefan.jpg)

</div>
</div>

----

# Reflectance

![svetistefan_rgb w:450px](images/svetistefan.jpg)

<div class='columns3'>
<div>

![Red w:330px](images/SvetiStefan_red.jpg)

</div>
<div>

![Green w:330px](images/SvetiStefan_green.jpg)

</div>
<div>

![Blue w:330px](images/SvetiStefan_blue.jpg)

</div>
</div>

---

# Satellite orbits

<div class='columns21'>
<div class>

- **High earth** geostationary orbits (weather satellites),
- **Mid earth orbits** (navigation and communications)
- **Low earth orbits** (earth observation)
- **Sun synchronous** orbit (same time of day)

</div>
<div>

![rrsgdf](images/sun-synchronous.gif)

</div>
</div>

<!--
HEO: stationary, MEO: 2-24 hour orbits, LEO: 90 - 120 minutes
-->

----

# Spatiotemporal resolution

<div class='columns21'>
<div>

**Low earth orbits**:

- Close to the planet
- High spatial resolution
- Narrow path widths
- Small scenes
- Less frequent images
- Use **constellations** of satellites

</div>
<div>

![RS res v time](images/spatiotemporal.jpg)

</div>
</div>

----

# Spatiotemporal resolution

<div class='columns21'>
<div>

**High earth orbits**:

- Far out in space
- Low spatial resolution
- No path width
- Global scenes
- Can take images constantly

</div>
<div>

![RS res v time](images/spatiotemporal.jpg)

</div>

----

# Spatiotemporal resolution

<div class='columns'>
<div>

**Meteosat**
![HEO: Meteosat w:450px](images/meteosat-msg_ir039.jpg)

</div>
<div>

**Pleiades**
![LEO: Pleiades w:420px](images/SAFE_from_space_Pleiades.png)

</div>
</div>

----

# Spectral resolution

- Determined by the satellite mission
- Atmospheric absorption of radiation
- Light-gathering sets resolution and band width

![landsat aster bands w:800](images/landsat_aster_bands.jpg)

<!--
Pink areas on image show atmospheric absorption / transmission
-->

----

# Example platforms

| Satellite  | N  | Bands | Revisit | Resolution (m) |
|---|---:|---:|---:|---|
| Pleiades  | 2  | 5 | 1 | 2 / 0.5 |
| Rapid  Eye | 5  | 5 | 1 | 5 |
| Spot  7 | 1  | 5 | 2-3 | 6 / 1.5 |
| ASTER  | 1  | 14 | 16  | 90 / 30 / 15 |
| Landsat  8 | 1  | 11 | 16  | 100 / 30 / 15 |
| MODIS Terra | 1  | 36 | 1 - 2 | 1000 / 500 / 250 |

---

# Using satellite images

![goldacre w:900px](images/1278119-Ben-Goldacre-Quote-I-think-you-ll-find-it-s-a-bit-more-complicated.jpg)

----

# Using satellite images

Multiple steps may be needed to use data:

- **Georeferencing**: where is the image?
- **Orthorectification**: remove perspective and terrain effects
- **Calibration**: convert the sensor value (an integer ) to an actual reflectance value
- **Atmospheric correction**: aerosols and water vapour can all impose spectral biases
  on reflected light and vary on a daily basis.

----

# Using satellite images

![landsat failure w:600px](images/LE07_L1TP_117057_20160721_20161010_01_T1_REFL.jpg)

<!--
Failure of the scan line corrector in 2003
-->

---

# Earth observation products

Use satellite reflectance data to produce derived maps

- Use standardised algorithms
- Map land surface traits at global scale
- Temporal scales: daily to annual
- Resolution: 250 m to > 8 km spatial resolution
- Validation: many have pixel by pixel 'accuracy'

Four examples of increasing complexity

---

# Vegetation indices

Simple direct calculation from sensor values:

- Normalized Difference Vegetation Index:

$${\mbox{NDVI}}={\frac  {({\mbox{NIR}}-{\mbox{RED}})}{({\mbox{NIR}}+{\mbox{RED}})}}$$

- Enhanced Vegetation Index:

$${\displaystyle EVI=G\cdot {\frac {(\mbox{NIR}-\mbox{RED})}
   {(\mbox{NIR}+C_1\cdot \mbox{RED}-C_2\cdot \mbox{Blue}+L)}}}$$

<!--- Soil and Atmospherically Resistant Vegetation Index:  
$${\displaystyle {\mbox{SAVI}}={\frac {({\mbox{1}}+{\mbox{L}})
   ({\mbox{NIR}}-{\mbox{Red}})}{({\mbox{NIR}}+{\mbox{Red}}+{\mbox{L}})}}}$$ -->

---

# Digital elevation models

<div class='columns'>
<div>

- Shuttle Radar Topography Mission (SRTM)
- ASTER Terra DEM (stereoscopy)
- Both near global with 30 metre resolution

</div>
<div>

![aster v srtm w:390px](images/aster_v_srtm.png)

</div>
</div>

---

# Fire signatures

Live fires:

- Spectral signature in **Infrared bands**
- [http://fires.globalforestwatch.org/map](http://fires.globalforestwatch.org/map)
- MODIS daily and 8 day fire observations at 1km resolution
- SPOT: annual fire frequencies (2000 - 2007)

Burned area:

- Change detection in successive images around fire pixels
- MODIS: monthly burned area in 500m pixels

---

# Land cover

Spectral signatures differ **between different surfaces**:

![surface reflectances w:750px](images/Reflectance_by_wavelength.png)

----

# Land cover

Spectral signatures differ **over time**:

![phenology w:650px](images/Reflectance_seasonality.png)

----

# Land cover

 **Ground sampling** ties spectral signatures to habitats

![habitat map w:700px](images/tres_a_674230_o_f0013g.jpeg)

----

# Land cover

Profiles can then be used to **classify** pixels to habitats

![classified map w:600px](images/121557main_landCover.jpg)

----

# Land cover

Examples:

- MODIS: Annual summaries at 500 metre resolution using five different classification
  schemes
- [http://landcover.org/data/](http://landcover.org/data/)
- [Global Forest
  Change](https://earthenginepartners.appspot.com/science-2013-global-forest)

---

# Productivity

Plants use light to store carbon.  If we know:

- The amount of **photosynthetically active light** absorbed
- The **radiation conversion efficiency**, given
  - the temperature and
  - humidity.
- Respiration costs.
  
Then we can predict gross and net primary productivity.

----

# Productivity

<div class='columns12'>
<div>

- Remotely sensed reflected light
- Ground measured incident light
- Biome models for **conversion efficiency** and **respiration**

</div>
<div>

![productivity w:650](images/MODIS_Productivity.png)

</div>
</div>

---

# Obtaining data

- [http://reverb.echo.nasa.gov/](http://reverb.echo.nasa.gov/)
- [http://earthexplorer.usgs.gov/](http://earthexplorer.usgs.gov/)
- [http://srtm.csi.cgiar.org/](http://srtm.csi.cgiar.org/)
- [https://earth.esa.int/web/guest/eoli](https://earth.esa.int/web/guest/eoli)
