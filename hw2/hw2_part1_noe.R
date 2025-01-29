rm(list=ls())
library(sf) 
library(spData) 
library(tidyverse) 
library(tidyr)
library(dplyr)

sf.airports <- st_read('/Users/noemilucchi/Desktop/Term2/Geospatial/ne_10m_airports')
sf.ports<- st_read('/Users/noemilucchi/Desktop/Term2/Geospatial/ne_10m_ports')
sf.pop <- st_read('/Users/noemilucchi/Desktop/Term2/Geospatial/ne_10m_populated_places_simple')
world <- world 
  
# 1- TOTAL POPULATION BY COUNTRY 
# 1.1 Coloring the whole country depending on the population, using only the package
# spData that has both the geometry of every country and the population 

# Population in absolute terms 
ggplot() +
  geom_sf(data = world, aes(fill=pop)) + 
  scale_fill_gradient(name = "Population", low = "lightblue",  high = "blue") 

# Population by categories 
world <- world %>%
  mutate(pop_category = case_when(
    pop <= quantile(pop, 0.30, na.rm = TRUE) ~ "Low",
    pop <= quantile(pop, 0.70, na.rm = TRUE) ~ "Medium",
    TRUE ~ "High"))

ggplot() +
  geom_sf(data = world, aes(fill = pop_category), alpha = 0.7) +  
  scale_fill_manual(name = "Population Category", 
                    values = c("Low" = "lightyellow", "Medium" = "lightgreen", "High" = "blue"))


# 1.2 Using centroids: coloring cities instead of the whole country - still 
# using colors depending on the population. Used the sf.pop from Natural Earth website.

# Population in absolute term 
ggplot() +
  geom_sf(data = world) +  
  geom_sf(data = sf.pop, aes(size = pop_max, color = pop_max), alpha = 0.7) + 
  scale_size_continuous(name = "Population", range = c(0.5, 3), guide = "none") + 
  scale_color_gradient(name = "Population", low = "lightblue", high = "blue")

# Population by categories 
sf.pop <- sf.pop %>%
  mutate(pop_category = case_when(
    pop_max <= quantile(pop_max, 0.30, na.rm = TRUE) ~ "Low",
    pop_max <= quantile(pop_max, 0.70, na.rm = TRUE) ~ "Medium",
    TRUE ~ "High"))

ggplot() +
  geom_sf(data = world) +  
  geom_sf(data = sf.pop, aes(size = pop_max, color = pop_category), alpha = 0.7) + 
  scale_size_continuous(name = "Population", range = c(0.5, 5), guide = "none") + 
  scale_color_manual(
    name = "Population Category",  # Nome della legenda
    values = c("Low" = "lightyellow", "Medium" = "lightgreen", "High" = "blue"))


# 2 - HISTOGRAM OF COUNTRY POPULATION DISTRIBUTION BY CONTINENT 
# Group South America and North America in America and remove Seven seas and Antarctica
# because they are NA 
world <- world %>%
  mutate(
    continent = case_when(
      continent %in% c("South America", "North America") ~ "America",  
      continent %in% c("Seven seas (open ocean)", "Antarctica") ~ NA_character_,
      TRUE ~ continent)) %>% filter(!is.na(continent))

# Create the population ranges 
world <- world %>%
  mutate(pop_range = case_when(
    pop < 1e7 ~ "0-10M",
    pop < 5e7 ~ "10M-50M",
    pop < 1e8 ~ "50M-100M",
    pop < 5e8 ~ "100M-500M",
    TRUE ~ "500M+"))

# Calculate the number of countries per range + country
population_distribution <- world %>%
  group_by(continent, pop_range) %>%
  summarise(country_count = n(), .groups = "drop")

# Order by ranges 
population_distribution <- population_distribution %>%
  mutate(pop_range = factor(pop_range, levels = c("0-10M", "10M-50M", "50M-100M", "100M-500M", "500M+")))

ggplot(population_distribution, aes(x = pop_range, y = country_count, fill = continent)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Country Population Distribution by Continent", x = "Population Range",
    y = "Number of Countries", fill = "Continent")

# 3 - HISTOGRAM OF (CONTRY LEVEL) AVERAGE DISTANCES BETWEEN LOCATIONS AND
# PORTS OR AIRPORTS BY CONTINENT 
country_list <- unique(sf.pop$sov0name)
st_intersection(sf.pop, sf.airports)
