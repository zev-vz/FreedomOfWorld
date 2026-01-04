library(readxl)
library(dplyr)
library(stringr)

#Loading excel file from Fraser
data <- read_excel(
  "economic-freedom-of-the-world-2025-master-index-data-for-researchers-iso.xlsx"
)
#Dropping raw data columns
new_data <- data |>
  select(-contains("data", ignore.case = TRUE))

#Dropping components of names to make them more appealing
names(new_data) <- sub("^[^ ]+\\s+", "", names(new_data))
names(new_data) <- sub("^\\d+\\s+", "", names(new_data))

#Dropping rank variables
new_data <- new_data |>
  select(-contains("Rank", ignore.case = TRUE))

#Saving the data as a CSV
write.csv(new_data, "cleaned_data.csv", row.names = FALSE)
