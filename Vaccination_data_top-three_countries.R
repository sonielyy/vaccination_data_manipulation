# R Script Data/Package Configurations

install.packages("readr") # for Read CSV
library(readr)

instal.packages("dplyr") # for Pipes & Data Manipulation
library(dplyr) 

install.packages("tidyr") # for Data Cleaning
library(tidyr)

# Set working directory for importing CSV
setwd("C:/Users/PC/Documents/R_WorkFiles")

country_vacc_data <- read_csv("country_vaccination_stats.csv") # Data Uploading
View(country_vacc_data)
str(country_vacc_data)

# All the NA data is only at 'daily_vaccations' column, so we will return the rows which have values(not NAs).
country_vacc_data_not_NA <- country_vacc_data[complete.cases(country_vacc_data$daily_vaccinations),]
any(is.na(country_vacc_data_not_NA))

# New DF has the minimum values
View(country_vacc_data_not_NA)
country_vacc_data_min_vacc <- country_vacc_data_not_NA %>%
  group_by(country) %>%
  summarise(min_daily_vaccinations = min(daily_vaccinations, na.rm = TRUE))

# Convert the NA daily_vaccinations to minimum values (if minimum value exists)
country_vacc_data_v3 <- country_vacc_data %>%
  left_join(country_vacc_data_min_vacc, by="country") %>%
  mutate(daily_vaccinations = coalesce(daily_vaccinations, min_daily_vaccinations)) %>%
  select(-min_daily_vaccinations)

# Convert the NA daily_vaccinations to zero (minimum does not exist)
country_vacc_data_v4 <- country_vacc_data_v3 %>%
  mutate(daily_vaccinations = replace_na(daily_vaccinations, 0))

# There is not any NA values
any(is.na(country_vacc_data_v4))
View(country_vacc_data_v4)
############################################################################### P2

# Find the median values of countries
country_vacc_data_median <- country_vacc_data_v4 %>%
  group_by(country) %>%
  summarise(median_vacc = median(daily_vaccinations, na.rm = TRUE))

country_vacc_data_median[order(country_vacc_data_median$median_vacc, decreasing = TRUE), ][1:3,]
