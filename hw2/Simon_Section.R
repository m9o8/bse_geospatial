library(sf)
library(spData)
library(tidyverse)
library(readxl)
library(dplyr)

------------------------------------------------------------------------------------------------------
# Question 1 - Generate an sf POINT feature of market prices places across Africa; plot them.
------------------------------------------------------------------------------------------------------

# Data Loading

sf.world <- world
sf.roads_africa <- st_read("hw2/data/ne_10m_roads")
markets <- read_excel('hw2/data/porteous_data/1.-Price--Production--and-Population-Data/MktCoords.xlsx')

# Data Wrangling

sf.world <- st_transform(sf.world, CRS="EPSG:4326")
sf.markets <- st_as_sf(markets, coords = c('longitude', 'latitude'), crs = 'EPSG:4326')

# Plot

ggplot() +
  geom_sf(data = sf.world %>% filter(continent == "Africa"),
          fill = "antiquewhite", color = "gray70") +
  geom_sf(data = sf.markets, color = "red", size = 3, shape = 21, fill = "blue") +
  theme_minimal() +
  labs(title = "Markets in Africa",
       caption = "Source: Replication Data provided") +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(size = 10, hjust = 0.5))

------------------------------------------------------------------------------------------------------
  # Question 2 - Calculate minimum distance of each market to the (i) coast, (ii) nearest road, and (iii) nearest airport
------------------------------------------------------------------------------------------------------

# Data Loading

sf.airports <- st_read("hw2/data/ne_10m_airports")
sf.coast <- st_read("hw2/data/ne_10m_coastline")

# We isolate the African continent and its airports from our global data sets to stay efficient.
sf.africa <- sf.world %>% filter(continent == 'Africa')
sf.airports_africa <- sf.airports %>% st_filter(sf.africa)

# Data Wrangling
# st_distance() returns a matrix with one row per market and one column per coast segment.

dist_to_coast <- st_distance(sf.markets, sf.coast)
# For each market (row) take the minimum distance:
min_coast_dist <- apply(dist_to_coast, 1, min)

# (ii) Distance to Nearest Road ----------------------------------------
dist_to_roads <- st_distance(sf.markets, sf.roads_africa)
min_road_dist <- apply(dist_to_roads, 1, min)

# (iii) Distance to Nearest Airport ------------------------------------
dist_to_airports <- st_distance(sf.markets, sf.airports_africa)
min_airport_dist <- apply(dist_to_airports, 1, min)

sf.markets <- sf.markets %>%
  mutate(
    min_coast_dist   = as.numeric(min_coast_dist),   # in meters
    min_road_dist    = as.numeric(min_road_dist),      # in meters
    min_airport_dist = as.numeric(min_airport_dist)    # in meters
  )

# View the updated sf.markets object
print(sf.markets)

------------------------------------------------------------------------------------------------------
  # Question 3 - Produce 3 scatter plots relating average prices with the minimum distances
------------------------------------------------------------------------------------------------------

prices <- read_excel("hw2/data/porteous_data/4.-Outer-Loop-for-Cost-Parameter-Estimation/PriceMaster4GAMS.xlsx")
  
prices_slice <- prices[, 5:ncol(prices)]
prices <- replace(prices, prices == 0, NA) %>% mutate(av_price = rowMeans(prices_slice, na.rm = TRUE)) %>% select(mktcode, country, market, crop, av_price)
sf.marketprices <- sf.markets %>% left_join(prices, by = "mktcode")

# Scatter plot: Average Price vs. Minimum Distance to Coast
p_coast <- ggplot(sf.marketprices, aes(x = min_coast_dist, y = av_price)) +
  geom_point(color = "blue", alpha = 0.7) +
  labs(title = "Average Price vs. Distance to Coast",
       x = "Minimum Distance to Coast (meters)",
       y = "Average Price") +
  theme_minimal()

# Scatter plot: Average Price vs. Minimum Distance to Road
p_road <- ggplot(sf.marketprices, aes(x = min_road_dist, y = av_price)) +
  geom_point(color = "green", alpha = 0.7) +
  labs(title = "Average Price vs. Distance to Road",
       x = "Minimum Distance to Road (meters)",
       y = "Average Price") +
  theme_minimal()

# Scatter plot: Average Price vs. Minimum Distance to Airport
p_airport <- ggplot(sf.marketprices, aes(x = min_airport_dist, y = av_price)) +
  geom_point(color = "red", alpha = 0.7) +
  labs(title = "Average Price vs. Distance to Airport",
       x = "Minimum Distance to Airport (meters)",
       y = "Average Price") +
  theme_minimal()

# Display the plots
print(p_coast)
print(p_road)
print(p_airport)

  
  
  
    
