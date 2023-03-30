library(lubridate)

weekday <- read.csv('D:/F_SCUA-UCL/CUSP/data/data/all_cities.csv')

weekday$c <- hour(weekday$Time)

whole <- weekday %>%
  group_by(., c) %>%
  summarise (n=n())
write.csv(whole, file = 'wholedaily.csv')

head(weekday)

monday <- weekday %>%
  filter(., day_of_th_week == 'Mon')%>%
  group_by(., c) %>%
  summarise (n=n())
write.csv(monday, file = 'wmondaily.csv')

saturday <- weekday %>%
  filter(., day_of_th_week == 'Sat')%>%
  group_by(., c) %>%
  summarise (n=n())
write.csv(saturday, file = 'wsatdaily.csv')

weekmonday <- weekday %>%
  filter(., day_of_th_week == 'Mon')

weekmonday <- weekmonday %>%
  filter(., Fleet == 'Chester')

m69 <- weekmonday %>%
  filter(c >= 6) %>%
  filter(c <= 9)
write.csv(m69, file = 'm69.csv')

m1015 <- weekmonday %>%
  filter(c >= 10) %>%
  filter(c <= 15)
write.csv(m1015, file = 'm1015.csv')

m1619 <- weekmonday %>%
  filter(c >= 16) %>%
  filter(c <= 19)
write.csv(m1619, file = 'm1619.csv')

m2024 <- weekmonday %>%
  filter(c >= 20) %>%
  filter(c <= 24)
write.csv(m1619, file = 'm1619.csv')

s69 <- clock2 %>%
  filter(m1 >= 6) %>%
  filter(m1 <= 9)

s1015 <- clock2 %>%
  filter(m1 >= 10) %>%
  filter(m1 <= 15)

s1619 <- clock2 %>%
  filter(m1 >= 16) %>%
  filter(m1 <= 19)

s2024 <- clock2 %>%
  filter(m1 >= 20) %>%
  filter(m1 <= 24)