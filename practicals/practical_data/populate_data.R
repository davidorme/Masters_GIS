# This script is used to populate the practical data folder with the larger downloaded
# datasets used in the various practicals

library(geodata)
library(rnaturalearth)

# Clear out practical 1 junk

files <- dir("uk", "uk_eire*|uk_raster_*", full.names = TRUE)
print(files)
file.remove(files)


# Download bioclim data: global maximum temperature at 10 arc minute resolution
tmax <- worldclim_global(var = "tmax", res = 10, path= ".")

# New guinea precip
ng_prec <- worldclim_tile(var='prec', res=0.5, lon=140, lat=-10, path='.')

# FIJI
fiji <- gadm(country='FJI', level=2, path='fiji')

# SDM data
bioclim_hist <- worldclim_global(var='bio', res=10, path='.')
bioclim_future <- cmip6_world(var='bioc', res=10, ssp="585", 
                              model='HadGEM3-GC31-LL', time="2041-2060", path='.')


# Countries at 2 resolutions
tmp <- ne_download(scale = 110, type = "countries",
                   destdir = "ne_110m_admin_0_countries")

tmp <- ne_download(scale = 10, type = "countries",
                   destdir = "ne_10m_admin_0_countries")
