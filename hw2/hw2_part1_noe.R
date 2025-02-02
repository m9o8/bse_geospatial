rm(list = ls())
library(sf)
library(spData)
library(tidyverse)
library(units)

sf.airports <- st_read("hw2/data/ne_10m_airports", crs = 4326)
sf.pop <- st_read("hw2/data/ne_10m_populated_places_simple", crs = 4326)
world <- world

# 1- TOTAL POPULATION BY COUNTRY: Using only the package spData that has both the 
# geometry of every country and the population

# 1.1 Plotting population in absolute terms
ggplot() +
  geom_sf(data = world, aes(fill = pop)) +
  scale_fill_gradient(name = "Population", low = "lightblue", high = "blue")

# 1.2 Defining population by categories
world <- world %>%
  mutate(pop_category = case_when(
    pop <= quantile(pop, 0.30, na.rm = TRUE) ~ "Low",
    pop <= quantile(pop, 0.70, na.rm = TRUE) ~ "Medium",
    TRUE ~ "High"
  ))

# Plotting
ggplot() +
  geom_sf(data = world, aes(fill = pop_category), alpha = 0.7) +
  scale_fill_manual(
    name = "Population Category",
    values = c("Low" = "lightyellow", "Medium" = "lightgreen", "High" = "blue"))


# 2 - HISTOGRAM OF COUNTRY POPULATION DISTRIBUTION BY CONTINENT
# Group South America and North America in America and remove Seven seas and Antarctica
# because they are NA
world <- world %>%
  mutate(
    continent = case_when(
      continent %in% c("South America", "North America") ~ "America",
      continent %in% c("Seven seas (open ocean)", "Antarctica") ~ NA_character_,
      TRUE ~ continent
    )
  ) %>%
  filter(!is.na(continent))

# Create the population ranges
world <- world %>%
  mutate(pop_range = case_when(
    pop < 1e7 ~ "0-10M",
    pop < 5e7 ~ "10M-50M",
    pop < 1e8 ~ "50M-100M",
    pop < 5e8 ~ "100M-500M",
    TRUE ~ "500M+"
  ))

# Calculate the number of countries per range + country
population_distribution <- world %>%
  group_by(continent, pop_range) %>%
  summarise(country_count = n(), .groups = "drop")

# Order by ranges
population_distribution <- population_distribution %>%
  mutate(pop_range = factor(pop_range, levels = c("0-10M", "10M-50M", "50M-100M", "100M-500M", "500M+")))

# Plotting
ggplot(population_distribution, aes(x = pop_range, y = country_count, fill = continent)) +
  geom_histogram(stat = "identity", position = "dodge") +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Country Population Distribution by Continent", x = "Population Range",
    y = "Number of Countries", fill = "Continent")


# 3 - HISTOGRAM OF (CONTRY LEVEL) AVERAGE DISTANCES BETWEEN LOCATIONS AND
# PORTS OR AIRPORTS BY CONTINENT

# Assuming we have the initial dataframes stored locally

# Take the world, join airports, then cities, then group by and calculate distance
# Problem is: One sf object can only contain 1 geometry at the time
# Therefore, we create two distinct dataframes and then calculate the distances between both

# 3.1
# 1. Prepare cities and airports with country metadata
cities_with_countries <- world %>%
  st_drop_geometry() %>%
  select(iso_a2, continent) %>%
  left_join(
    sf.pop %>% select(name, iso_a2, ne_id, geometry),
    by = "iso_a2"
  ) %>%
  st_as_sf() %>%
  drop_na()

airports_with_countries <- sf.airports %>%
  select(name, geometry) %>%
  st_join(world %>% select(iso_a2, continent))

# 2. Calculate closest airport distance per city, then average per country
distances <- cities_with_countries %>%
  # For each country group:
  group_by(continent, iso_a2, ne_id) %>%
  summarise(
    avg_closest_distance_km = {
      current_iso <- cur_group()$iso_a2 # Capture current country code
      country_airports <- airports_with_countries %>%
        filter(iso_a2 == current_iso) # Filter airports for this country

      if (nrow(country_airports) == 0) {
        NA_real_ # Return NA if no airports exist
      } else {
        # Compute closest airport distance for each city in the country
        closest_distances <- st_distance(
          geometry, # City geometries
          country_airports # Airports in the current country
        ) %>%
          apply(1, min) %>% # Find minimum distance per city (row)
          as.numeric() / 1000 # Convert meters to kilometers

        mean(closest_distances, na.rm = TRUE)
      }
    }
  ) %>%
  ungroup() %>%
  drop_na() # Remove countries with no airports

# Plot histograms by continent
ggplot(distances, aes(x = avg_closest_distance_km, fill = continent)) +
  geom_histogram(bins = 30, position = "dodge") +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Average Distance Between Locations and Airports by Continent",
    x = "Average Distance to nearest Airport (km)", y = "Number of Populated Places", fill = "Continent"
  ) +
  facet_wrap(~continent, scales = "free")


# 3.2
# 1. The datasets cities_with_countries and airports_with_countries remain unchanged

# 2. Calculate average distances at country level. With this approach, instead of 
# computing the closest airport distance per city and then averaging per country, 
# we compute all the distances within a country and then we average them. 
distances_country <- cities_with_countries %>%
  group_by(continent, iso_a2) %>%  # Removed ne_id to group at country level
  summarise(
    avg_closest_distance_km = {
      current_iso <- cur_group()$iso_a2
      country_airports <- airports_with_countries %>%
        filter(iso_a2 == current_iso)
      if (nrow(country_airports) == 0) {
        NA_real_
      } else {
        closest_distances <- st_distance(
          geometry,
          country_airports
        ) %>%
          apply(1, min) %>%
          as.numeric() / 1000
        mean(closest_distances, na.rm = TRUE)}},
    country_name = first(name)) %>%  ungroup() %>%  drop_na()

# 3. Create distance ranges – The previous step ensures a reasonable number of ranges. 
# If we had used the distances computed earlier, the higher granularity would have resulted 
# in an excessive number of ranges, leading to a poor visualization quality.
distances_ranges <- distances_country %>%
  mutate(distance_range = cut(avg_closest_distance_km,
      breaks = seq(0, max(avg_closest_distance_km, na.rm = TRUE) + 50, by = 50),
      labels = paste0("<", seq(50, max(avg_closest_distance_km, na.rm = TRUE) + 50, by = 50), "km"),
      include.lowest = TRUE))

# 4. Plot the distribution of the average distances by ranges 
ggplot(distances_ranges, aes(x = distance_range, fill = continent)) +
  geom_bar(position = "stack") +
  scale_fill_brewer(palette = "Set2") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Average Distance Between Locations and Airport by Ranges",
    x = "Average Distance in Ranges", y = "Number of Countries", fill = "Continent")

###################### Helper ##############################

# Find difference of sets from two dataframe columns (to check which countries were dropped)
setdiff <- function(x, y) {
  x[!x %in% y]
}

setdiff(world$iso_a2, distances$iso_a2)
