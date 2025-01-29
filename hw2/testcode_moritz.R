library(rnaturalearth)
library(sf)

# Get Natural Earth data with population attributes
world <- ne_countries(scale = "medium", returnclass = "sf")