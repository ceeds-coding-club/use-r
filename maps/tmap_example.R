library(tmap) ## plot maps
library(rgdal) ## read raster

# https://geocompr.robinlovelace.net/adv-map.html#static-maps

## read raster layers (bathymetry)
bathy200 <- readOGR("data/shp/bathy/seychelles_bathymetry_grid_shp_10m_interval.shp")
islands <- bathy200[bathy200$BATHY == 0, ]

## read boat tracks
poly.master <- load(file = 'data/shp/vms_polygons.rds')

# projection
proj.val = 'WGS84'

## set map limits according to observed boat tracks
ex <- extent(poly.master)
biglim.x <- c(ex@xmin, ex@xmax)
biglim.y <- c(ex@ymin, ex@ymax)

## colour legend
fill.seq = seq(0, 4, 1)

### Create a tmap
map12 <- tm_shape(
  data = poly.master %>% filter(year == 2012),
  xlim = biglim.x,
  ylim = biglim.y,
  bg.color = 'white',
  projection = proj.val
) +
  tm_fill(
    'n.boats.prop',
    palette = 'YlGn',
    breaks = fill.seq,
    legend.show = F,
    colorNA = 'white',
    title = 'Fishing effort (%)'
  ) +
  tm_layout(title = '2012') +
  ## add raster layers (bathymetry)
  tm_shape(islands) +
  tm_fill(col = 'red') +
  tm_borders(col = 'red', lwd = 0.01) +
  tm_shape(bathy200) +
  tm_lines(col = 'black', lwd = 0.5)