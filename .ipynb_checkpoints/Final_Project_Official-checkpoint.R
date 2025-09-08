# R CODE
# ===============================
# LOAD REQUIRED LIBRARIES
# ===============================
library(tidyverse)  # For data wrangling and visualization
library(lubridate)  # For date formatting and handling
library(ggplot2)    # For plots
library(caret)      # For modeling tools
library(cluster)    # (Loaded for clustering - unused here)
library(forecast)   # (Loaded for time series - unused here)
# library(factoextra) # Uncomment if you want to use fviz_cluster()

# ===============================
# IMPORT AND EXPLORE DATA
# ===============================
# Read vehicle listing data
car_prices <- read.csv("C:\\Users\\hunte\\OneDrive\\MBA\\Spring Term 2\\Business Analytics for Decisions\\Team Project\\car_prices.csv", fileEncoding = "UTF-8")
str(car_prices)
head(car_prices)

# ===============================
# DATA CLEANING: MAKE COLUMN
# ===============================
# Check make column for inconsistent capitalization
table(car_prices$make)

# Standardize capitalization in the make column
# Table data shows titled and lowercase duplicates
car_prices <- car_prices %>%
  mutate(make = str_to_title(make))

# Confirm changes
table(car_prices$make)

# ===============================
# FILTER FOR TOYOTA VEHICLES & CLEAN
# ===============================
# Subset Toyota vehicles, parse sale date, and drop any missing values
toyota_data <- car_prices %>%
  filter(make == "Toyota") %>%
  mutate(saledate = mdy_hms(saledate, quiet = TRUE)) %>%
  drop_na()

# Confirm structure
str(toyota_data)

# Verify: Any missing values or duplicates?
# No duplicates
colSums(is.na(toyota_data))
sum(duplicated(toyota_data))

# ===============================
# VALIDATION: CATCH MISSPELLINGS OR DUPLICATES
# ===============================
# Check unique values for inconsistencies
sort(unique(toyota_data$make))
sort(unique(toyota_data$model))
sort(unique(toyota_data$trim))
sort(unique(toyota_data$body))
sort(unique(toyota_data$state))

# ===============================
# FILTER FOR U.S. STATES ONLY
# CANADIAN CODES PRESENT
# ===============================
# Remove Canadian provinces using known U.S. state codes
us_states <- c(
  "al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl", "ga", "hi", "id", "il", "in", "ia", "ks", "ky", "la", "me", "md",
  "ma", "mi", "mn", "ms", "mo", "mt", "ne", "nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok", "or", "pa", "ri", "sc",
  "sd", "tn", "tx", "ut", "vt", "va", "wa", "wv", "wi", "wy"
)
toyota_data <- toyota_data %>%
  filter(state %in% us_states)

# Confirm updated list of states
sort(unique(toyota_data$state))

# ===============================
# STANDARDIZE TEXT COLUMNS
# ===============================
# CSV isnt showing an issue in body column but im getting lower case - upper case issues in R
# Clean body column (remove leading/trailing whitespace and title case)
toyota_data$body <- str_to_title(str_trim(toyota_data$body))
sort(unique(toyota_data$body))

# Clean model column (same as above)
toyota_data$model <- str_to_title(str_trim(toyota_data$model))
sort(unique(toyota_data$model))

# ===============================
# VISUALIZATION 1: AVERAGE SELLING PRICE BY STATE
# ===============================
# Check sample size per state — some like AL/OK/NM may skew average
toyota_data %>% count(state) %>% arrange(desc(n))

avg_price_state <- toyota_data %>%
  group_by(state) %>%
  summarise(avg_price = mean(sellingprice, na.rm = TRUE))

# Only include states with at least 30 listings
filtered_avg_price <- toyota_data %>%
  group_by(state) %>%
  filter(n() >= 30) %>%
  summarise(avg_price = mean(sellingprice, na.rm = TRUE))

# Plot
ggplot(filtered_avg_price, aes(x = reorder(state, avg_price), y = avg_price)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Average Toyota Selling Price by State",
       x = "State",
       y = "Average Price ($)") +
  theme_minimal()

# ===============================
# VISUALIZATION 2: TOP 10 TOYOTA MODELS SOLD
# ===============================
# Count all model appearances; Verify skews
toyota_data %>% count(model) %>% arrange(desc(n))

# Get top 10 models
top_models <- toyota_data %>%
  count(model, sort = TRUE) %>%
  top_n(10, n)

# Plot
ggplot(top_models, aes(x = reorder(model, n), y = n)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(title = "Top 10 Most Sold Toyota Models",
       x = "Model",
       y = "Number of Listings") +
  theme_minimal()

# ===============================
# VISUALIZATION 3: LISTINGS BY BODY TYPE
# ===============================
# Count by body type; verify skews
toyota_data %>% count(body) %>% arrange(desc(n))

# Get counts
toyota_bodytype_counts <- toyota_data %>%
  count(body, sort = TRUE)

# Plot
ggplot(toyota_bodytype_counts, aes(x = reorder(body, n), y = n)) +
  geom_col(fill = "purple") +
  coord_flip() +
  labs(title = "Toyota Listings by Body Type",
       x = "Body Type",
       y = "Number of Listings") +
  theme_minimal()

# ===============================
# VISUALIZATION 4: SELLING PRICE VS ODOMETER
# ===============================
# Preview extreme odometer values
toyota_data %>%
  arrange(desc(odometer)) %>%
  select(model, odometer, sellingprice) %>%
  head(20)

# Summary stats to assess reasonable cutoff
summary(toyota_data$odometer)

# Filter for vehicles with ≤ 300,000 miles (removes extreme outliers)
# this is still being generous, 3x over the 75th percentile
filtered_price_mileage <- toyota_data %>%
  filter(odometer <= 300000)

# Scatter plot with linear trend line
ggplot(filtered_price_mileage, aes(x = odometer, y = sellingprice)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Selling Price vs. Odometer (Toyota, ≤ 300,000 miles)",
       x = "Odometer (miles)",
       y = "Selling Price ($)") +
  theme_minimal()

# ===============================
# VISUALIZATION 5: SELLING PRICE OVER TIME
# ===============================
# Examine how many listings per month
month_skew <- toyota_data %>%
  mutate(month = floor_date(saledate, "month")) %>%
  count(month) %>%
  arrange(n)

# month_skew # See which months have small samples
# Extreme drops from low samples make wild swings in data
# You can check by replacing reliable_months with toyota_data

# Filter to keep months with 500+ listings to avoid noise
reliable_months <- toyota_data %>%
  mutate(month = as.Date(floor_date(saledate, "month"))) %>%
  group_by(month) %>%
  filter(n() >= 500) %>%
  summarise(avg_price = mean(sellingprice, na.rm = TRUE))

# Plot trend of average price over time
ggplot(reliable_months, aes(x = month, y = avg_price)) +
  geom_line(linewidth = 1) +
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 month") +
  labs(title = "Avg Toyota Selling Price Over Time (500+ Listings)",
       x = "Month",
       y = "Average Selling Price ($)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Condition Distribution
ggplot(toyota_data, aes(x = condition)) +
  geom_bar() +
  labs(title = "Distribution of Vehicle Conditions",
       x = "Condition",
       y = "Count") +
  theme_minimal()

# Price Distribution by Body Type
ggplot(toyota_data, aes(x = body, y = sellingprice)) +
  geom_boxplot() +
  coord_flip() +
  labs(title = "Price Distribution by Body Type",
       x = "Body Type",
       y = "Selling Price ($)") +
  theme_minimal()

# ===============================
# GDP MERGE + REGRESSION MODELING
# ===============================
# Load GDP dataset
state_gdp <- read.csv("Downloads/GDP summary state annual 2014 -2015 rev1.csv")
str(state_gdp)
head(state_gdp)

# Preview economic variables available
unique(state_gdp$description)

# Use "Real GDP (chained 2017 dollars)" as the chosen economic indicator
gdp_filtered <- state_gdp %>%
  filter(description == " Real GDP (millions of chained 2017 dollars) 1/") %>%
  select(state, gdp_2015 = X2015)

# Merge GDP values into the main Toyota data
toyota_gdp_merge <- toyota_data %>%
  left_join(gdp_filtered, by = "state")

# Confirm GDP merged successfully
summary(toyota_gdp_merge$gdp_2015)
str(toyota_gdp_merge)
head(toyota_gdp_merge)
sum(is.na(toyota_gdp_merge$gdp_2015))

# Build linear regression model to understand price drivers
model <- lm(sellingprice ~ year + odometer + condition + gdp_2015, data = toyota_gdp_merge)

# View regression results
summary(model)

# ===============================
# TIME SERIES FORECASTING: 12-MONTH OUTLOOK
# ===============================
# Step 1: Prepare monthly average price data
monthly_avg_price <- toyota_data %>%
  mutate(month = floor_date(saledate, "month")) %>%
  group_by(month) %>%
  summarise(avg_price = mean(sellingprice, na.rm = TRUE)) %>%
  arrange(month)

# Step 2: Convert to time series object
price_ts <- ts(
  monthly_avg_price$avg_price,
  start = c(year(min(monthly_avg_price$month)), month(min(monthly_avg_price$month))),
  frequency = 12
)

# Step 3: Fit ARIMA model
fit_arima <- auto.arima(price_ts)

# Step 4: Forecast for the next 12 months
forecast_12mo <- forecast(fit_arima, h = 12)

# Step 5: Plot the forecast
autoplot(forecast_12mo) +
  labs(title = "12-Month Forecast of Average Toyota Selling Prices",
       x = "Year",
       y = "Average Selling Price ($)") +
  theme_minimal()

summary(fit_arima)

# ===============================
# CLUSTERING DATA
# ===============================
clustering_data <- toyota_data %>%
  select(year, odometer, sellingprice) %>%
  drop_na() %>%
  scale()

set.seed(123)
k_clusters <- kmeans(clustering_data, centers = 3, nstart = 25)

toyota_data$cluster <- as.factor(k_clusters$cluster)

# If 'factoextra' is installed, you can visualize clusters with fviz_cluster:
# fviz_cluster(k_clusters, data = clustering_data, geom = "point", ellipse.type = "norm", palette = "jco",
#              ggtheme = theme_minimal()) + labs(title = "K-Means Clustering of Toyota Listings")

ggplot(toyota_data, aes(x = cluster, fill = body)) +
  geom_bar(position = "fill") +
  labs(title = "Cluster Composition by Body Type",
       x = "Cluster",
       y = "Proportion") +
  theme_minimal()
