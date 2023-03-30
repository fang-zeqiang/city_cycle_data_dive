
weekday <- read.csv('D:/F_SCUA-UCL/CUSP/data/data/all_cities.csv')



pb <- parkbay

##这里是把单位设置成km然后后面设置缓冲区得时候好写数值
pb_km <- st_transform(pb, "+proj=utm +zone=42N +datum=WGS84 +units=km")

#这个star和end是我把数据扔进arcgis里转出来的不知道你会不会
star <- st_read('D:/F_SCUA-UCL/CUSP/data/allstar.shp')
end <- st_read('D:/F_SCUA-UCL/CUSP/data/allend.shp')

star <- star %>%
  st_set_crs(4326)
end <- end %>%
  st_set_crs(4326)

#同上
star_km <- st_transform(star, "+proj=utm +zone=42N +datum=WGS84 +units=km")
end_km <- st_transform(end, "+proj=utm +zone=42N +datum=WGS84 +units=km")

#设置缓冲区
chesterbuffer <- pb_km %>%
  st_buffer(.,0.05)
qtm(chesterbuffer)

#把缓冲区和起点重合，求交集，这样可以去掉那些很远的点
chester_intersectstar <- st_join(star_km, chesterbuffer)


#和到达点求交集
chester_intersectend <- st_join(chesterbuffer, end_km)


#为了防止之后合并数据集 很多列会重复，去掉一些，先去掉地理信息
chester_intersectstar <- st_drop_geometry(chester_intersectstar)

#只留下id和parkbay
chester_intersectstar <- chester_intersectstar  %>%
  select(.,ride_id, Parking_Ba)%>%
  rename('source' = 'Parking_Ba')

#求起点和终点数据的交集，就是把一次同行的起点终点对应在一起
chester <- merge(chester_intersectstar, chester_intersectend, by =c ("ride_id" = "ride_id"))

head(chester)

amount <-
  group_by(chester, source, Parking_Ba,day_of_th_ ) %>%
  rename('destination' = 'Parking_Ba')%>%
  summarise (n=n())

amount_geo <- left_join(amount, parkbay, by = c('source' = 'Parking_Ba'))%>%
  rename('sourcelat' ='Longitude','sourcelon'= 'Latitude')

amount_geo <- left_join(amount_geo, parkbay, by = c('destination' = 'Parking_Ba'))%>%
  rename('deslat' ='Longitude','deslon'= 'Latitude')
head(amount)
head(parkbay)

amount_geo <- amount_geo %>%
  select(.,-geometry.x,-geometry.y,Fleet.x)%>%
  rename('Fleet' = 'Fleet.y')

write.csv(amount_geo, file = "week.csv")


w<- group_by(chester, day_of_th_ ) %>%
  rename('destination' = 'Parking_Ba')%>%
  summarise (n=n()) 

write.csv(w,file = 'whole.csv')
head(chester)



#########statistics

w1 <- chester %>%
  filter(., Fleet.x == 'Chester') 
w1 <- w1 %>%
  group_by(day_of_th_)%>%
  summarise (n=n())%>%
  rename('chester' = 'day_of_th_')
write.csv(w1,file = 'chesterweek.csv')


w2 <- chester %>%
  filter(., Fleet.x == 'Hartlepool') 
w2 <- w2 %>%
  group_by(day_of_th_)%>%
  summarise (n=n())%>%
  rename('Hartlepool' = 'day_of_th_')
write.csv(w2,file = 'Hartlepoolweek.csv')

w3 <- chester %>%
  filter(., Fleet.x == 'Middlesbrough') 
w3 <- w3 %>%
  group_by(day_of_th_)%>%
  summarise (n=n())%>%
  rename('Middlesbrough' = 'day_of_th_')
write.csv(w3,file = 'Middlesbroughweek.csv')

w4 <- chester %>%
  filter(., Fleet.x == 'Scunthorpe') 
w4 <- w4 %>%
  group_by(day_of_th_)%>%
  summarise (n=n())%>%
  rename('Scunthorpe' = 'day_of_th_')
write.csv(w4,file = 'Scunthorpeweek.csv')

w5 <- chester %>%
  filter(., Fleet.x == 'Stafford') 
w5 <- w5 %>%
  group_by(day_of_th_)%>%
  summarise (n=n())%>%
  rename('Stafford' = 'day_of_th_')
write.csv(w5,file = 'Staffordweek.csv')


w6 <- chester %>%
  filter(., Fleet.x == 'Milton Keynes') 
w6 <- w6 %>%
  group_by(day_of_th_)%>%
  summarise (n=n())%>%
  rename('Milton Keyne' = 'day_of_th_')
write.csv(w6,file = 'Milton_Keyneweek.csv')





###############
w1 <- amount_geo %>%
  filter(., Fleet.x == 'Chester') 
w2 <- amount_geo %>%
  filter(., Fleet.x == 'Hartlepool') 

w3 <- amount_geo %>%
  filter(., Fleet.x == 'Middlesbrough') 

w4 <- amount_geo %>%
  filter(., Fleet.x == 'Scunthorpe') 

w5 <- amount_geo %>%
  filter(., Fleet.x == 'Stafford') 

w6 <- amount_geo %>%
  filter(., Fleet.x == 'Milton Keynes') 




chestermonday <- w1 %>%
  filter(., day_of_th_ == 'Mon')
write.csv(chestermonday, file = 'chestermonday.csv')

chestertuesday <- w1 %>%
  filter(., day_of_th_ == 'tue')
write.csv(chestertuesday, file = 'chestertue.csv')

chesterwed <- w1 %>%
  filter(., day_of_th_ == 'wed')
write.csv(chesterwed, file = 'chesterwed.csv')

chesterthu <- w1 %>%
  filter(., day_of_th_ == 'thu')
write.csv(chesterwed, file = 'chesterthu.csv')

chesterfir <- w1 %>%
  filter(., day_of_th_ == 'fir')
write.csv(chesterfir, file = 'chesterfir.csv')

chestersat <- w1 %>%
  filter(., day_of_th_ == 'sat')
write.csv(chestersat, file = 'chestersat.csv')

chestersun <- w1 %>%
  filter(., day_of_th_ == 'sun')
write.csv(chestersun, file = 'chestersun.csv')
