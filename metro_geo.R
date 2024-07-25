rm(list= ls())
###########################
#install.packages("dplyr")
#install.packages("sf")



library(dplyr)
library(tidyverse)
library(sf)

################################################################################
##                     Complete the empty comune pollution                    ##
##                                                                            ##
##                                                                            ##
##                                                                            ##
################################################################################




################################################################################
commune <- read_sf(file.choose())
#Check the geographical system
st_crs(commune)

#By defining a rectangle cover just France metropolitan, we can remove outre mer commune
metro <- st_crop(commune,ymax=51.0716667,xmax=9.5600000,ymin=41.2822222,xmin=-5.1511111)
st_write(metro,"C:/Users/desktop")




#Nest part show an exemple to use this geo info set
#Read the pollution dataset
pollution <- read.csv(file.choose())

#convert polution data frame into sf object,with the same geo system of 'commune'
pollution_sf <- st_as_sf(pollution,coords = c("longitude","latitude"), crs = st_crs(commune))

#Join the pollution set into geo set, NA represent the commune without pollution detect point
pollution_in_sf <- sf::st_join(metro,pollution_sf,join = st_intersects,left = TRUE)

pollution_com_week <- dplyr::group_by(jointopollu_df,week,insee) %>% 
  summarise(PM25_lock_W = mean(PM25_lock_w)) %>% 
  ungroup()

#An exemple to plot a cartographic , you can fill with your data
ggplot2::ggplot()+
  geom_sf(data=pollu_year_sf,aes(fill = pm25))+
  scale_fill_gradientn(colors = c("green", "yellow", "red"), values = c(0, 0.5, 1), name = "PM2.5Intensity") +
  theme_void()



