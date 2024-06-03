# Financial Forecasting

# Requried libraires
packages <- c("neuralnet", "caret", "Metrics", "dplyr")
installed_packages <- installed.packages()
for (pkg in packages) {
  if (!pkg %in% installed_packages[, "Package"]) {
    install.packages(pkg, dependencies = TRUE)
  }
}
library(neuralnet)
library(caret)
library(Metrics)
library(dplyr)

# Loading and preprocessing data
exchange_rate_data <- read.csv("EURUSDX.csv")
dim(exchange_rate_data)

# Cleaning data
time_series_data <- exchange_rate_data$Close
time_series_data <- as.numeric(time_series_data)
time_series_data <- na.omit(time_series_data)
head(time_series_data)
plot(time_series_data, type = "l", main = "Time Series Data", xlab = "Time", ylab = "Exchange Rate")

# Statistical summary
summary(time_series_data)

# Histogram and Density Plot
hist(time_series_data, breaks = 50, main = "Histogram of Exchange Rates", xlab = "Exchange Rate", col = "lightblue")
lines(density(time_series_data), col = "red", lwd = 2)

# Boxplot
boxplot(time_series_data, main = "Boxplot of Exchange Rates", ylab = "Exchange Rate")

# Autocorrelation plot
acf(time_series_data, main = "ACF of Exchange Rates")

dataset_min <- min(time_series_data)
dataset_max <- max(time_series_data)

# Time lags
lagged_data <- data.frame(T_minus4 = lag(time_series_data,4),
                          T_minus3 = lag(time_series_data,3),
                          T_minus2 = lag(time_series_data,2),
                          T_minus1 = lag(time_series_data,1),
                          T_pred = time_series_data)

head(lagged_data)

lagged_data <- na.omit(lagged_data)
head(lagged_data)
str(lagged_data)

# Lag plot
lag.plot(time_series_data, lags = 4, do.lines = FALSE, main = "Lag Plot of Exchange Rates")

# Normalisation function
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

lagged_data_normalized <- as.data.frame(lapply(lagged_data, normalize))
head(lagged_data_normalized)

# Train test split
training_data <- lagged_data_normalized[1:3800, ]
testing_data <- lagged_data_normalized[3801:nrow(lagged_data_normalized)-4, ]
head(training_data)
head(testing_data)
plot(training_data)
plot(testing_data)

original_training_data <- time_series_data[1:3800] 
head(original_training_data)
original_testing_data <- time_series_data[3801:4751] 
head(original_testing_data)

dataset_min <- min(time_series_data)
dataset_min
dataset_max <- max(time_series_data)
dataset_max

# Denormalisation function
denormalize <- function(x, min, max) {
  return( (max - min) * x + min )
}

set.seed(123)

# MLP Model
dataset_model1 <- neuralnet(
  formula = T_pred ~ T_minus4 + T_minus3 + T_minus2 + T_minus1,
  data = training_data,
  hidden = 12,
  linear.output = TRUE,
  act.fct = 'logistic'
)
plot(dataset_model1)


# Model predictions
predicted_results_model1 <- predict(dataset_model1, testing_data)
head(predicted_results_model1)

predicted_T <- predicted_results_model1
head(predicted_T)
dim(predicted_T)

target_prediction <- denormalize(predicted_T, dataset_min, dataset_max)
head(target_prediction) 
dim(target_prediction)

# Statistical indices
rmse_val <- rmse(unlist(original_testing_data), unlist(target_prediction))
mae_val <- mae(unlist(original_testing_data), unlist(target_prediction))
mape_val <- mape(unlist(original_testing_data), unlist(target_prediction))
smape_val <- smape(unlist(original_testing_data), unlist(target_prediction))

# Output statistics
cat("RMSE:", rmse_val, "\n")
cat("MAE:", mae_val, "\n")
cat("MAPE:", mape_val, "\n")
cat("sMAPE:", smape_val, "\n")

# Model evaluation
plot(unlist(original_testing_data), unlist(target_prediction),
     xlab = "Desired Output", ylab = "Predicted Output",
     main = "Predicted vs. Desired Output")
abline(0, 1, col = "red")  

time_indices <- seq_along(unlist(original_testing_data))

plot(time_indices, unlist(original_testing_data), type = "l", col = "blue",
     xlab = "Time", ylab = "Exchange Rate",
     main = "Predicted vs. Desired Output")

lines(time_indices, unlist(target_prediction), col = "red")

legend("topleft", legend = c("Desired Output", "Predicted Output"),
       col = c("blue", "red"), lty = 1)



