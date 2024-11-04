library(plotly)
library(FNN)
library(dplyr)
library(caret)


climate <- read.csv('climate.csv')

climate_ann <- climate[climate$YEAR == 2022, c("LAT", "LON", "ANN")]


predictors <- climate_ann[, c("LAT", "LON")]
response <- climate_ann$ANN



# Set the number of neighbors
k <- 3

# Apply KNN regression
knn_model <- knn.reg(train = predictors, y = response, k = k)

# View predictions
predictions <- knn_model$pred

# Compare predictions with actual response
results <- data.frame(Actual = response, Predicted = predictions)
print(results)


# Calculate Mean Squared Error
mse <- mean((predictions - response)^2)
print(paste("Mean Squared Error:", mse))

# Residuals
residuals <- results$Actual - results$Predicted


# Generate a grid of points for the surface
x_seq <- seq(min(predictors$LAT), max(predictors$LAT), length.out = 30)
y_seq <- seq(min(predictors$LON), max(predictors$LON), length.out = 30)

# Create a grid dataframe with all combinations of regressor values
grid <- expand.grid(regressor1 = x_seq, regressor2 = y_seq)

# Predict the response for each point in the grid
grid_predictions <- knn.reg(train = predictors, y = response, test = grid, k = k)$pred

# Reshape predictions into a matrix for the surface plot
z_matrix <- matrix(grid_predictions, nrow = length(x_seq), ncol = length(y_seq))




# Plot the 3D scatterplot with original data points and the KNN surface
p <- plot_ly()

# Add original data points
p <- add_trace(p, x = climate_ann$LAT, y = climate_ann$LON, z = climate_ann$ANN,
               type = 'scatter3d', mode = 'markers', marker = list(size = 2, color = '#B7410E'), name = "Data Points")

# Add KNN regression surface
p <- add_surface(p, x = x_seq, y = y_seq, z = z_matrix, opacity = 0.5, showscale = FALSE, name = "KNN Surface")

# Set layout
p <- layout(p, scene = list(
  xaxis = list(title = "LAT"),
  yaxis = list(title = "LON"),
  zaxis = list(title = "Annual Temp")
))

# Display plot
p







# Standardize the data
preProc <- preProcess(climate_ann, method = c("center", "scale"))
climate_ann_scaled <- predict(preProc, climate_ann)


# Define the range of K values
k_values <- 1:20

# Set up cross-validation parameters
train_control <- trainControl(method = "cv", number = 11)  # 11-fold CV


# Train the KNN model and tune for optimal K
knn_model <- train(
  ANN ~ .,  # Assuming your response variable is named 'response'
  data = climate_ann_scaled, 
  method = "knn",
  trControl = train_control,
  tuneGrid = data.frame(k = k_values),
  ##metric = "MAE"  # Use MAE as an alternative metric
)


# Display the results
print(knn_model)

# Extract the best value of K
optimal_k <- knn_model$bestTune$k
cat("Optimal K:", optimal_k, "\n")



# Plot cross-validation error vs. K
plot(knn_model)



