library(maps)
library(dplyr)
climate <- read.csv("Climate.csv")
dim(climate) # 9580  X  16
dim(unique(climate[,c(1,2,3)])) # 4072  X  3

dim(unique(climate)) # 4072 X 16
climate.filt <- unique(climate)
library(maps)
x <- climate.filt$LON   # Longitude
y <- climate.filt$LAT   # Latitude
geoloc <- map.where("world", x = x, y = y)
table(geoloc)
# Country Filtration step
climate.geoloc <- cbind(climate.filt,geoloc)
# Only India
climate.geoloc[climate.geoloc$geoloc=="India", ]
climate.india <- climate.geoloc[climate.geoloc$geoloc=="India", ][-17]

# Visualisation of LAT's and LON's
x <- climate.india$LON   # Longitude
y <- climate.india$LAT
map("world", fill = TRUE, col = "salmon", bg = "lightblue", border = "darkblue")

# Add points
points(x, y, col = "blue")