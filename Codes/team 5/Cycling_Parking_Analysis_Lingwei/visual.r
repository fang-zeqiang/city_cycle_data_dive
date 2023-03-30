breaks<-c(0,100,200,300,400)

breaks1<-c(0,500,1000,1500,2000,2500)


# Initiate a map figure with a theme and extra margins 
mf_init(x = pkjoin, theme = "dark", expandBB = c(0,0,0,.3),
        export = "svg", filename = "mtq.svg", width = 6) 
# Plot a shadow
mf_shadow(pkjoin, col = "grey10", add = TRUE)
# Plot a choropleth map
mf_map(x = pkjoin, var = "allpark", type = "choro",
       pal = "Dark Mint", 
       breaks = breaks , 
       nbreaks = 5, 
       leg_title = "Bike Parking Facilities", 
       leg_val_rnd = -2, 
       add = TRUE)
# Start an inset map
mf_inset_on(x = "worldmap", pos = "topright")
# Plot the position of the sample dataset on a worlmap
mf_worldmap(pkjoin, col = "#0E3F5C")
# Close the inset
mf_inset_off()
# Plot a title
mf_title("London Bike Parking facilities counts by ward")
# Plot credits
mf_credits("Lingwei\nSources: LondonDatastore, 2021")
# Plot a scale bar
mf_scale(size = 5)
# Plot a north arrow
mf_arrow('topleft')
dev.off()


mf_theme("agolalight")
pkjoin %>% 
  mf_map() %>%
  mf_map(c("allpark","status"), "prop_typo",
         leg_title = c("Parking Facilities Counts","Parking Facilities with Security")
  )
mf_title("London Bike Parking Facilities Counts by Borough")


# set theme
mf_init(x = pkjoin, theme = "candy", expandBB = c(0,0,0,.15))
# Plot a shadow
mf_shadow(pkjoin, add = TRUE)
# Plot the municipalities
mf_map(pkjoin, add = TRUE)
# Plot symbols with choropleth coloration
mf_map(
  x = pkjoin, 
  var = c("allpark", "status"), 
  type = "prop_choro",
  border = "grey50",
  lwd = 1,
  leg_pos = c("topright", "right"), 
  leg_title= c("Population","Median\nIncome\n(in euros)"),
  pal = "Greens",
  leg_val_rnd = c(0, -2), 
  leg_frame = c(TRUE, TRUE)
) 
# layout
mf_layout(title = "Population & Wealth in Martinique, 2015", 
          credits = paste0("Sources: Insee and IGN, 2018\n",
                           "mapsf ", 
                           packageVersion("mapsf")), 
          frame = TRUE)