################################################################################
####                                                                        ####
####                           Mapping Demo                                 ####
####                          E Maire - LEC                                 ####
####                            16/02/2022                                  ####
####                                                                        ####
################################################################################


# Example 1 - Using base R

#Load libraries
library(plot3D)
library(maps)

#Import data - Fatty acid concentrations for reef sites globally. Sites (UniqueSite) are grouped into clusters (ReefCluster)
load("site_omegaLL.RData")
dat <- site_omegaLL

head(dat)

#basic plot: scatter2D( x = LONGITUDE , y = LATITUDE, + aesthetics ) of 
scatter2D(site_omegaLL$ReefCluster_Long, site_omegaLL$ReefCluster_Lat)

#add background layer
maps::map(database="world",add=TRUE) # VERY UGLY

#Increase margins

scatter2D(site_omegaLL$ReefCluster_Long, site_omegaLL$ReefCluster_Lat)
maps::map(database="world",border=NA,fill=TRUE,col="grey80",add=TRUE) #=> not ideal, points are masked

#Customized plot in 3 steps
scatter2D(site_omegaLL$ReefCluster_Long, site_omegaLL$ReefCluster_Lat,
          cex=0,colvar = site_omegaLL$log_omega,xlab="Lon", ylab="Lat") #Set up the extent with no point (cex =0)
maps::map(database="world",border=NA,fill=TRUE,col="grey80",add=TRUE) #add background
scatter2D(site_omegaLL$ReefCluster_Long, site_omegaLL$ReefCluster_Lat,
          cex=1,pch=19,
          colvar = site_omegaLL$log_omega,add=TRUE) #add points
title("Observed Mean")

#Another plot
scatter2D(dat$ReefCluster_Long, dat$ReefCluster_Lat,
          cex=0,colvar = dat$Model_Estimate,xlab="Lon",ylab="Lat")
maps::map(database="world",border=NA,fill=TRUE,col="grey80",add=TRUE)
scatter2D(dat$ReefCluster_Long, dat$ReefCluster_Lat,
          cex=1,pch=19,
          colvar = dat$Model_Estimate,add=TRUE,colkey = NULL)
title("Model Estimates")

#Display both maps

#Re initialize graphical parameters
graphics.off()
par(mfrow=c(2,1))

scatter2D(site_omegaLL$ReefCluster_Long, site_omegaLL$ReefCluster_Lat,
          cex=0,colvar = site_omegaLL$log_omega,xlab="Lon", ylab="Lat") #Set up the extent with no point (cex =0)
maps::map(database="world",border=NA,fill=TRUE,col="grey80",add=TRUE) #add background
scatter2D(site_omegaLL$ReefCluster_Long, site_omegaLL$ReefCluster_Lat,
          cex=1,pch=19,
          colvar = site_omegaLL$log_omega,add=TRUE) #add points
title("Observed Mean")

#Another plot
scatter2D(dat$ReefCluster_Long, dat$ReefCluster_Lat,
          cex=0,colvar = dat$Model_Estimate,xlab="Lon",ylab="Lat")
maps::map(database="world",border=NA,fill=TRUE,col="grey80",add=TRUE)
scatter2D(dat$ReefCluster_Long, dat$ReefCluster_Lat,
          cex=1,pch=19,
          colvar = dat$Model_Estimate,add=TRUE,colkey = NULL)
title("Model Estimates")

#################################################################################
#################################################################################
#################################################################################
rm(list=ls())
graphics.off()

#Example 2 - ggplot2

#libraries
library(ggplot2)
library(RColorBrewer)

#load data
load("site_omegaLL.RData")
dat <- site_omegaLL

#Call World Map included in ggplot2
map <- map_data("world")

#Default map
defmap <- ggplot() + 
  #Set up background with map
  geom_polygon(data = map, aes(x=long, y = lat, group = group),fill = "grey", color = "grey") +
  coord_fixed(ylim = c(-30, 30), ratio = 1.3)+
  geom_point(data = dat,aes(x=Site_Long, y=Site_Lat, fill = log_omega), colour="black", size=4, pch=21)+
  scale_fill_continuous(name = "log omega-3 concentration") +
  theme_minimal()

defmap

#Customize map

#Load personal theme for mapping
thememap <- theme(axis.text=element_text(colour="black"),
                  axis.ticks=element_line(colour="black"),
                  panel.grid.minor=element_blank(),
                  panel.background=element_rect(fill="white",colour="black"),
                  plot.background=element_rect(fill="transparent",colour=NA),
                  plot.margin = margin(1,1,1,1, "cm"))

#Change color scale
myPalette <- colorRampPalette(brewer.pal(4, "Spectral"))

map2 <- ggplot() + 
  geom_polygon(data = map, aes(x=long, y = lat, group = group),fill = "grey", color = "grey") +
  coord_fixed(ylim = c(-30, 30), ratio = 1.3)+
  geom_point(data = dat,aes(x=Site_Long, y=Site_Lat, colour = log_omega), pch=16, size=2)+
  scale_colour_gradientn(name = "log omega-3\nconcentration", colours = myPalette(100),limits=c(min(dat$log_omega),max(dat$log_omega))) +
  scale_x_continuous("longitude")+
  scale_y_continuous("latitude")+ 
  thememap

map2

#Create a global map centered on the Pacific
dat$Site_Long2 <- ifelse(dat$Site_Long < -25, dat$Site_Long + 360, dat$Site_Long) # where d is your df
mapWorld <- map_data('world', wrap=c(-25,335), ylim=c(-55,75))

map_PC <- ggplot() + 
  geom_polygon(data = mapWorld, aes(x=long, y = lat, group = group),fill = "grey", color = "grey") +
  #Update the extend here
  coord_fixed(xlim = c(30, 320),  ylim = c(-30, 30), ratio = 1.3)+
  geom_point(data = dat, aes(x=Site_Long2, y=Site_Lat, colour = log_omega), pch=16, size=3)+
  scale_colour_gradientn(name = "log omega-3\nconcentration", colours = myPalette(100),limits=c(min(dat$log_omega),max(dat$log_omega))) +
  scale_x_continuous("longitude",breaks=c(80,180,280))+
  scale_y_continuous("latitude",breaks=c(-20,-10,0,10,20))+
  #Increase legend size
  thememap + theme(legend.key.height = unit(.8,"cm"),
                   legend.text=element_text(size=12),legend.title = element_text(size=14 ,face="bold"))

map_PC

#################################################################################
#################################################################################
#################################################################################
rm(list=ls())
graphics.off()

#Example 3 - Using ggmap using a Google API Key 
# Before you start, you need to obtain an API key from Google. 
# Go to the registration page (https://developers.google.com/maps/documentation/geocoding/get-api-key) and follow the instructions. 
#I recommend to select all mapping options.

#Be aware that the geocoding API is a free service however, you need to associate a credit card with your account.

library(ggmap)
library(ggplot2)

register_google("") #<- paste your googleAPIkey

load("eparses.RData")
eparses$Latitude <- eparses$Latitude*(-1)

#head(eparses)

#Create a Google map that covers the area of interest centered on the mean coordinates
myMap <- get_map(location = c(colMeans(eparses[,c("Longitude","Latitude")])),
                 source = "google", 
                 maptype = "satellite", 
                 zoom = 12, api_key = googleAPIkey)

#Plot and customise map using ggplot
map <- ggmap(myMap,darken=c(0.2,"white")) + 
  #Plot surveys coordinates
  geom_point(data=eparses, aes(x=Longitude, y=Latitude), shape = 21, color = "white", fill="red", size=3) 

map

#END OF DEMO - THANKS!
