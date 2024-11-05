
climate <- read.csv('climate.csv')

data <- climate[climate$YEAR == 2022, c("LAT", "LON", "ANN")]




# Apply LOESS with two regressors
loess_fit <- loess(ANN ~ LAT + LON, data = data, span = 0.5)  # Adjust 'span' for smoothing level

# Predictions on the original data
data$y_smooth <- predict(loess_fit)

loess_residual <- loess_fit$residuals

results <- data.frame(Actual = data$ANN, Predicted = data$y_smooth)

# Error
mean((data$ANN-data$y_smooth)^2) # 12.86997

# Load necessary library
library(plotly)

# Create a 3D scatter plot with original data and LOESS-smoothed predictions
plot_ly(data, x = ~LON, y = ~LAT, z = ~ANN, type = 'scatter3d', mode = 'markers',
        marker = list(size = 3, color = 'blue'), name = "Original Data") %>%
  add_markers(x = ~LON, y = ~LAT, z = ~y_smooth, marker = list(size = 3, color = 'red'),
              name = "LOESS Prediction") %>%
  layout(scene = list(xaxis = list(title = 'LON'),
                      yaxis = list(title = 'LAT'),
                      zaxis = list(title = 'ANN')),
         title = "3D Scatter Plot with LOESS Predictions")
