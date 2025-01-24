# Clean working directory and import necessary packages 
rm(list = ls())
library(sf)
library(geobr)
library(dplyr)
library(ggplot2)
library(readxl)
library(tidyr)

# Read the .xls file with the Brasilian population for 2009  
df <- read_excel("data/paper3/UF_Municipio.xls", skip = 4, col_names = TRUE)
df

# Get the geographical data from the package geobr
state <- read_state(year=2010)
meso <- read_meso_region(year=2010)
state
meso

# Convert ESTIMADA (=population) into a numerical variable and handle missing values 
# by setting them to 0
df <- df %>%
  mutate(ESTIMADA = as.numeric(ESTIMADA)) %>%
  mutate(ESTIMADA = replace_na(ESTIMADA, 0))

# Group by the country code 
df_grouped <- df %>% 
  group_by(COD...2) %>%
  summarise(
    Total_Estimada = sum(ESTIMADA, na.rm = TRUE),  
    Count = n()  
)

# Merge the 'meso' data with the population data 
df_merged <- meso %>%
  left_join(df_grouped, by = c("code_state" = "COD...2"))

# Merge the resulting df with the 'state' data to get the orientation 
df_merged <- df_merged %>%
  st_join(state)

# Create the column pop_share
df_merged <- df_merged %>%
mutate(pop_share = Total_Estimada / sum(Total_Estimada)) 

# Filter for North and Central-West regions
regions_to_highlight <- df_merged %>%
  filter(name_region %in% c("Centro Oeste", "Norte"))

# Join the geometries of these regions in a polygon - for better 
# visualization of the red line we will plot
regions_union <- regions_to_highlight %>%
  st_union() %>%  
  st_as_sf()      

# Final plot  
ggplot(data = df_merged) +
  geom_sf(aes(fill = pop_share), color = "white") +  
  scale_fill_distiller(palette = "Blues", name = "Pop. Share") +  
  geom_sf(data = regions_union, fill = NA, color = "red", size = 1.5)

# Adjusting the scale of colors 
ggplot(data = df_merged) +
  geom_sf(aes(fill = pop_share), color = "white") +
  scale_fill_gradientn(colors = c("lightblue", "blue", "darkblue"), name = "Pop. Share") +
  geom_sf(data = regions_union, fill = NA, color = "red", size = 1.5)


df_merged
