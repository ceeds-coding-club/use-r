################################################################################
####                                                                        ####
####                        Mapping Demo in R                               ####
####                          E Maire - LEC                                 ####
####                            17/03/2021                                  ####
####                                                                        ####
################################################################################

# Example 1 - in base R 

# Load libraries
library(plot3D)
library(maps)

#Load dataset
cities <- read.csv("demos/mapping/cities_UK.csv")
head(cities)

#Create a new variable that will be used later:
cities$logPop <- log(cities$POP)

#Check the range of lat and long values to define the extent of the map
summary(cities[,c("Longitude","Latitude")]) 
lon <- c(-6, 0)
lat <-  c(50, 57)

#Draw a map using scatter2D and map:  
# Remember that in base R: the first plot is displayed and then, other elements can be added with add=TRUE.   
# If add=FALSE, another plot is created and displayed

#Initial plot: point are not drawn (cex = 0) but this sets up the spatial extent
scatter2D(lon, lat,xlab="Lon", ylab="Lat", cex=0) # Points are not drawn (cex = 0) but sets up the spatial extent

#Then, add base map:
scatter2D(lon, lat,xlab="Lon", ylab="Lat", cex=0) # Points are not drawn (cex = 0) but sets up the spatial extent
maps::map(database="world",border=NA,fill=TRUE,col="grey80",add=TRUE) 

#Display cities:
scatter2D(lon, lat,xlab="Lon", ylab="Lat", cex=0) # Points are not drawn (cex = 0) but sets up the spatial extent
maps::map(database="world",border=NA,fill=TRUE,col="grey80",add=TRUE) # add base map
scatter2D(cities$Longitude, cities$Latitude,
          cex=1, pch=19, col = "black", add=TRUE) # cex = 1 and points are drawn this time

#Add names and title:
scatter2D(lon, lat,xlab="Lon", ylab="Lat", cex=0) # Points are not drawn (cex = 0) but sets up the spatial extent
maps::map(database="world",border=NA,fill=TRUE,col="grey80",add=TRUE) # add base map
scatter2D(cities$Longitude, cities$Latitude,
          cex=1, pch=19, col = "black", add=TRUE) #Points are drawn this time
text2D(cities$Longitude, cities$Latitude-0.1,labels=cities$CITY_NAME, add=T) #Allows to add text based on coordinates
title("Major Cities in the UK")

#Display cities based on LOG population counts:
par(oma=c(1,1,1,1)) #increase margins to draw a legend next to the map

scatter2D(lon, lat,xlab="Lon", ylab="Lat", cex=0) # Points are not drawn (cex = 0) but sets up the spatial extent
maps::map(database="world",border=NA,fill=TRUE,col="grey80",add=TRUE) # add base map
scatter2D(cities$Longitude, cities$Latitude,
          cex=2,pch=19,
          colvar = cities$logPop,add=TRUE,
          colkey = list(side = 4, 
                        dist = 0.07)) # colkey is a list of parameters for the legend
text2D(cities$Longitude, cities$Latitude-0.1,labels=cities$CITY_NAME, add=T)
title("Major Cities in the UK (LOG Population)")

graphics.off()
rm(list=ls())

###########################################################
# Example 2 - with ggplot2

# We are going to draw the same map using ggplot2 (and other libraries) this time.  
#Load library
library(ggplot2) # ggplot2 offers global base map which can be customized

#Basic World Map:
world_map <- map_data("world") #ggplot2
ggplot(world_map, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill="lightgray", colour = "white")

#Major Cities in the UK:
cities <- read.csv("demos/mapping/cities_UK.csv")
cities$logPop <- log(cities$POP)
summary(cities[,c("Longitude","Latitude")]) #Check the range of lat and long values to define the extent of the map

uk <- ggplot() + 
  geom_polygon(data = world_map, aes(x=long, y = lat, group = group),fill = "grey", color = "grey") +
  coord_fixed(xlim = c(-6, 0),  ylim = c(50, 57), ratio = 1.3)+ # x = long / y = lat
  geom_point(data = cities,aes(x=Longitude, y=Latitude, fill = logPop), colour="black", size=5, pch=21)+
  scale_fill_continuous(name = "LOG Population") +
  scale_x_continuous("longitude")+
  scale_y_continuous("latitude")+  
  theme_classic() + theme(panel.border = element_rect(colour = "black", fill=NA, size=1.5))

uk

#Add city names with 'ggrepel' package to avoid overlapping labels:
library(ggrepel) 

uk_name <- ggplot() + 
  geom_polygon(data = world_map, aes(x=long, y = lat, group = group),fill = "grey", color = "grey") +
  coord_fixed(xlim = c(-6, 0),  ylim = c(50, 57), ratio = 1.3)+ # x = long / y = lat
  geom_point(data = cities,aes(x=Longitude, y=Latitude, fill = logPop), colour="black", size=5, pch=21)+
  geom_text_repel(data = cities , aes(x=Longitude, y=Latitude,label=CITY_NAME), direction = "both",size=3,force = 5)+ 
  scale_fill_continuous(name = "LOG Population") +
  scale_x_continuous("longitude")+
  scale_y_continuous("latitude")+  
  theme_classic() + theme(panel.border = element_rect(colour = "black", fill=NA, size=1.5))

uk_name

#Change color scale with RColorBrewer:
library(RColorBrewer)
myPalette <- colorRampPalette(rev(brewer.pal(4, "Spectral"))) # Use 'rev' to reverse the original color palette (red > yellow > blue)

uk_color <- ggplot() + 
  geom_polygon(data = world_map, aes(x=long, y = lat, group = group),fill = "grey", color = "grey") +
  coord_fixed(xlim = c(-6, 0),  ylim = c(50, 57), ratio = 1.3)+ # x = long / y = lat
  geom_point(data = cities,aes(x=Longitude, y=Latitude, fill = logPop), colour="black", size=5, pch=21)+
  geom_text_repel(data = cities , aes(x=Longitude, y=Latitude,label=CITY_NAME), direction = "both",size=3,force = 5)+ 
  scale_fill_gradientn(name = "LOG Population", colours = myPalette(100),limits=c(min(cities$logPop),max(cities$logPop))) +
  scale_x_continuous("longitude")+
  scale_y_continuous("latitude")+  
  theme_classic() + theme(panel.border = element_rect(colour = "black", fill=NA, size=1.5))

uk_color

# Geocoding with ggmap and Google API in R => check https://evamaire.com/2020/04/16/geocoding-with-ggmap-in-r/
  
#Thanks!