# Plot 2

rm(list = ls())
library(sf)
library(terra)
library(tidyverse)
library(gdistance)
library(spData)
library(raster)

# Load the geometry of Spain and filter for continental Spain only
spain <- world %>%
  filter(name_long == "Spain") %>%
  st_cast("POLYGON") %>%
  slice_max(st_area(.))

# Load populated cities and roads
places <- st_read("hw3/data/ex2/ne_10m_populated_places")
roads <- st_read("hw3/data/ex2/ne_10m_roads")

# Get top 10 most populated Spanish cities
spain_top_10_cities <- places %>%
  filter(ADM0NAME == "Spain") %>%
  arrange(desc(POP_MAX)) %>%
  slice_head(n = 10)

# Transform to planar EPSG:3035 for better distance calculation in km
spain_planar <- st_transform(spain, 3035)
roads_planar <- st_transform(roads, 3035)
cities_planar <- st_transform(spain_top_10_cities, 3035)

# Intersect roads with Spain's boundaries
spain_roads <- st_intersection(roads_planar, spain_planar)

# Create and prepare a raster on the top of Spain
raster <- rast(ext(spain_planar), resolution = 5000, crs = "EPSG:3035")
roads_vect <- vect(spain_roads)
road_raster <- rasterize(roads_vect, raster, field = 1)

# Create friction surface: we assign 100 to cells without streets and 1 with cells
# with streets. In this way we increase the friction for areas without streets, and so
# streets will be chosen when computing the distances between places.
road_values <- values(road_raster)
road_values[is.na(road_values)] <- 100
road_values[!is.na(road_values)] <- 1
values(road_raster) <- road_values

# Create transition matrix for distance calculation
tr_matrix <- transition(raster(road_raster),
  transitionFunction = mean,
  directions = 8
)

# Calculate distances between all city pairs
n_cities <- nrow(cities_planar)
dist_matrix <- matrix(0, n_cities, n_cities)
rownames(dist_matrix) <- cities_planar$NAME
colnames(dist_matrix) <- cities_planar$NAME

for (i in 1:n_cities) {
  for (j in 1:n_cities) {
    if (i < j) {
      path <- shortestPath(tr_matrix,
        origin = as_Spatial(cities_planar[i, ]),
        goal = as_Spatial(cities_planar[j, ]),
        output = "SpatialLines"
      )
      path_sf <- st_as_sf(path)
      st_crs(path_sf) <- st_crs(cities_planar)
      # Calculate distance in kilometers
      dist <- as.numeric(st_length(path_sf)) / 1000
      dist_matrix[i, j] <- dist
      dist_matrix[j, i] <- dist
    }
  }
}

# Print the distances
print("Distances between cities (km):")
print(round(dist_matrix, 1))

# Filter Madrid and Vigo for the plot
madrid_vigo <- spain_top_10_cities %>%
  filter(NAME %in% c("Madrid", "Vigo"))

# Plotting
ggplot() +
  geom_sf(data = st_transform(spain, 4326), fill = "lightgray") +
  geom_sf(data = st_transform(spain_roads, 4326), color = "black", size = 0.3) +
  geom_sf(data = st_transform(spain_top_10_cities, 4326), size = 1, color = "black") +
  geom_sf(
    data = st_transform(madrid_vigo %>% filter(NAME == "Madrid"), 4326),
    aes(shape = "Madrid", color = "Madrid"), size = 3
  ) +
  geom_sf(
    data = st_transform(madrid_vigo %>% filter(NAME == "Vigo"), 4326),
    aes(shape = "Vigo", color = "Vigo"), size = 3
  ) +
  scale_color_manual(
    name = "Cities",
    values = c("Madrid" = "red", "Vigo" = "turquoise")
  ) +
  scale_shape_manual(
    name = "Cities",
    values = c("Madrid" = 16, "Vigo" = 17)
  )
