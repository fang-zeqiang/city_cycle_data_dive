library(dplyr)
library(tidyr)
library(reshape2)
library(tidyverse)
library(mapsf)
library(readr)
library(janitor)
library(sf)
library(sp)
library(magrittr)


pk <- st_read("geo/parking.shp")



pk <- pk %>%
  clean_names()%>%
  select(feature_id,prk_secure,prk_locker,prk_cpt,geometry)

pk1 <- dplyr::mutate(pk,havelock=ifelse(prk_secure == TRUE | prk_locker == TRUE, TRUE,FALSE))

pkt <- pk1 %>%
  filter(havelock == TRUE)%>%
  select(feature_id,geometry,prk_cpt)%>%
  rename(lockpark = prk_cpt)

pkf <- pk1 %>%
  filter(havelock == FALSE)%>%
  select(feature_id,geometry,prk_cpt)%>%
  rename(unlockpark = prk_cpt)

lsoa <- st_read("boundary/London_Borough_Excluding_MHW.shp")
lsoa <- lsoa %>% 
  clean_names()%>%
  select(gss_code,geometry,name)

lsoa <- lsoa %>% st_transform(.,crs="epsg:27700")


pkjoin <- lsoa%>%
  st_join(pkt)%>%
  add_count(gss_code)%>%
  mutate(area=st_area(.))%>%
  #then density of the points per ward
  mutate(lockden=n/area)%>%
  #select density and some other variables 
  dplyr::select(lockden, gss_code, n)
pkjoin<- pkjoin %>%                    
  group_by(gss_code) %>%         
  summarise(lockden = first(lockden),
            gss_code= first(gss_code),
            lockcount= first(n))

pkjoin <- pkjoin%>%
  st_join(pkf)%>%
  add_count(gss_code)%>%
  mutate(area=st_area(.))%>%
  #then density of the points per ward
  mutate(unlockden=n/area)%>%
  mutate(lockpo=lockcount/(n+lockcount))%>%
  mutate(allpark = n + lockcount)%>%
  #select density and some other variables 
  dplyr::select(allpark,lockpo,lockden,lockcount,unlockden, gss_code, n)
pkjoin<- pkjoin %>%                    
  group_by(gss_code) %>%         
  summarise(gss_code= first(gss_code),
            allpark = first(allpark),
            lockpo = first(lockpo),
            unlockden = first(unlockden),
            lockden = first(lockden),
            lockcount = first(lockcount),
            unlockcount= first(n))

pkjoin <- pkjoin %>%
  mutate(pkjoin,status=ifelse(lockpo>=0.05,">= 5%","< 5%"))



