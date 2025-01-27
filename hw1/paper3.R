library(sf)
library(geobr)
library(dplyr)
library(ggplot2)
library(readxl)
library(tidyr)
library(lwgeom)

# Read the .xls file with the Brasilian population for 2009
df <- read_excel("hw1/data/paper3/UF_Municipio.xls", skip = 4, col_names = TRUE)

# Get the geographical data from the package geobr
state <- read_state(year = 2010)
meso <- read_meso_region(year = 2010)
region <- read_region(year = 2010)

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

# Remove the last row of df_merged - in df the last row was the total
# and it would have been considered another meso region
df_grouped <- df_grouped %>%
  slice(-n())

# Merge the geographical data with the population data
df_merged <- state %>%
  left_join(df_grouped, by = c("code_state" = "COD...2"))

# Create the column pop_share
df_merged <- df_merged %>%
  mutate(pop_share = Total_Estimada / sum(Total_Estimada) * 100)

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
  geom_sf(aes(fill = pop_share), color = "white") +
  scale_fill_gradientn(
    colors = c("lightblue", "blue", "darkblue"),
    name = "Pop. Share",
    limits = c(0, 25)
  ) +
  geom_sf(data = region, aes(color = factor(name_region)), fill = NA, linewidth = 1) +
  scale_color_manual(values = c("black", "red")) +
  guides(color = "none")
