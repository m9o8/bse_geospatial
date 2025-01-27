## [Paper 4](https://economics.mit.edu/sites/default/files/publications/Catastrophe_Risk_and_Settlement_Location.pdf)

library(osmdata)
library(sf)
library(spData)
library(tidyverse)
library(geodata)
library(readxl)
library(ggplot2)
library(raster)
library(terra)
library(rmapshaper)
library(ggplot2)
library(ggrepel)

path <- ("/Users/simonvellin/Documents/BSE/TERM 2/GEOSPATIAL/0. ASSIGNMENTS/HW1/PAPER 4")
outpath <- ("/Users/simonvellin/Documents/BSE/TERM 2/GEOSPATIAL/0. ASSIGNMENTS/HW1/PAPER 4")

----------------------------------------
            # DATA MINING
----------------------------------------

# We are looking for a shapefile or dataset specifically containing road network data for Vietnam.

# We inspect data from GADM:
st_layers("/Users/simonvellin/Documents/BSE/TERM 2/GEOSPATIAL/0. ASSIGNMENTS/HW1/PAPER 4/GADM-Vietnam")

# None of the layers in the file appear to contain road network data. All layers are polygons representing administrative boundaries. 

# We inspect data from Humdata:
st_layers("/Users/simonvellin/Documents/BSE/TERM 2/GEOSPATIAL/0. ASSIGNMENTS/HW1/PAPER 4/ROADS/vnm_rdsl_2015_OSM.shp")
vietnam_roads <- st_read("/Users/simonvellin/Documents/BSE/TERM 2/GEOSPATIAL/0. ASSIGNMENTS/HW1/PAPER 4/ROADS/vnm_rdsl_2015_OSM.shp")
view(vietnam_roads)

# Get all the unique values from the column 'type'
unique_values <- unique(vietnam_roads$type)
print(unique_values)

# Although the data is from 2015, whereas the paper displays roads from 2010, we decide to move forward with this data as road network.

# We inspect data from SimpleMaps:
st_layers("/Users/simonvellin/Documents/BSE/TERM 2/GEOSPATIAL/0. ASSIGNMENTS/HW1/PAPER 4/VIETNAM")

# We decide to move forward with this data as Vietnam boundary.
----------------------------------------
            # DATA LOADING
----------------------------------------

# Vietnam's road network shapefile already loaded as vietnam_roads following inspection

vietnam_map <- st_read("/Users/simonvellin/Documents/BSE/TERM 2/GEOSPATIAL/0. ASSIGNMENTS/HW1/PAPER 4/VIETNAM", layer = "vn")

----------------------------------------
            # DATA WRANGLING
----------------------------------------

# Categorise roads into group using the author's documentation (https://www.openicpsr.org/openicpsr/project/207641/version/V1/view;jsessionid=3EBB67FC7920B2090C0D74C349E99F93?path=/openicpsr/207641/fcr:versions/V1/Public-replication-files/Replication_README.pdf&type=file)
vietnam_roads <- vietnam_roads %>%
  mutate(
    road_category = case_when(
      type %in% c("motorway", "motorway_link") ~ "Freeway",
      type %in% c("trunk", "trunk_link") ~ "Dual Carriageway",
      type %in% c("secondary") ~ "Major Roads",
      type %in% c("primary", "primary_link", "secondary_link", "tertiary", "tertiary_link", "residential", "living_street") ~ "Minor Roads",
      TRUE ~ "Other Roads"
  )
)

----------------------------------------
            # PLOTTING
----------------------------------------

ggplot() +
  # Adding the map of Vietnam as the base layer, using a light grey fill like the paper
  geom_sf(data = vietnam_map, fill = "lightgrey", color = "black", linetype = "solid", size = 0.5) +
  
  # Overlaying the road network on the map.
  geom_sf(data = vietnam_roads, aes(color = road_category, linewidth = road_category), alpha = 0.8) +

  # The 'color' aesthetic differentiates road categories
  scale_color_manual(
    values = c(
      "Freeway" = "blue",               
      "Dual Carriageway" = "darkgreen", 
      "Major Roads" = "red",            
      "Minor Roads" = "orange",       
      "Other Roads" = "yellow"        
    )
  ) +
  # The 'linewidth' aesthetic adjusts line thickness based on road types for visual distinction
  scale_linewidth_manual(
    values = c(
      "Freeway" = 1.1,                # Thick line
      "Dual Carriageway" = 1.1,       # Thick line
      "Major Roads" = 0.5,            # Thin line
      "Minor Roads" = 0.5,            # Thin line
      "Other Roads" = 0.3             # Extra thin line
    )
  ) +
  labs(
    title = "Road maps of Vietnam",
    color = "Road Category",
    linewidth = "Road Category"    # Ensures the size legend matches the color legend
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),  # Removes grid lines
    axis.title = element_blank(),  # Removes axis titles
    axis.text = element_blank(),   # Removes axis text
    axis.ticks = element_blank()   # Removes axis ticks
  )

In comparaison the fourth paper map looked as follows: ![Figure 3]()