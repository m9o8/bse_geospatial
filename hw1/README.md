# Geospatial Paper Replications

## Overview

This assignment replicates geospatial visualizations from five economic research papers, demonstrating different mapping techniques and spatial data visualization approaches. Each replication illustrates how spatial relationships are used to investigate economic phenomena.

## Papers and Visualizations

### 1. Mettetal (2019): South African Dams and River Gradients

- **Visualization**: Map showing irrigation dams and river gradients across South Africa
- **Data**: South African dam registry, elevation data, administrative boundaries
- **Techniques**: Terrain analysis, gradient calculation, spatial data integration

### 2. Fried and Lagakos (2021): Ethiopian Infrastructure

- **Visualization**: High voltage power grid network and major roads in Ethiopia with population density
- **Data**: OpenStreetMap infrastructure, World Bank survey villages, population density
- **Techniques**: Network visualization, point overlay, choropleth mapping

### 3. Pellegrina and Sotelo (2021): Brazilian Population Distribution

- **Visualization**: Population shares by meso-region in Brazil for 1960 and 2010
- **Data**: Brazilian census (IBGE), administrative boundaries
- **Techniques**: Choropleth mapping, temporal comparison, spatial aggregation

### 4. Balboni (2021): Vietnam Road Networks

- **Visualization**: Road map of Vietnam with categorized road types
- **Data**: OpenStreetMap road data, administrative boundaries
- **Techniques**: Network visualization, road categorization, line symbology

### 5. Morten and Oliveira (2018): Brazilian Transport Networks

- **Visualization**: Minimum spanning tree and highway networks in Brazil
- **Data**: Brazilian highways, calculated minimum spanning tree, capital cities
- **Techniques**: Network analysis, minimum spanning tree, line symbology

## Methodology

For each paper, we:

1. Sourced equivalent or updated data from public repositories
2. Processed and prepared spatial data in R
3. Created visualizations that match the original paper figures
4. Documented challenges and approaches for each replication

## File Description

- `submission_notebook.Rmd`: R Markdown file containing code and visualizations for all five paper replications
