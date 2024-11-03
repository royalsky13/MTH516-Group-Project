#==============================================================================#
#                                 EDA Plots
#==============================================================================#

# Importing necessary library
library(ggplot2)

# Loading the dataset
clim.data = read.csv("C:/Users/Swapnonil/Downloads/Climate_of_India.csv")
clim.data = clim.data[which(clim.data$YEAR == 2022), ]

# Histogram of Annusal Temperature
ggplot() +
  geom_histogram(aes(x = ANN, y = after_stat(density)), data = clim.data, bins = 10) +
  labs(title = "Histogram of Annual Temperature",
       x = "Annual Temperature", y = "Frequency Density")

# Density Plot of Annual Temperature
ggplot() +
  geom_line(aes(x = x, y = y), 
            data = data.frame(x = density(clim.data$ANN, bw = 2.5)$x, 
                              y = density(clim.data$ANN, bw = 2.5)$y)) +
  labs(title = "Distribution of Annual Temperature",
       x = "Annual Temperature", y = "Frequency Density")

# Here the common range of all the features is taken
common_range = range(c(clim.data[, 4:16]))

# Spatial Maps
# Here I just changed the Name of the feature and the Titles
ggplot() +
  geom_tile(aes(x = LON, y = LAT, fill = ANN), data = clim.data) +
  coord_fixed(ratio = 1) +
  scale_fill_viridis_c(name = "Range", option = "viridis", limits = common_range) +
  labs(title = "Annual Temperature Heat Map", 
       x = "Longitude",
       y = "Latitude") +
  theme(plot.title = element_text(hjust = 0.5))
