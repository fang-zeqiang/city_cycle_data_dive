options(scipen = 200)

lsoa <- st_read("boundary/London_Ward_CityMerged.shp")
lsoa <- lsoa %>% 
  clean_names()%>%
  select(gss_code,geometry,name,hectares)

lsoa <- lsoa %>% st_transform(.,crs="epsg:27700")

pkjoin <- lsoa%>%
  st_join(pkt)%>%
  add_count(gss_code)%>%
  #then density of the points per ward
  mutate(lockden=n/hectares)%>%
  #select density and some other variables 
  dplyr::select(lockden, gss_code, n,hectares)
pkjoin<- pkjoin %>%                    
  group_by(gss_code) %>%         
  summarise(lockden = first(lockden),
            gss_code= first(gss_code),
            lockcount= first(n),
            hectares = first(hectares))

pkjoin <- pkjoin%>%
  st_join(pkf)%>%
  add_count(gss_code)%>%
  #then density of the points per ward
  mutate(unlockden=n/hectares)%>%
  mutate(lockpo=lockcount/(n+lockcount))%>%
  mutate(allpark = n + lockcount)%>%
  mutate(allden = (n + lockcount)/hectares)%>%
  #select density and some other variables 
  dplyr::select(hectares,allpark,allden,lockpo,lockden,lockcount,unlockden, gss_code, n)
pkjoin<- pkjoin %>%                    
  group_by(gss_code) %>%         
  summarise(gss_code= first(gss_code),
            allpark = first(allpark),
            allden = first(allden),
            lockpo = first(lockpo),
            unlockden = first(unlockden),
            lockden = first(lockden),
            lockcount = first(lockcount),
            unlockcount= first(n),
            hectares=first(hectares))

pkjoin <- pkjoin %>%
  mutate(pkjoin,status=ifelse(lockpo>=0.05,">= 5%","< 5%"))
