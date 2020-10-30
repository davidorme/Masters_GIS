
## ALIEN INVASION DATA creation

# Generate data file using proper random point picking on sphere surface
alien_xy <- st_sample(st_as_sfc(st_bbox(extent(-180,180,-90,90), crs=4326)), 10000)
alien_on_land <- st_intersects(ne_110, alien_xy)
alien_xy <- alien_xy[unlist(alien_on_land)]
alien_xy <- st_sf(alien_xy)
alien_xy$n_aliens <- sample(c(1,10,100,1000), nrow(alien_xy), replace=TRUE)
alien_coords <-  st_coordinates(alien_xy)
colnames(alien_coords) <- c('long','lat')
alien_xy <- cbind(alien_xy, alien_coords)
st_geometry(alien_xy) <- NULL
write.csv(alien_xy, file='aliens.csv', row.names=FALSE)

# Checking
plot(st_geometry(ne_110), col='khaki')
plot(st_geometry(alien_xy), add=TRUE, cex=log(alien_xy$n_aliens + 1)/4)
