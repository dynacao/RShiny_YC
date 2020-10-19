library(tidyverse)
library(lubridate)

profiles_raw <- read_csv('./okcupid_profiles.csv')
cali_coords_raw <- read_csv('./california_city_coords.csv')

# profiles: add ID column
profiles_raw <- rowid_to_column(profiles_raw, "ID")

# profiles: change or create variables
profiles_raw %>%
  separate(col = 'location', sep = ',', into = c('geo1','geo2')) %>%
  mutate(age_group = ifelse(age <= 29, '18-29', 
                            ifelse(age >= 30 & age <=49, '30-49',
                                   ifelse(age >=50 & age <=64, '50-64', '65+'))),
         body_type = ifelse(body_type == 'rather not say' | is.na(body_type), F, T),
         diet = ifelse(is.na(diet), F, T),
         drinks = ifelse(is.na(drinks), F, T),
         drugs = ifelse(is.na(drugs), F, T),
         education = ifelse(is.na(education), F, T),
         ethnicity = ifelse(is.na(ethnicity), F, T),
         height = ifelse(height < 22 | is.na(height), F, T), # shortest human on earth is about 22 inches
         income = ifelse(income<0 | is.na(income), F, T),
         job = ifelse(job == 'rather not say' | is.na(job), F, T),
         geo2 = str_trim(string = geo2, side = 'both'),
         last_online = ymd_hm(last_online),
         days_offline = round(time_length(ymd_hm('2012-07-01-00-00',tz = 'PST')-last_online, unit='day'), 1),
         activeness = ifelse(days_offline <=3,'very active', 
                             ifelse(days_offline>30,'inactive','active')),
         offspring = ifelse(is.na(offspring), F, T),
         pets = ifelse(is.na(pets), F, T),
         religion = ifelse(is.na(religion), F, T),
         sign = ifelse(is.na(sign), F, T),
         smokes = ifelse(is.na(smokes), F, T),
         speaks = ifelse(is.na(speaks), F, T)) %>%
  filter(geo2 == 'california') -> profiles_intermed

# profiles: convert all 'essay' columns to boolean, T if answered, F if left blank
profiles_intermed[, paste0('essay', as.character(c(0:9)))] <-
  ifelse(is.na(profiles_intermed[, paste0('essay', as.character(c(0:9)))]), F, T)

# cali coordinates: check for duplicates
cali_coords_raw %>%
  group_by(Location) %>%
  summarise(count = n()) %>%
  filter(count >1)

# cali coordinates: remove duplicate and create join column
cali_coords_raw %>%
  group_by(Location) %>%
  filter(row_number()==1) %>%
  mutate(location_join=str_to_lower(Location)) -> cali_coords_intermed

# profiles: finalize data file
profiles_intermed %>%
  left_join(y = cali_coords_intermed, by = c('geo1' = 'location_join')) %>%
  mutate(ess_answs = rowSums(.[, paste0('essay', as.character(c(0:9)))]),
         total_answs = rowSums(.[, c(6:14, 18:33)]) ) %>%
  select(-paste0('essay', as.character(c(0:9))), -Location) -> profiles_final

write_csv(profiles_final, path = './clean_data_okc_YC.csv')
