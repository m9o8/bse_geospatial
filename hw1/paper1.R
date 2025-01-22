# Imports
library(sf)
library(spData)
library(tidyverse)
library(geodata)

# Load data

# Dams
dams <- st_read("hw1/data/doc.kml") # Source:https://www.dws.gov.za/DSO/publications.aspx

# RSA boundaries - downladed from GDAM and temporarily stored
sa_districts_sf <- st_as_sf(gadm(country = "ZAF", level = 3, path = tempdir()))

# River data - Download elevation data for South Africa
elevation <- elevation_30s(country = "ZAF", path = tempdir())

# Convert districts to terra format for raster operations
districts_vect <- vect(sa_districts_sf)

# Calculate slope from elevation
slope <- terrain(elevation, v = "slope", unit = "degrees")

# Calculate zonal statistics (mean slope) for each district
district_gradients <- terra::extract(slope, districts_vect, fun = mean, na.rm = TRUE)

# Add gradient data to districts
sa_districts_sf$gradient <- district_gradients$slope

# Create plot

# Ensure same CRS
dams <- st_transform(dams, st_crs(sa_districts_sf))

# Clip dams to South Africa boundaries
sa_boundary <- st_union(sa_districts_sf)
dams_clipped <- st_intersection(dams, sa_boundary)

# Create plot
ggplot() +
  # Add districts with gradient fill
  geom_sf(
    data = sa_districts_sf,
    aes(fill = gradient),
    color = "white",
    size = 0.1
  ) +
  # Add clipped dams
  geom_sf(
    data = dams_clipped,
    size = 0.2,
    color = "black",
    aes(shape = "Dam Location")
  ) + # Add to legend
  # Style the gradient fill
  scale_fill_gradientn(
    colors = grey.colors(6, start = 0.9, end = 0.2),
    name = "Average District\nRiver Gradient",
    breaks = c(
      0, 2.229103, 3.821713, 6.593167,
      9.879707, 13.130823, 19.829017
    ),
    labels = function(x) format(x, digits = 6),
    guide = guide_colorbar(
      order = 1,
      nbin = 100, # For smoother color transition
      ticks.colour = "black",
      frame.colour = "black",
      frame.linewidth = 0.5
    )
  ) +
  # Add shape scale for dam points in legend
  scale_shape_manual(
    values = c("Dam Location" = 16),
    name = NULL,
    guide = guide_legend(order = 2)
  ) +
  # Customize theme
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 14),
    legend.position = "left",
    legend.box = "vertical",
    legend.margin = margin(0, 0, 0, 0),
    legend.spacing = unit(0.1, "cm"),
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 8),
    legend.key.size = unit(0.5, "cm")
  ) +
  # Add titles
  labs(
    title = "South African Dams and River Gradients",
    caption = "Source: Based on Mettetal (2019) but with 2024 instead of 2013 data"
  )
