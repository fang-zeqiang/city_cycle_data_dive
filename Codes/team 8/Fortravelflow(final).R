library(maptools)
library(RColorBrewer)
library(classInt)
library(sp)
library(rgeos)
library(tmap)
library(tmaptools)
library(sf)
library(rgdal)
library(geojsonio)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(mapview)
library(rgeos)


## parkbay point
parkbay <- st_read(
  'D:/F_SCUA-UCL/CUSP/data/parkbay.shp')
qtm(parkbay)

## set crs
parkbay <- parkbay %>%
  st_set_crs(4326)

## Select City 
chesterpark <- parkbay %>%
  filter(Fleet == 'Chester')
qtm(chesterpark)

## Here is to set the unit to km in order to set the buffer later
chesterpark_km <- st_transform(chesterpark, "+proj=utm +zone=42N +datum=WGS84 +units=km")

# the point datasets are processed by Qgis
star <- st_read('D:/F_SCUA-UCL/CUSP/data/m2014star.shp')
end <- st_read('D:/F_SCUA-UCL/CUSP/data/m2014end.shp')

star <- star %>%
  st_set_crs(4326)
end <- end %>%
  st_set_crs(4326)

#Here is to set the unit to km 
star_km <- st_transform(star, "+proj=utm +zone=42N +datum=WGS84 +units=km")
end_km <- st_transform(end, "+proj=utm +zone=42N +datum=WGS84 +units=km")

## Set buffer
chesterbuffer <- chesterpark_km %>%
  st_buffer(.,0.05)
qtm(chesterbuffer)
  
# INTERSECT
chester_intersectstar <- st_join(star_km, chesterbuffer)


#intersect
chester_intersectend <- st_join(chesterbuffer, end_km)


# 
chester_intersectstar <- st_drop_geometry(chester_intersectstar)

#Leave only id and parkbay
chester_intersectstar <- chester_intersectstar  %>%
  select(.,ride_id, Parking_Ba)%>%
  rename('source' = 'Parking_Ba')

#Finding the intersection of the starting point and the end point data is to map the start and end points of a peer
chester <- merge(chester_intersectstar, chester_intersectend, by =c ("ride_id" = "ride_id"))

amount <-
  group_by(chester, source, Parking_Ba) %>%
  rename('destination' = 'Parking_Ba')%>%
  summarise (n=n())

amount_geo <- left_join(amount, parkbay, by = c('source' = 'Parking_Ba'))%>%
  rename('sourcelat' ='Longitude','sourcelon'= 'Latitude')

amount_geo <- left_join(amount_geo, parkbay, by = c('destination' = 'Parking_Ba'))%>%
  rename('deslat' ='Longitude','deslon'= 'Latitude')
head(amount)
head(parkbay)

amount_geo <- amount_geo %>%
  select(.,-geometry.x,-geometry.y,-Fleet.x)%>%
  rename('Fleet' = 'Fleet.y')

write.csv(amount_geo, file = "chester.csv")


