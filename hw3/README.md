# Climate and Transportation Centrality Analysis

## Overview

This assignment examines climate patterns across US regions and analyzes transportation centrality in Spain through two comprehensive exercises. The analysis demonstrates techniques for working with raster data, conducting spatial averaging, and calculating network distances.

## Exercise 1: Climate Change in the USA

### Data and Approach

- Analyzed SPEI (Standardized Precipitation Evapotranspiration Index) data for 1965-2015
- Used US Census regions (Northeast, Midwest, South, West) for spatial aggregation
- Compared two methodological approaches:
  1. State-to-region aggregation (mean-of-means approach)
  2. Direct regional calculation (spatially weighted approach)

### Key Findings

- Identified regional climate trends across US geographical divisions
- Compared volatility patterns in drought conditions by region
- Demonstrated methodological implications of different spatial aggregation approaches
- Visualized long-term climate patterns through advanced time series smoothing

### Methodological Insights

- Direct regional calculation provides more accurate representation of climate patterns
- State-to-region aggregation can introduce biases by giving equal weight to differently sized states
- Spatial averaging methods significantly impact interpretation of climate trend data

## Exercise 2: Transportation Centrality in Spain

### Part A: Road Network Analysis

- Identified top 10 most populated cities in Spain
- Created spatial representation of Spanish road network
- Calculated shortest-path distances between major population centers
- Generated distance matrix showing connectivity between cities

### Part B: City Isolation Analysis

- Focused on Madrid and Vigo as case studies
- Analyzed bilateral distances to other major Spanish cities
- Created density plots to visualize distance distributions
- Conducted quantitative comparison of city isolation

### Key Findings

- Calculated comprehensive distance matrix between Spain's most populated cities
- Demonstrated that Vigo is significantly more isolated than Madrid
- Visualized isolation through density distributions of intercity distances
- Showed impact of methodological choices (e.g., including self-distances) on analysis results

## Methodology

- Used raster-based approaches for climate data analysis
- Employed friction surfaces and transition matrices for road distance calculations
- Applied kernel density estimation for visualizing distance distributions
- Implemented spatial averaging techniques for climate data aggregation

## File Description

- `hw3_MoritzPeistNoemiLucchiSimonVellin.Rmd`: R Markdown file containing all code and analysis
