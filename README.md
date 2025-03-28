# BSE Geospatial Data Science Repository

This repository contains projects and assignments completed for the Geospatial Data Science course at Barcelona School of Economics (BSE) during the 2024-2025 academic year. The work demonstrates various spatial analysis techniques, visualization methods, and applications of geospatial data in economic research.

## Authors

- **Moritz Peist**: [moritz.peist@bse.eu](mailto:moritz.peist@bse.eu)
- **Noemi Lucchi**: [noemi.lucchi@bse.eu](mailto:noemi.lucchi@bse.eu)
- **Simon Vellin**: [simon.vellin@bse.eu](mailto:simon.vellin@bse.eu)

## Final Project: California Road Construction Safety Analysis

Our final project investigates the causal relationship between road construction activities and traffic accident rates in California using high-resolution spatial data from 2021. We implement a difference-in-differences framework with spatial controls to analyze how construction zones affect accident frequency and severity, with a focus on heterogeneous effects across urban and rural environments.

### Key Findings

- Construction activities significantly impact accident rates, with effects varying substantially between urban and rural environments
- Spatial spillover analysis reveals accident impacts extend beyond immediate construction zones
- Effects are most pronounced in transition zones 500m-2km from construction sites
- Despite influencing accident frequency, construction does not substantially alter the severity distribution of accidents

### Methodology

- Created spatial buffers around construction sites to establish treatment areas
- Employed difference-in-differences approach with fixed effects for location and time
- Calculated spatial spillover effects using distance bands
- Implemented spatial lag models to account for spatial autocorrelation

### Sample Visualizations

![California Accident Heatmap](/final/imgs/ConstrutionHeatmap.png)
*Heatmap showing the density of construction sites across California in 2021*

![Spillover Effects by Distance](/final/imgs/TEConstruction.png)
*Treatment effects on accident rates by distance from construction zones*

## Assignment 1: Replication of Geospatial Visualizations

This assignment focused on replicating geospatial visualizations from five different economic research papers. Each replication demonstrates different spatial data visualization techniques and approaches.

### Papers Replicated

1. **Mettetal (2019)**: South African dams and river gradients
2. **Fried and Lagakos (2021)**: High voltage power grid network and roads in Ethiopia
3. **Pellegrina and Sotelo (2021)**: Population distribution in Brazil
4. **Balboni (2021)**: Road networks in Vietnam
5. **Morten and Oliveira (2018)**: Minimum spanning tree and highway networks in Brazil

### Sample Visualization

![Ethiopian Power Grid and Roads](/hw1/imgs/grid.png)
*High Voltage Power Grid Network and Major Roads in Ethiopia*

## Assignment 2: World Geography and Airport Accessibility

This assignment analyzed global population distributions and airport accessibility across continents, combining various data sources from Natural Earth. The second part explored agricultural market data in Africa using the Porteous dataset.

### Key Components

- Analysis of total population distribution by country
- Calculation of average distances between populated locations and airports
- Visualization of agricultural markets in Africa and their accessibility to transportation infrastructure
- Analysis of the relationship between market prices and distances to infrastructure

### Sample Visualization

![Markets in Africa](/hw2/imgs/markets.png)
*Distribution of agricultural markets across Africa*

## Assignment 3: Climate and Transportation Analysis

This assignment examined climate trends across US regions and transportation centrality in Spain through two main exercises.

### Exercise 1: Climate Change in the USA

- Analyzed SPEI (Standardized Precipitation Evapotranspiration Index) trends across US regions over 50 years
- Compared methodological approaches for spatial averaging of climate data
- Visualized regional climate patterns and long-term trends

### Exercise 2: Transportation Centrality in Spain

- Calculated distances between the 10 most populated cities in Spain
- Analyzed the isolation of Madrid and Vigo through density distributions of distances
- Created visualizations of the Spanish road network and city interconnectivity

### Sample Visualization

![Spain Transportation Network](/hw3/imgs/spain_roads.png)
*Road network of continental Spain with major population centers*

## Repository Structure

```
📦 bse_geospatial
 ┣ 📂 final
 ┃ ┗ 📜 final_MoritzPeistNoemiLucchiSimonVellin.Rmd
 ┃ ┗ 📂 data
 ┃ ┗ 📂 imgs
 ┣ 📂 hw1
 ┃ ┗ 📜 submission_notebook.Rmd
 ┃ ┗ 📂 data
 ┃ ┗ 📂 imgs
 ┣ 📂 hw2
 ┃ ┗ 📜 hw2_MoritzPeistNoemiLucchiSimonVellin.Rmd
 ┃ ┗ 📂 data
 ┃ ┗ 📂 imgs
 ┣ 📂 hw3
 ┃ ┗ 📜 hw3_MoritzPeistNoemiLucchiSimonVellin.Rmd
 ┃ ┗ 📂 data
 ┃ ┗ 📂 imgs
 ┗ 📜 README.md
```

## Technologies Used

- **R**: Primary programming language
- **R Packages**:
  - **sf**: Simple features for spatial vector data
  - **terra**: Raster data handling
  - **tidyverse**: Data manipulation and visualization
  - **fixest**: Fixed-effects models
  - **spdep**: Spatial weights and tests
  - **splm**: Spatial panel models
  - **leaflet**: Interactive maps
  - **exactextractr**: Precise spatial averaging
  - **gdistance**: Compute minimum distances on raster surfaces
  
## Course Information

- **Course**: Geospatial Data Science and Economic Spatial Models
- **Institution**: Barcelona School of Economics
- **Instructor**: Bruno Conte
- **Term**: January-March 2025
