rm(list = ls())
library(terra)
library(sf)
library(tidyverse)
library(exactextractr)

# Import SPEI index
spei_index <- rast("hw3/data/ex1/spei01.nc")

# Import US regions
us_states <- spData::us_states

# Get dates from SPEI dataset
dates <- time(spei_index)

# Filter only for years between 1965 and 2015
valid_dates <- which(year(dates) >= 1965 & year(dates) <= 2015)

# Extract the subset of SPEI data for our time period of interest
spei_subset <- spei_index[[valid_dates]]

# Remove from 'dates' the unnecessary dates
dates <- dates[valid_dates]

# Zonal statistics directly by region (grouping states by region first)
regions_sf <- us_states %>%
  group_by(REGION) %>%
  summarise(geometry = st_union(geometry))

# Calculate SPEI means directly for regions
zonal_stats_regional <- exact_extract(
  spei_subset,
  regions_sf,
  fun = "mean"
)

# Convert to long format with regional identifiers
spei_regional_direct <- zonal_stats_regional %>%
  as.data.frame() %>%
  mutate(region = regions_sf$REGION) %>%
  pivot_longer(
    cols = -region,
    names_to = "time_index",
    values_to = "spei"
  ) %>%
  mutate(
    date = rep(dates, times = nrow(regions_sf)),
    year = year(date)
  ) %>%
  group_by(region, year) %>%
  summarise(
    mean_spei_region = mean(spei, na.rm = TRUE),
    .groups = "drop"
  )

# Plotting
ggplot(spei_regional_direct, aes(x = year, y = mean_spei_region, color = region)) +
  geom_line() +
  geom_smooth(
    data = spei_regional_direct, aes(x = year, y = mean_spei_region),
    method = "loess", color = "blue", se = TRUE
  ) +
  scale_color_manual(values = c("red", "green", "turquoise", "purple")) +
  scale_x_continuous(
    breaks = seq(1970, 2010, by = 10),
    expand = c(0.02, 0.02)
  ) +
  scale_y_continuous(
    limits = c(-1, 1),
    breaks = seq(-1, 1, by = 1)
  ) +
  labs(
    title = "SPEI Index by US Region (1965-2015)",
    x = "Year",
    y = "SPEI Index",
    color = "Region"
  )