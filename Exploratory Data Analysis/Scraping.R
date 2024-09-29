library(maps)
climate <- read.csv("Climate.csv")
any(is.na(climate)) # FALSE (devoid of NA's)
dim(climate) # 9580  X  16
dim(unique(climate)) # 4072 X 16

climate.filt <- unique(climate)

x <- climate.filt$LON   # Longitude
y <- climate.filt$LAT   # Latitude
geoloc <- map.where("world", x = x, y = y)
sum(is.na(geoloc)) # 676 location coordinates weren't detected
table(geoloc)
sum(table(geoloc)) # 4072 - 676 = 3396

# Country Filtration step
climate.geoloc <- cbind(climate.filt, geoloc)
# Only India
climate.geoloc[climate.geoloc$geoloc=="India", ]
climate.india <- climate.geoloc[climate.geoloc$geoloc=="India", ][-17]
dim(climate.india) # 2898 X 16
# NA Removal Step
columns <- c("YEAR", "LAT", "LON", "JAN", "FEB", "MAR", "APR", "MAY", 
                      "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC", "ANN")

# Filter the rows where all specified columns have no NA
climate.india <- climate.india[complete.cases(climate.india[, columns]), ]
any(is.na(climate.india)) # FALSE
dim(climate.india) # 2222 X 16

# Re-numbering row names
row.names(climate.india) <- 1:dim(climate.india)[1]
View(climate.india)

# Visualisation of LAT's and LON's
x <- climate.india$LON   # Longitude
y <- climate.india$LAT   # Latitude
map("world", fill = TRUE, col = "salmon", bg = "lightblue", border = "darkblue")

# Add points
points(x, y, col = "blue")

# Rdata save
save(climate.india, file = "temperature.Rdata")
