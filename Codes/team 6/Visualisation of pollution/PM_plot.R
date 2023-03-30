#PM
car_data <- read.csv("C:/Users/MI/Desktop/data-source/PM_plot.csv")
names(car_data) <- c("NAME","PM2.5_Exhaust_weighted","PM10_exhaust_weighted")
head(car_data,5)
#london wards
library(sp)
library(rgdal)
library(maptools)
london_wards <- readOGR(dsn = "C:/Users/MI/Desktop/data-source/London-wards-2014/London-wards-2014 (1)/London-wards-2014_ESRI/London_Ward.shp") 
head(london_wards@data,5)
#join
library(dplyr)
london_wards@data <- left_join(london_wards@data, car_data, by = c('NAME' = 'NAME'))
head(london_wards@data)
install.packages("viridis")
library("viridis")
library(ggplot2)
london_wards_f <- fortify(london_wards)
# allocate an id variable to the sp data
london_wards$id <- row.names(london_wards)
# joins the data
london_wards_f <- left_join(london_wards_f, london_wards@data) 
head(london_wards_f,5)
#data preparation is over

#visualize the maps
ggplot(london_wards_f, aes(long, lat, group = group, fill=`PM2.5_Exhaust_weighted`)) +
  geom_polygon() + geom_path(colour="black", lwd=0.05) + coord_equal() +
  labs(x = "lat", y = "lon",
       fill = "PM2.5_Exhaust_weighted") +
  scale_fill_viridis(alpha = 0.8, begin = 0.2, end = 0.9, option = "C", name = "PM2.5") +
  #scale_fill_gradientn(colours = c("white", "yellow", "orange", "red"))
  #scale_fill_gradientn(colours = c("#FFEBEB", "#FD7C7C", "#FF0000", "#9A0707"))+
  ggtitle("PM2.5_Exhaust_weighted") +
  theme(axis.text = element_blank(), 
        axis.title = element_blank(), 
        axis.ticks = element_blank()) 

#visualize the maps-2:
ggplot(london_wards_f, aes(long, lat, group = group, fill=`PM10_exhaust_weighted`)) +
  geom_polygon() + geom_path(colour="black", lwd=0.05) + coord_equal() +
  labs(x = "lat", y = "lon",
       fill = "PM10_exhaust_weighted") +
  scale_fill_viridis(alpha = 0.8, begin = 0.2, end = 0.9, option = "C", name = "PM10") +
  #scale_fill_gradientn(colours = c("darkred", "orange", "yellow", "white"))
  #scale_fill_gradientn(colours = c("#FFEBEB", "#FD7C7C", "#FF0000", "#9A0707"))+
  ggtitle("PM10_Exhaust_weighted") +
  theme(axis.text = element_blank(), 
        axis.title = element_blank(), 
        axis.ticks = element_blank()) 

