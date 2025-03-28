# California Road Construction Safety Analysis

## Overview

This project investigates the causal relationship between road construction activities and traffic accident rates in California using comprehensive spatial data from 2021. We implement a difference-in-differences framework with spatial controls to analyze how construction zones affect accident frequency and severity across urban and rural environments.

## Research Questions

1. How does road construction causally impact traffic accident rates?
2. Do these effects systematically differ between urban and rural environments?
3. Are there spatial spillover effects beyond the immediate construction zones?

## Data Sources

- **US Road Construction and Closures Dataset (2021)**: 6.2 million construction records (subset for California) with coordinates, start/end times, severity, and affected distances
- **US Traffic Accidents Dataset (2021)**: Comprehensive accident records with precise locations, timestamps, and severity measures
- **Caltrans State Highway Network**: Annual Average Daily Traffic (AADT) data for normalizing accident rates by traffic volume
- **US Census Bureau Urban Areas**: Official urban/rural classifications for spatial heterogeneity analysis

## Methodological Framework

### Spatial Buffer Analysis

- Created 500m buffer zones around construction locations
- Joined accidents to construction buffers using spatial intersection
- Classified accidents by timing relative to construction (before, during, after)
- Generated a comprehensive panel dataset tracking accidents in each buffer zone over time

### Econometric Models

#### Base Difference-in-Differences Model

```
accident_count_it = α + β₁(treatment_it) + γₜ + δᵢ + ε_it
```

Where:

- `accident_count_it` is the number of accidents in buffer `i` at time `t`
- `treatment_it` is a binary indicator for active construction
- `γₜ` represents time fixed effects
- `δᵢ` represents location fixed effects
- `ε_it` is the error term

#### Heterogeneity Analysis Model

```
accident_count_it = α + β₁(treatment_it) + β₂(treatment_it × urban_i) + γₜ + δᵢ + ε_it
```

This model extends the base specification with an interaction term to capture differential effects between urban and rural areas.

#### Normalized Accident Rate Model

```
accident_rate_it = α + β₁(treatment_it) + γₜ + δᵢ + ε_it
```

Where `accident_rate_it` is the number of accidents per 10,000 vehicles in buffer `i` at time `t`.

#### Spatial Lag Model

To account for spatial dependence, we implemented a spatial lag model:

```
accident_count = β₁(treatment) + β₂(urban) + β₃log(traffic_volume) + ρW(accident_count) + ε
```

Where `ρ` is the spatial lag parameter and `W` is the spatial weights matrix.

#### Spatial Spillover Analysis

```
accident_count_it = α + Σⱼ β_j(distance_band_j × treatment_it) + γₜ + δᵢ + ε_it
```

This model examines how construction impacts extend beyond the immediate construction zone using distance bands (0-500m, 500-1000m, 1-2km, 2-5km, >5km).

#### Event Study Approach

```
accident_count_it = α + Σⱼ β_j(rel_time_j) + γₜ + δᵢ + ε_it
```

Where `rel_time_j` represents time periods relative to construction start, allowing us to test for parallel trends and examine dynamic effects.

## Key Findings

### Overall Construction Effect

- Base DiD model reveals a statistically significant increase in accident counts during construction periods (coefficient = 0.101, p < 0.001)
- Construction activities are associated with approximately 10.1% more accidents compared to non-construction periods

### Urban-Rural Heterogeneity

- Urban areas show a significant increase in accidents during construction (interaction coefficient = 0.163, p < 0.01)
- Rural areas show a slight but non-significant reduction in accidents during construction (base coefficient = -0.005)
- After controlling for traffic volume (normalized rate model), the urban interaction term remains significant (0.110, p < 0.01)

### Spatial Spillover Effects

- Areas within 0-500m of construction sites show a negative but non-significant effect (-0.064)
- Strongest positive effects appear in the 500-1000m band (0.308, p < 0.001) and 1-2km band (0.312, p < 0.001)
- Even the 2-5km band shows a smaller but still significant effect (0.139, p < 0.001)

### Spatial Autocorrelation

- Spatial lag model confirms significant spatial autocorrelation (ρ = 0.765, p < 0.001)
- After accounting for spatial dependence, the treatment effect remains positive and significant (0.622, p < 0.001)

### Temporal Dynamics

- Event study results show that locations selected for construction have different accident patterns long before construction begins
- During and after construction, coefficients remain close to zero and statistically insignificant
- Supports the parallel trends assumption necessary for causal interpretation of DiD estimates

### Accident Severity

- Severity analysis shows a consistent distribution of accident severity levels across different construction periods
- Approximately 87% moderate severity, 12% serious, and <1% slight or fatal across all periods
- Construction affects accident frequency but not the proportional severity distribution

## Implications for Transportation Safety

### Resource Allocation

- Traffic management resources should be allocated differentially between urban and rural construction zones
- Urban areas require more intensive intervention given their significantly larger construction effects

### Extended Safety Zones

- Safety measures should extend beyond immediate construction zones to address the higher accident risks in transition areas
- Particular attention should be paid to the 500m-2km zones around construction sites

### Temporal Planning

- Enhanced safety measures may be particularly important during specific phases of construction projects
- Long-term planning should consider selection effects in areas chosen for construction

### Severity-Focused Strategies

- Since severity distribution remains consistent, general accident prevention measures may be more effective than severity-specific interventions

## Limitations and Future Research

- Analysis limited to 2021 data, which may have been affected by pandemic-related traffic patterns
- Limited granularity in urban/rural classification (potential for more detailed categorizations)
- Construction type differentiation not consistently available
- Weather and seasonal effects not explicitly modeled
- Potential endogeneity concerns despite DiD framework

## File Description

- `final_MoritzPeistNoemiLucchiSimonVellin.Rmd`: Main R Markdown file containing all code and analysis
