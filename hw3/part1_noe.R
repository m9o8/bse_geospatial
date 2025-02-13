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

# Zonal statistics to compute the mean (each row is a country and each column is a date)
zonal_stats <- exact_extract(
  spei_subset,
  us_states,
  fun = "mean"
)

# Convert the wide format panel to long format panel and add state/region identifiers
# This is necessary to compute the yearly mean per country and then the yearly mean per region
spei_long <- zonal_stats %>%
  as.data.frame() %>%
  # Convert from wide to long format
  pivot_longer(
    cols = everything(),
    names_to = "time_index",
    values_to = "spei"
  ) %>%
  # Add state and region identifiers, plus temporal information
  mutate(
    state = rep(us_states$NAME, each = length(dates)),
    region = rep(us_states$REGION, each = length(dates)),
    date = rep(dates, times = nrow(us_states)),
    year = year(date),
    month = month(date)
  ) %>%
  select(state, region, year, month, spei)

# Compute the yearly mean for each state
spei_state_annual <- spei_long %>%
  group_by(state, region, year) %>%
  summarise(
    mean_spei_state = mean(spei, na.rm = TRUE),
    .groups = "drop"
  )

# Compute the yearly mean for each region
spei_regional <- spei_state_annual %>%
  group_by(region, year) %>%
  summarise(
    mean_spei_region = mean(mean_spei_state, na.rm = TRUE),
    .groups = "drop"
  )

# Plotting
ggplot(spei_regional, aes(x = year, y = mean_spei_region, color = region)) +
  geom_line() +
  geom_smooth(
    data = spei_regional, aes(x = year, y = mean_spei_region),
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
