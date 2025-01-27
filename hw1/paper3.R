library(sf)
library(geobr)
library(tidyverse)
library(ggplot2)
library(readxl)
library(lwgeom)
library(censobr)

# Read in the Brasilian population for 2010 using the censobr package
# This also contains 1980, and 1960 data, but 1980 without weights, and 1960 only partially
pop_2010 <- read_population(
  year = 2010,
  columns = c("code_state", "code_region", "code_muni", "V0010"),
  showProgress = FALSE,
  as_data_frame = TRUE,
  # cache = FALSE
) %>% # Group by municipality code
  group_by(code_muni) %>%
  summarise(
    total_population = sum(V0010, rm.na = TRUE)
  )

# Get the geographical data from the package geobr and validate if necessary
meso <- read_meso_region(year = 2010) %>%
  st_make_valid()
region <- read_region(year = 2010)
muni <- read_municipality(year = 2010) %>%
  st_make_valid()

# First, join the population data with municipal boundaries
pop_spatial <- muni %>%
  left_join(pop_2010, by = "code_muni")

# Use st_centroid to ensure each municipality is counted only once
pop_meso <- pop_spatial %>%
  st_centroid() %>% # Convert polygons to points
  st_join(meso) %>% # Join with meso regions
  group_by(code_meso) %>%
  summarise(
    total_population = sum(total_population, na.rm = TRUE)
  ) %>%
  st_drop_geometry() # Remove geometry before joining back

# Now join back with meso geometries
pop_meso <- meso %>%
  left_join(pop_meso, by = "code_meso")

# Create pop_share
df_merged <- pop_meso %>%
  mutate(pop_share = total_population / sum(total_population) * 100)


# Aggregate regions as the author's did to get the correct boundaries
region <- region %>%
  mutate(
    name_region = case_when(
      name_region %in% c("Centro Oeste", "Norte") ~ 2,
      TRUE ~ 1
    )
  ) %>%
  dplyr::select(name_region, geom) %>%
  group_by(name_region) %>%
  summarise(geom = st_union(geom)) %>%
  sfheaders::sf_remove_holes()

# Final plot
ggplot(data = df_merged) +
  ggtitle("(c) 2010") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5), # Center title while keeping minimal theme
    panel.grid = element_line(color = "gray90"), # Make grid lines lighter
    axis.text = element_blank(),
    axis.ticks = element_blank()
  ) +
  geom_sf(aes(fill = pop_share), color = "white", size = 0.1) +
  scale_fill_stepsn(
    name = "Pop. Share",
    breaks = c(0, 0.216, 0.382, 0.557, 1.02, 11.12),
    labels = scales::number_format(accuracy = 0.001),
    colors = c("#eff3ff", "#bdd7e7", "#6baed6", "#3182bd", "#08519c"), # Made lower values darker
    values = scales::rescale(c(0, 0.216, 0.382, 0.557, 1.02, 11.12))
  ) +
  geom_sf(data = region, aes(color = factor(name_region)), fill = NA, linewidth = 1) +
  scale_color_manual(values = c("black", "red")) +
  guides(color = "none") +
  # Add titles
  labs(
    caption = "Source: Based on Pellegrina and Sotelo (2021)"
  )
