

##################################################################
# Use this block comment at the top of each R code file you submit
# Homework 7 – Submitted by Yao Wang on October 17, 2018
# Portions of this code came from Introduction to Data Science
# but the comments are all original.
# IST 687. Due is October 18, 2018

# step A: load and merge datasets
# re-use the code from HW3
readStates <- function()
{
  dfStates <- raw_data
  # Read form from outside of R. Create a new dataframe "dfStates", then reserve the form into "dfStates"
  # remover rows that not needed 
  dfStates <- dfStates[2:52, 5:8] #select only rows and columns of interest
  # rename the columns
  colnames(dfStates) <- c("stateName", "population","popOver18", "percentOver18") # rename the columns
  return(dfStates)
}

dfStates <- readStates()  
str(dfStates)
# 2. re-use the code from HW2
# create a column with "stateName", then can merage with the other dataframe "states"
dfArrests <- USArrests 
str(dfArrests)
# create a column with "stateName", then can merage with the other dataframe "states"
dfArrests$stateName <- row.names(dfArrests)
# merging is simple once there is a column field, a key, especially if the keys have the same name3333
dfMerged <- merge(dfStates, dfArrests)

# 2 Add the area of each state, and the center of each state,
# to the merged dataframe, using the ‘state.center’, ‘state area' and ‘state.name’ vectors 
stateName <- state.name
stateArea <- state.area
stateCenter <- state.center

dfNAC <- data.frame(stateName, stateArea, stateCenter)
dfMerged <- merge(dfMerged, dfNAC, by = "stateName")

# Step B: Generate a color coded map
# 3.Create a color coded map, based on the area of the state 

library(ggplot2)
library(ggmap)
library(mapproj)
library(maps)
dfMerged$stateName <- tolower(dfMerged$stateName)
map.Color <- ggplot(dfMerged, aes(map_id = stateName))
map.areaColor <- map.Color+ geom_map(map = us, aes(fill=state.area))
map.areaColor <- map.areaColor + expand_limits(x = us$long, y = us$lat)
map.areaColor <- map.areaColor+ coord_map() + ggtitle("Murder Rate of Each State")
map.areaColor
# Step C: Create a color shaded map of the U.S. based on the Murder rate for each state 
# 4. Repeat step B, but color code the map based on the murder rate of each state.
us <- map_data("state")
dfMerged$stateName <- tolower(dfMerged$stateName)
map.Color <- ggplot(dfMerged, aes(map_id = stateName))
map.MurderColor <- map.Color+ geom_map(map = us, aes(fill=Murder))
map.MurderColor <- map.MurderColor + expand_limits(x = us$long, y = us$lat)
map.MurderColor <- map.MurderColor+ coord_map() + ggtitle("Murder Rate of Each State")
map.MurderColor

# 5 Show the population as a circle per state (the larger the population, the larger the circle), 
# using the location defined by the center of each state
# add points to the map
map.Color <- ggplot(dfMerged, aes(map_id = stateName))
map.PopColor <- map.Color+ geom_map(map = us, aes(fill=population))
map.PopColor <- map.PopColor + expand_limits(x = us$long, y = us$lat)
map.PopColor <- map.PopColor+ coord_map() + ggtitle("Population of Each State")

map.PointColor <- map.PopColor + geom_point(data=dfMerged
                        ,aes(x=x, y=y, size=population), color= "tomato1")+ggtitle("Population of Each State")
map.PointColor

# Step D: Zoom the map
# 6.Repeat step C, but only show the states in the north east
Location <- geocode(source="dsk", "NYC, ny")
map.ZoomPointColor <- map.PointColor + xlim(Location$lon-10, Location$lon+10)+ylim(Location$lat-10, Location$lat+10)+coord_map()
map.ZoomPointColor
