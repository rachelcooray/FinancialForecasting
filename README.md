# Financial Forecasting
This repository contains code for forecasting exchange rates using a neural network model. The project involves data preprocessing, model training, and evaluation. The results include various statistical indices and visualizations to assess model performance.

## Introduction

The goal of this project is to forecast the exchange rate using historical data. The dataset used is EURUSDX.csv which contains exchange rate data. The model is built using a Multilayer Perceptron (MLP) neural network.

## Requirements

The following R packages are required:

neuralnet
caret
Metrics
dplyr

## Data

The dataset EURUSDX.csv should be placed in the working directory. It contains the historical exchange rate data used for forecasting.

## Preprocessing

The data preprocessing steps include:

Loading and cleaning the data
Generating time lags
Normalizing the data
Splitting the data into training and testing sets

## Model

An MLP neural network model is trained using the neuralnet package. The model uses a hidden layer with 12 neurons and the logistic activation function.

## Evaluation

The model is evaluated using the following statistical indices:

Root Mean Squared Error (RMSE)
Mean Absolute Error (MAE)
Mean Absolute Percentage Error (MAPE)
Symmetric Mean Absolute Percentage Error (sMAPE)

## Results

The results include:

Plots of the time series data
Histogram and density plot
Boxplot
Autocorrelation plot
Lag plot
Predicted vs. desired output plot
Predicted vs. desired output time series plot

