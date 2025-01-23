# Imports
library(sf)
library(spData)
library(tidyverse)
library(geodata)
library(readxl)

# Load data (paper: https://www.sciencedirect.com/science/article/pii/S0304387818300166#appsec1)

# Set geodata default path
geodata_path("hw1/data/paper1")

# Dams, Source:https://www.dws.gov.za/DSO/publications.aspx
# Data was only available as .KMZ and not readable by st_read so needed to be converted by:
# https://mygeodata.cloud/converter/kml-to-geojson
dams <- st_read(
  "hw1/data/paper1/Registered Dams Oct20241.geojson"
)

# Dam metadata (same source but an Excel file)
dam_met <- read_excel(
  "hw1/data/paper1/List of Registered Dams Oct2024.xlsx",
  col_types = rep("text", ncol(read_excel("hw1/data/paper1/List of Registered Dams Oct2024.xlsx")))
) %>%
  mutate(`Completion date` = na_if(as.numeric(`Completion date`), 0))

# RSA boundaries - downloaded from GDAM and temporarily stored
sa_districts_sf <- st_as_sf(gadm(country = "ZAF", level = 3))

# River data - Download elevation data for South Africa
elevation <- elevation_30s(country = "ZAF")


# Now filter dams, as done in the paper, i.e, omit missing completion date and filter for irrigation
dams <- dams %>%
  left_join(dam_met,
    by = join_by("COL52A1FC9ABE076254" == "No of dam"),
    # relationship = "many-to-many"
  ) %>%
  filter(!is.na(`Completion date`), str_detect(tolower(Purpose), "irrigation")) %>%
  distinct(across(-`geometry`), .keep_all = TRUE) # Delete the 2 duplicate cases identified


# Convert districts to terra format for raster operations
districts_vect <- vect(sa_districts_sf)

# Calculate slope from elevation
slope <- terrain(elevation, v = "slope", unit = "degrees")

# Calculate zonal statistics (mean slope) for each district
district_gradients <- terra::extract(slope, districts_vect, fun = mean, na.rm = TRUE)

# Add gradient data to districts
sa_districts_sf$gradient <- district_gradients$slope

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
