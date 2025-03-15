## Heatmaps - static
``
`{r Heatmap static - accidents}

# Create heatmap of accidents using ggplot2

accident_heatmap <- ggplot() +

  # Add California roads as base layer

  geom_sf(data = ca_roads, color = "gray80", size = 0.1) +

  # Create density heatmap

  stat_density_2d(

    data = df.acc %>% filter(!is.na(Start_Lat) & !is.na(Start_Lng)),

    aes(x = Start_Lng, y = Start_Lat, fill = after_stat(density)),

    geom = "tile", 

    contour = FALSE,

    alpha = 0.7,

    h = 0.1,  # Bandwidth - adjust to match leaflet radius

    n = 200   # Resolution - higher values create smoother heatmap

  ) +

  # Use color scheme similar to leaflet's default heatmap

  scale_fill_gradientn(

    colors = c("#0000FF", "#00FFFF", "#00FF00", "#FFFF00", "#FF0000"),

    name = "Accident\nDensity"

  ) +

  # Set appropriate boundaries for California

  coord_sf(

    xlim = c(-124.5, -114.5),

    ylim = c(32.5, 42.5)

  ) +

  theme_minimal() +

  labs(

    title = "Accident Density Heatmap in California (2016-2021)",

    x = NULL,

    y = NULL

  ) +

  theme(

    legend.position = "right",

    plot.title = element_text(face = "bold")

  )



# Display the plot

print(accident_heatmap)



# Save the heatmap

ggsave(filename = "imgs/california_accidents_heatmap.png", 

       plot = accident_heatmap,

       width = 10, # width in inches

       height = 8, # height in inches

       dpi = 300)  # resolution

`
``

``
`{r Heatmap static - construction}

# Create heatmap of construction sites using ggplot2

construction_heatmap <- ggplot() +

  # Add California roads as base layer

  geom_sf(data = ca_roads, color = "gray80", size = 0.1) +

  # Create density heatmap

  stat_density_2d(

    data = df.const %>% filter(!is.na(Start_Lat) & !is.na(Start_Lng)),

    aes(x = Start_Lng, y = Start_Lat, fill = after_stat(density)),

    geom = "tile", 

    contour = FALSE,

    alpha = 0.7,

    h = 0.1,  # Bandwidth

    n = 200   # Resolution

  ) +

  # Use color scheme matching your leaflet construction map

  scale_fill_gradientn(

    colors = c("yellow", "orange", "red"),

    name = "Construction\nDensity"

  ) +

  # Set appropriate boundaries for California

  coord_sf(

    xlim = c(-124.5, -114.5),

    ylim = c(32.5, 42.5)

  ) +

  theme_minimal() +

  labs(

    title = "Construction Density Heatmap in California (2016-2021)",

    x = NULL,

    y = NULL

  ) +

  theme(

    legend.position = "right",

    plot.title = element_text(face = "bold")

  )



# Display the plot

print(construction_heatmap)



# Save the heatmap

ggsave(filename = "imgs/california_construction_heatmap.png", 

       plot = construction_heatmap,

       width = 10, # width in inches

       height = 8, # height in inches

       dpi = 300)  # resolution

`
``
