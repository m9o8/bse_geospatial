# 1) scrape data for the traffic volume 
scrape_caltrans_cleaned <- function() {
  library(rvest)
  library(httr)
  library(tidyverse)
  
  main_page_url <- "https://dot.ca.gov/programs/traffic-operations/census/traffic-volumes/2017"
  main_page <- read_html(main_page_url)
  route_links <- main_page %>%
    html_nodes("a") %>%
    html_attr("href") %>%
    na.omit() %>%
    unique() %>%
    .[grepl("route-", .)]
  route_links <- ifelse(grepl("^http", route_links),
                        route_links,
                        paste0("https://dot.ca.gov", route_links))
  all_route_data <- list()
  columns_of_interest <- c(
    "dist", "rte", "co", "post_mile", "description",
    "back_peak_hour", "back_peak_month", "back_aadt",
    "ahead_peak_hour", "ahead_peak_month", "ahead_aadt")
  for (link in route_links) {
    response <- tryCatch({
      GET(link, timeout(60), add_headers(`User-Agent` = "Mozilla/5.0"))
    }, error = function(e) return(NULL))
    
    if (is.null(response) || status_code(response) != 200) {
      cat("Error dowloading", link, "\n")
      next
    }
    page <- read_html(content(response, "text"))
    all_tables <- html_nodes(page, "table")
    if (length(all_tables) == 0) next
    route_data <- lapply(all_tables, function(tbl) {
      df <- html_table(tbl, fill = TRUE)
      # clean column names 
      colnames(df) <- gsub(" ", "_", tolower(colnames(df)))
      # keep only columns defined above 
      df <- df %>%
        select(any_of(columns_of_interest))
      return(df)})
    
    route_df <- bind_rows(route_data)
    route_df$route_page <- gsub(".*/(route-.*)", "\\1", link)
    all_route_data[[route_df$route_page[1]]] <- route_df
    Sys.sleep(1)}
  combined_data <- bind_rows(all_route_data)
  # convert to numeric 
  numeric_cols <- c("back_peak_hour", "back_peak_month", "back_aadt",
                    "ahead_peak_hour", "ahead_peak_month", "ahead_aadt")
  for (col in numeric_cols) {
    if (col %in% colnames(combined_data)) {
      combined_data[[col]] <- as.numeric(gsub(",", "", combined_data[[col]]))}}
  return(combined_data)}

# scrape 
caltrans_traffic_clean <- scrape_caltrans_cleaned()


# 2) load roads - I changed to 2017 since traffic volume was referred to 2017
ca_roads <- primary_secondary_roads("CA", year = 2017)

# extract the number of the route from FULLNAME (in ca_roads)
ca_roads_with_route <- ca_roads %>%
  mutate(
    route_number = case_when(
      grepl("\\d+", FULLNAME) ~ as.numeric(gsub(".*?(\\d+).*", "\\1", FULLNAME)),
      # when there is any number assign 'NA'
      TRUE ~ NA_real_))

# verify how many number of routes have been extracted 
cat("Number of roads with route number:", sum(!is.na(ca_roads_with_route$route_number)), "out of", nrow(ca_roads_with_route), "\n")

# prepare aggregare traffic volume data per route_number
traffic_data_aggregated <- caltrans_traffic_clean %>%
  mutate(across(c(back_aadt, ahead_aadt, back_peak_hour, ahead_peak_hour), 
                ~as.numeric(as.character(.)))) %>%
  # average at route level and county level
  group_by(rte, co) %>%
  summarize(
    # average AADT considering both 'back' and 'ahead'
    segment_avg_aadt = mean(c(back_aadt, ahead_aadt), na.rm = TRUE),
    
    # handle NaNs
    segment_avg_aadt = if(is.nan(segment_avg_aadt)) {
      mean(c(back_aadt[!is.na(back_aadt)], ahead_aadt[!is.na(ahead_aadt)]), na.rm = TRUE)
    } else {segment_avg_aadt},
    
    # compute average peak hour traffic volume
    segment_avg_peak_hour = mean(c(back_peak_hour, ahead_peak_hour), na.rm = TRUE),
    
    # handle NaNs
    segment_avg_peak_hour = if(is.nan(segment_avg_peak_hour)) {
      mean(c(back_peak_hour[!is.na(back_peak_hour)], ahead_peak_hour[!is.na(ahead_peak_hour)]), na.rm = TRUE)
    } else {segment_avg_peak_hour},
    
    # count segments 
    segments = n(),
    .groups = "drop"
  ) %>%
  # aggregate at route_number level
  group_by(rte) %>%
  summarize(
    # weighted average per number of segments 
    traffic_volume = weighted.mean(segment_avg_aadt, segments, na.rm = TRUE),
    peak_hour = weighted.mean(segment_avg_peak_hour, segments, na.rm = TRUE),
    total_segments = sum(segments),
    counties = n_distinct(co),
    .groups = "drop") %>%
  # handle NaNs
  mutate(
    traffic_volume = if_else(is.nan(traffic_volume), NA_real_, traffic_volume),
    peak_hour = if_else(is.nan(peak_hour), NA_real_, peak_hour)) %>%
  # rename 'rte' in 'route_number'
  rename(route_number = rte)

# add this data to the original dataset
ca_roads_with_traffic <- ca_roads_with_route %>%
  left_join(
    traffic_data_aggregated %>% select(route_number, traffic_volume, peak_hour),
    by = "route_number")


# 3) visualization
library(ggplot2)
library(sf)
library(viridis)
library(ggpubr)

map_traffic_volume <- ggplot() +
  geom_sf(data = ca_roads_with_traffic, color = "gray80", size = 0.3) +
  geom_sf(data = ca_roads_with_traffic %>% filter(!is.na(traffic_volume)), 
          aes(color = traffic_volume), 
          size = 0.5) +
  scale_color_viridis_c(
    name = "AADT",
    option = "plasma",
    labels = scales::comma) +
  theme_bw() +
  labs(title = "Traffic volume in California - 2017",
    subtitle = "Annual Average Daily Traffic (AADT)")

print(map_traffic_volume)

