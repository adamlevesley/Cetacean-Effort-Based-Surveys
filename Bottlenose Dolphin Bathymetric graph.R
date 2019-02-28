#Packages that I need


library(tidyverse)
library(marmap)
library(dplyr)
library(SDMTools)
library(rgdal)
library(mapproj)


#---------Read in the Data-----------------


Effort <- read_csv("AdamLevesley_EffortSightings.csv")
#----------------------------------------------



#------------- Convert coordinate data------------------
head(Effort)
coordinates(Effort)<-~LonS+LatS
head(Effort)
plot(Effort)
proj4string(Effort)<- "+proj=utm +zone=30 ellps=WGS84"
Effort <- spTransform(Effort, CRS("+proj=longlat +datum=WGS84"))
Effort <- data.frame(Effort)
head(Effort)

#-----------Coordinates have now been converted into WGS84 format--------------------

Effort %>% select(Effort, contains("Bottlenose Dolphin") %>% slice(1924:8171))
Effort


