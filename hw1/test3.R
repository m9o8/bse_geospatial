library(censobr)
library(tidyverse)


# return data as arrow Dataset
pop_2010 <- read_population(
  year = 2010,
  # columns = c("code_state", "code_region", "code_muni", "V0010"),
  showProgress = FALSE,
  as_data_frame = TRUE,
  # cache = FALSE
)

pop_1980 <- read_population(
  year = 1980,
  # columns = c("code_meso", "code_region", "code_state", "code_muni", "V198"),
  showProgress = FALSE,
  as_data_frame = TRUE,
  cache = FALSE
)

pop_1960 <- read_population(
  year = 1960,
  columns = c("code_muni_1960", "censobr_weight"),
  showProgress = FALSE,
  as_data_frame = TRUE,
  # cache = FALSE
)

df %>%
  summarise(total_population = sum(V0010, rm.na = TRUE))

pop_1980 %>%
  mutate(V198 = as.numeric(V198)) %>%
  summarise(total_population = sum(V198, rm.na = TRUE))
# group_by(code_region) %>%
# summarise(total_population = sum(V0010, rm.na = TRUE))


pop_1980 %>%
  select(V601, V602, V603, V604, V605) %>%
  head()
