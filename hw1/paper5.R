## [Paper 5](https://web.stanford.edu/~memorten/ewExternalFiles/Morten_Oliveira_Brasilia.pdf)

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

path <- ("hw1/data/paper5/")
outpath <- ("/Users/simonvellin/Documents/BSE/TERM 2/GEOSPATIAL/0. ASSIGNMENTS/HW1/PAPER 5/OUTPUT")


### Data mining

# The author's replication package is accessible, so we move forward with it's code/data (https://www.openicpsr.org/openicpsr/project/183316/version/V1/view).

### Data loading

# Load the shapefile containing state boundaries for Brazil (1940 projection)
states <- st_read(file.path(path, "GIS_data/uf1940/uf1940_prj.shp"))
# Simplify the state boundaries to reduce file size while maintaining shape integrity
states_simple  <- rmapshaper::ms_simplify(states,keep=0.01,keep_shapes=TRUE)

### Data wrangling

# Define the year for the highways data
year  <- 2000

# Construct the file path for the highways shapefile dynamically based on the year
file_name = paste0("/",year,"/highways_",year,"_prj.shp")

# Load the highways shapefile for the specified year
all_highways <- st_read(file.path(path, "GIS_data/roads", file_name))
# Simplify the highways data for efficient plotting
all_highways_simple <- rmapshaper::ms_simplify(all_highways,keep=0.01,keep_shapes=TRUE)

# Load and simplify the minimum spanning tree (MST) shapefile for pie distribution
mst_pie <- st_read(file.path(path, "GIS_data/mst/mst_pie_prj.shp"))
mst_pie_simple  <- rmapshaper::ms_simplify(mst_pie,keep=0.01,keep_shapes=TRUE)

# Load and simplify MST data excluding pies for Rio region
mst_all_rio <- st_read(file.path(path, "GIS_data/mst/mst_all_rio_prj.shp"))
mst_all_rio_simple  <- rmapshaper::ms_simplify(mst_all_rio,keep=0.01,keep_shapes=TRUE)

# Load shapefile for capital cities and extract coordinates for labeling
capital_cities <- st_read(file.path(path, "GIS_data/cities/brazil_capital_cities_prj.shp"))
cities_xy <- cbind(capital_cities,st_coordinates(capital_cities))

### Plotting

# Create a plot showing MST and highway networks in Brazil
fig_1  <- ggplot() +
  # Add state boundaries as the base layer with light grey outlines
  geom_sf(data=states_simple, fill="white", color="grey90") +
  # Add the simplified MST data with a unique linetype and color
  geom_sf(data=mst_pie_simple, size=.6, linetype = "11", aes(color = "Minimum spanning tree"), show.legend = "line")   +
  # Add non-radial highways with a dashed line style
  geom_sf(data=all_highways_simple %>% filter(dm_anlys_p==1 & dm_radial==0), size=.3, linetype = "dashed", aes(color = "Non-radial highways (2000)"), show.legend = "line") +   
  # Add radial highways with a solid line style
  geom_sf(data=all_highways_simple %>% filter(dm_anlys_p==1 & dm_radial==1), size=0.6, aes(color = "Radial highways (2000)"), show.legend = "line") +
  # Minimal theme for simplicity
  theme_minimal() +
  # Overlay capital cities and label them with their names
  geom_point(data=cities_xy, aes(x=X, y=Y)) +
  geom_text_repel(data=cities_xy, aes(x=X, y=Y, label=CITY_NAME)) +
  # Add a custom legend for line types and colors
  labs(color = " ") +
  scale_color_manual(values=c("#777676","#868686","#565555"),
                     guide = guide_legend(override.aes = list(linetype = c("11", "dashed", "solid")))) +
  # Remove axis lines, ticks, and text for a clean map appearance
  theme(
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank()
  )

# Save the plot as a PDF
ggsave(file.path(outpath, "figure1_paper5_test.pdf"), fig_1, width = 8, height = 8)


In comparison the fifth paper map looked as follows: ![Figure 1]()