
library(sp)
library(rgdal)
library(maptools)
library(sf)
library(ggplot2)
library(classInt)
london_wards <-  st_read(here::here("joined layer3.shp"))
Londonwards <- readOGR("joined layer3.shp")

breaks_qt <- classIntervals(var=c(0, london_wards$CO2_weight),
                            n=9, 
                            style = "quantile")

london_wards <- mutate(london_wards,  CO2 = cut(london_wards$CO2_weight,breaks_qt$brks)) 
ggplot(london_wards) + 
  geom_sf(aes(fill=CO2)) +
  scale_fill_brewer(palette = "OrRd") +  
  ggtitle("CO2_weight") +
  theme(axis.text = element_blank(), 
        axis.title = element_blank(), 
        axis.ticks = element_blank()) 

breaks_qt_2 <- classIntervals(var=c(0, london_wards$NOX_weight),
                            n=9, 
                            style = "quantile")
london_wards <- mutate(london_wards,  NOX = cut(london_wards$NOX_weight,breaks_qt_2$brks)) 
ggplot(london_wards) + 
  geom_sf(aes(fill=NOX)) +
  scale_fill_brewer(palette = "OrRd") +  
  ggtitle("NOX_weight") +
  theme(axis.text = element_blank(), 
        axis.title = element_blank(), 
        axis.ticks = element_blank()) 

breaks_qt_3 <- classIntervals(var=c(0, london_wards$percent_gr),
                              n=9, 
                              style = "quantile")
london_wards <- mutate(london_wards,  green = cut(london_wards$percent_gr,breaks_qt_3$brks)) 
ggplot(london_wards) + 
  geom_sf(aes(fill=green)) +
  scale_fill_brewer(palette = "YIGnBu") +  
  ggtitle("percentage_of_greenspace") +
  theme(axis.text = element_blank(), 
        axis.title = element_blank(), 
        axis.ticks = element_blank()) 





