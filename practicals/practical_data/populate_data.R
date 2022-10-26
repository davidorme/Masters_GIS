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


tmp <- ne_download(scale = 110, type = "countries",
                   destdir = "ne_110m_admin_0_countries")

tmp <- ne_download(scale = 10, type = "countries",
                   destdir = "ne_10m_admin_0_countries")