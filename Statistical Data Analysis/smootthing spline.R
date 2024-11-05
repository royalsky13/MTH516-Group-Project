# Load the necessary package
library(mgcv)
library(ggplot2)
library(dplyr)


climate <- read.csv('climate.csv')

data <- climate[climate$YEAR == 2022, c("LAT", "LON", "ANN")]


# Fit a smoothing spline with two predictors using GAM
spline_fit <- gam(ANN ~ s(LAT, LON), data = data)

# Predict smoothed values on the original data
data$y_smooth <- predict(spline_fit)

mean((data$ANN-data$y_smooth)^2) #7.15214

# Visualize the smoothed values in 3D using plotly
library(plotly)

plot_ly(data, x = ~LON, y = ~LAT, z = ~ANN, type = 'scatter3d', mode = 'markers',
        marker = list(size = 3, color = 'blue'), name = "Original Data") %>%
  add_markers(x = ~LON, y = ~LAT, z = ~y_smooth, marker = list(size = 3, color = 'red'),
              name = "Smoothing Spline Prediction") %>%
  layout(scene = list(xaxis = list(title = 'LON'),
                      yaxis = list(title = 'LAT'),
                      zaxis = list(title = 'y')),
         title = "3D Scatter Plot with Smoothing Spline Predictions")



# Create a grid of x1 and x2 values for the surface
grid_LAT <- seq(min(data$LAT), max(data$LAT), length.out = 50)
grid_LON <- seq(min(data$LON), max(data$LON), length.out = 50)
grid <- expand.grid(LAT = grid_LAT, LON = grid_LON)

# Predict smoothed values on the grid
grid$y_smooth <- predict(spline_fit, newdata = grid)

# Reshape the grid for a 3D surface plot
z_matrix <- matrix(grid$y_smooth, nrow = length(grid_LAT), ncol = length(grid_LON))

# 3D plot with plotly, showing both the surface and original data points
plot_ly() %>%
  # Add surface for smoothing spline predictions
  add_surface(x = ~grid_LON, y = ~grid_LAT, z = ~z_matrix, colorscale = "Viridis", showscale = TRUE) %>%
  # Add original data points
  add_markers(x = ~data$LON, y = ~data$LAT, z = ~data$ANN, marker = list(size = 3, color = 'red'), name = "Original Data") %>%
  layout(scene = list(xaxis = list(title = 'LON'),
                      yaxis = list(title = 'LAT'),
                      zaxis = list(title = 'ANN')),
         title = "3D Smoothing Spline Surface with Original Data Points")
