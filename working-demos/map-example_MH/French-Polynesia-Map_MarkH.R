# Map of coral reef survey sites around two islands in French Polynesia

library(tidyverse)
library(googleway)
library(ggmap)
library(ggpubr)


#Read in co-ordinates (Moorea & Raiatea sites)
sites <- read.csv("working-demos/map-example_MH/Site_coordinates.csv")
head(sites)

# Plot with Google maps layer

#You need a Google API key (which is free). Instructions on how to get one
#here: 
#https://developers.google.com/maps/documentation/places/web-service/cloud-setup

register_google(key = "INSERT-KEY-HERE!")


# Make map for Moorea:

# Create object to store map info
moorea <- get_googlemap("Moorea, French Polynesia", 
                        zoom = 11, maptype = "satellite")

# Plot map
Moo <- ggmap(moorea, extent=) + 
  theme_void() +
  geom_point(data=sites, 
             aes(x=longitude, y=latitude, colour=island, fill=island), 
             size=2, colour="black", shape=21) +
  scale_fill_manual(values = c("springgreen3","darkorange1")) +
  theme(legend.position="none") 
  
Moo


# Map for Raiatea:

raiatea <- get_googlemap("Raiatea, French Polynesia", 
                         zoom = 11, maptype = "terrain")

Rai <- ggmap(raiatea) + 
  theme_void() + 
  geom_point(data=sites, 
             aes(x=longitude, y=latitude, colour=island, fill=island), 
             size=2, colour="black", shape=21) +
  scale_fill_manual(values = c("springgreen3","darkorange1")) +
  theme(legend.position="none")

Rai


# Arrange map panels side by side
ggarrange(Moo, Rai)

# I prefer the "terrain" option for maptype. Only included "satellite" to
# show it's possible. Maps for both islands should be the same style.

################################################################################


# That's what I have so far.

# I'd like to improve the appearance of the map and add some labels with extra
# info.

#Specifically:
# - Zoom in a little more. Increasing zoom to 12 is a bit too much for Raiatea 
# - Add a scale bar. Both maps will be the same, so only on one panel?
# - Add labels, e.g. years sites were surveyed. All even years (2010 - 2020)
#   except one site on Moorea which is odd years (SiteA: 2011 - 2019).
# - Other labels, e.g. "Population density = X"
# - Get rid of place names/elevation from "terrain" view



# Other map packages available:

#"gshhg"
#"sf"
# others...?


## james robinson trying an R Natural Earth version with sf
library(rnaturalearthhires) # devtools::install_github("ropensci/rnaturalearthhires")
library(rnaturalearth) #This is required too => devtools::install_github("ropensci/rnaturalearth")
library(sf)

# hi res countries polygons
world <- ne_countries(scale = "large", returnclass = "sf")

# plot polygons, add points on top
ggplot(data=world) +
    geom_sf() + 
    geom_point(data = sites, aes(x = longitude, y = latitude)) +
    ggrepel::geom_text_repel(data = sites, aes(x = longitude, y = latitude, label = years), size=2, seed=42) +
    annotate('text', x = -149.5, y = -17.1, label='Moorea') +
    annotate('text', x = -151, y = -16.5, label='Raiatea') +
    coord_sf(
        crs = 4326, # https://epsg.io/4326 (aka the classic)
        xlim = c(-152, -149), # limits are taken from eyeballing the sites df
        ylim = c(-18, -16)  # of EPSG:3460
    ) + ggthemes::theme_map()

##### END OF SCRIPT #####