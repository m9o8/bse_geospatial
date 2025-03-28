# World Geography and Agricultural Markets Analysis

## Overview

This assignment analyzes global population distributions, airport accessibility, and agricultural markets in Africa. Using data from Natural Earth and the Porteous dataset, we explore spatial relationships between population centers, infrastructure, and economic activity.

## Part 1: World Population and Airport Accessibility

### Population Analysis

- Created global maps showing total population by country
- Analyzed population distribution patterns across continents
- Generated histograms of population ranges by continent
- Identified regional population clusters and outliers

### Airport Accessibility

- Calculated distances between populated places and nearest airports for each country
- Analyzed average airport accessibility by continent
- Created histograms showing country-level average distances to airports
- Identified regions with limited airport infrastructure

### Key Findings

- Population distribution shows distinct continental patterns with significant clustering
- Airport accessibility varies dramatically between regions
- Africa and Asia show the greatest variation in airport access distances
- Several continental outliers have extreme distances to nearest airport

## Part 2: African Agricultural Markets (Porteous Data)

### Market Distribution

- Mapped agricultural market locations across Africa
- Measured market accessibility to different transportation infrastructure
- Calculated minimum distances to coasts, roads, and airports
- Explored price-distance relationships by crop type

### Price-Distance Analysis

- Created scatter plots of average crop prices vs. distance to infrastructure
- Analyzed how transportation access affects market prices for different crops
- Identified infrastructure types with strongest price correlations
- Revealed crop-specific patterns in price-distance relationships

### Key Findings

- Markets show strong clustering in certain regions and along transportation corridors
- Distance to roads shows stronger price correlations than distance to airports
- Different crops exhibit varied price responses to infrastructure accessibility
- Some high-value crops show inverted distance-price relationships

## Methodology

- Used sf, terra, and tidyverse packages for spatial data processing
- Implemented point-to-point and point-to-line distance calculations
- Applied data visualization techniques for spatial patterns
- Conducted statistical analysis of relationship between distance and price

## File Description

- `hw2_MoritzPeistNoemiLucchiSimonVellin.Rmd`: R Markdown file containing all code and analysis
