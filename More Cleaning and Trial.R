install.packages("maps")  

library(ggplot2)
library(dplyr)
library(maps)
library(sf)
library(viridis)

#Loading Data
new_data <- read.csv("cleaned_data.csv", stringsAsFactors = FALSE)
names(new_data)

#Identifying things to rename
world_map <- map_data("world")

new_data$Countries <- trimws(new_data$Countries)

dataset_countries <- sort(unique(new_data$Countries))
unique_countries <- unique(world_map$region)

dataset_not_in_map <- setdiff(dataset_countries, unique_countries)
dataset_not_in_map
dataset_countries
unique_countries

rename_map <- c(
  "Bahamas, The"="Bahamas","Brunei Darussalam"="Brunei","Cabo Verde"="Cape Verde",
  "Congo, Dem. Rep."="Democratic Republic of the Congo","Congo, Rep."="Republic of Congo",
  "Côte d'Ivoire"="Ivory Coast","Czechia"="Czech Republic","Egypt, Arab Rep."="Egypt",
  "Gambia, The"="Gambia","Iran, Islamic Rep."="Iran","Korea, Rep."="South Korea",
  "Kyrgyz Republic"="Kyrgyzstan","Lao PDR"="Laos","Russian Federation"="Russia",
  "Slovak Republic"="Slovakia","Syrian Arab Republic"="Syria","Türkiye"="Turkey",
  "United Kingdom"="UK","United States"="USA","Venezuela, RB"="Venezuela",
  "Yemen, Rep."="Yemen","Eswatini"="Swaziland"
)

idx <- new_data$Countries %in% names(rename_map)
new_data$Countries[idx] <- rename_map[new_data$Countries[idx]]

write.csv(new_data, "final_data.csv", row.names = FALSE)

#Trial Chloropleth
trial_data <- new_data |>
  filter(Year == 2023)

plot_data <- trial_data |>
  group_by(Countries) |>
  summarise(value = mean(Tariffs, na.rm = TRUE))

map_df <- world_map |>
  left_join(plot_data, by = c("region" = "Countries")) |>
  filter(region != "Antarctica")

ggplot(map_df, aes(x = long, y = lat, group = group, fill = value)) +
  geom_polygon(color = "gray70", linewidth = 0.1) +
  coord_quickmap() +
  scale_fill_viridis_c(na.value = "white") +
  theme_void() +
  labs(fill = "Value")

