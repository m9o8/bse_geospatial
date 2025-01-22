# Imports
library(osmdata)
library(sf)
library(spData)
library(tidyverse)
library(geodata)
library(readxl)
library(ggplot2)
library(raster)
library(terra)

# Get Ethiopia districts
eth_districts_sf <- gadm(country = "ETH", level = 3, path = tempdir())
eth_districts_sf <- st_as_sf(eth_districts_sf)

# Get population data and process it for Ethiopia
ethiopia_pop <- population(2020, res = 5, path = tempdir())
ethiopia_pop <- crop(ethiopia_pop, ext(eth_districts_sf))
ethiopia_pop <- mask(ethiopia_pop, vect(eth_districts_sf))

# Convert districts to same CRS as population data if needed
eth_districts_sf <- st_transform(eth_districts_sf, crs(ethiopia_pop))

# WB data: https://microdata.worldbank.org/index.php/catalog/2053/data-dictionary
# Read in the survey data and get it in the right shape
wb_data <- read_csv("hw1/data/paper2/pub_eth_householdgeovariables_y1.csv") %>%
  group_by(ea_id) %>%
  summarise(
    LAT_DD_MOD = mean(LAT_DD_MOD, na.rm = TRUE),
    LON_DD_MOD = mean(LON_DD_MOD, na.rm = TRUE)
  )

# Transform it to GEO data and clip to Ethiopia
wb_data_geo <- st_as_sf(wb_data, coords = c("LAT_DD_MOD", "LON_DD_MOD"), crs = 4326)
wb_data_geo <- st_transform(wb_data_geo, crs(ethiopia_pop))

# Get high voltage power lines with comprehensive voltage range
ethiopia_hv_power <- opq("Ethiopia") %>%
  add_osm_feature(key = "power", value = c("line", "cable")) %>%
  add_osm_feature(key = "voltage", value = paste0(seq(66, 500, by = 1), "000")) %>%
  osmdata_sf()

# Clean and clip power lines
hv_lines_clean <- ethiopia_hv_power$osm_lines %>%
  mutate(voltage = str_extract(voltage, "\\d+")) %>%
  mutate(voltage_kv = as.numeric(voltage) / 1000) %>%
  filter(!is.na(voltage_kv)) %>%
  st_intersection(eth_districts_sf)

# Get major roads and clip to Ethiopia
ethiopia_roads <- opq("Ethiopia") %>%
  add_osm_feature(
    key = "highway",
    value = c("motorway", "trunk")
  ) %>%
  osmdata_sf()

# Clip roads to Ethiopia boundary
roads_clipped <- ethiopia_roads$osm_lines %>%
  st_intersection(eth_districts_sf)

# Calculate population density by district
districts_pop <- terra::extract(ethiopia_pop, vect(eth_districts_sf), fun = sum, na.rm = TRUE)

# Add population to districts dataset
eth_districts_sf$total_pop <- districts_pop[, 2] # The second column contains the values

# Calculate area in square kilometers
eth_districts_sf$area_km2 <- as.numeric(st_area(eth_districts_sf)) / 1000000

# Calculate density (people per km2)
eth_districts_sf$pop_density <- eth_districts_sf$total_pop / eth_districts_sf$area_km2

# Create the final plot
ggplot() +
  # Add Ethiopia districts with population density fill
  geom_sf(
    data = eth_districts_sf,
    aes(fill = pop_density),
    color = "gray50",
    linewidth = 0.1
  ) +
  # Add power lines in red
  geom_sf(
    data = hv_lines_clean,
    color = "red",
    linewidth = 0.1,
    size = 0.1
  ) +
  # Add major roads in black
  geom_sf(
    data = roads_clipped,
    color = "black",
    linewidth = 0.5,
    size = 0.2
  ) +
  # Customize the fill scale to match paper's blue shading
  scale_fill_gradientn(
    colors = c("white", "lightblue", "royalblue", "navy"),
    trans = "log",
    name = "Population\nDensity\n(people/km²)",
    labels = scales::comma
  ) +
  theme_minimal() +
  labs(
    title = "High Voltage Power Grid Network and Major Roads in Ethiopia",
    subtitle = "Showing transmission lines ≥66kV and population density by district",
    caption = "Data sources: OpenStreetMap, WorldPop 2020"
  ) +
  theme(
    legend.position = "right",
    plot.title = element_text(size = 10),
    plot.subtitle = element_text(size = 8),
    plot.caption = element_text(size = 6)
  )
