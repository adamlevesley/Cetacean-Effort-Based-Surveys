library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(rnaturalearthhires)
library(viridis)
library(rgbif)
library(mapview)

##------------------------------


Effort <- read_csv("AdamLevesley_EffortSightings.csv")




head(Effort)
coordinates(Effort)<-~LonS+LatS
head(Effort)
plot(Effort)
proj4string(Effort)<- "+proj=utm +zone=30 ellps=WGS84"
Effort <- spTransform(Effort, CRS("+proj=longlat +datum=WGS84"))
Effort <- data.frame(Effort)
head(Effort)
# -----Cooridnates have been converted now just to plot data

unique(Effort$Species)
Species <-  split(Effort, Effort$Species)
Species
list(Species)
glimpse(Species)
Bottlenose_Dolphin <- Species$`Bottlenose Dolphin`
glimpse(Bottlenose_Dolphin)
summary(Bottlenose_Dolphin)


blues <- c("lightsteelblue4", "lightsteelblue3", "lightsteelblue2", "lightsteelblue1")
greys <- c(grey(0.6), grey(0.93), grey(0.99)) 


#--------------------------Data Plotting---------------------------------

Bottlenose_map <- getNOAA.bathy(lon1 = -68.318, lon2 = 14.548,
                          lat1 = 34.91, lat2 = 62.17, resolution = 1, keep = TRUE)

summary.bathy(Bottlenose_map)
map <- plot.bathy(Bottlenose_map, image = TRUE, land = TRUE, lwd = 0.1, asp = NA,
           bpal = list(c(0,max(Bottlenose_map), greys), c(min(Bottlenose_map), 0, blues)))+
  scaleBathy(Bottlenose_map, deg = 2, x = "bottomleft", inset = 15)+
  plot(points, par(bg = NA))

  plot(points)+
    plot(Bottlenose_map, image = TRUE, land = TRUE, lwd = 0.1, asp = NA,
               bpal = list(c(0, max(Bottlenose_map), greys), c(min(Bottlenose_map), 0, blues)))+
    scaleBathy(Bottlenose_map, deg = 2, x = "bottomleft", inset = 7.5)+
  title("Bottlenose Dolphin Sightings")
  

#points needs to be just the Lat and Lon coordinates subsetted from Bottlenose_dolphin this should resolve the issue of it being 30+mb.

points <- subset(Bottlenose_Dolphin,
                 select=c(LonS, LatS),bg=NA)
plot(points) 
  
#Use Mapview package to create interactive maps showing the difference between effort and casual based data surveys plotted on the same map, 
# this can be done for each individual species. 
  
# First Bottlenose_map needs to be converted from a bathy to a data.frame so GGplot can understand it

head(fortify(Bottlenose_map))
ggplot(Bottlenose_map) + geom_contour(aes(x=x,y=y, z=z)) + coord_map()

Bottlenose_map.fn <- fortify(Bottlenose_map)
ggplot(Bottlenose_map.fn, aes(x=x, y=y)) + coord_quickmap()+
  geom_raster(aes(fill=z), data = Bottlenose_map.fn[Bottlenose_map.fn$z <= 0,])+
  geom_contour(aes(z=z),
               breaks=c(-100, -200, -500, -1000, -2000, -4000),
               colour ="white", size=0.1
               )+
  scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0))+
geom_point(points)

points <- st_as_sf(points,
                   coords = c("LonS", "LatS"),
                   crs = st_crs(Bottlenose_map.fn))

mapview(Bottlenose_map.fn, zcol = "points")


