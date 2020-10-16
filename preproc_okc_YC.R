library(tidyverse)
library(lubridate)

profiles_raw <- read_csv('./okcupid_profiles.csv')
cali_coords_raw <- read_csv('./california_city_coords.csv')

# profiles: add ID column
profiles_raw <- rowid_to_column(profiles_raw, "ID")

# profiles: add new metrics based on original columns
profiles_raw %>%
  separate(col = 'location', sep = ',', into = c('geo1','geo2')) %>%
  mutate(age_group = ifelse(age <= 29, '18-29', 
                            ifelse(age >= 30 & age <=49, '30-49',
                                   ifelse(age >=50 & age <=64, '50-64', '65+'))),
         ethnicity = ifelse(str_detect(ethnicity, pattern = ','), 'two or more', 
                            ifelse(ethnicity == 'indian', 'asian', ethnicity)),
         geo2 = str_trim(string = geo2, side = 'both'),
         geo1_join = str_c(str_trim(
           str_replace(
             geo1,'city', replacement = ''), side = 'both'),'city', sep = ' '),
         local = ifelse(geo2 == 'california', T, F),
         last_online = ymd_hm(last_online),
         time_offline = time_length(ymd_hm('2012-07-01-00-00')-last_online, unit='day'),
         activeness = ifelse(time_offline <=3,'very active', 
                             ifelse(time_offline>30,'inactive','active'))) %>%
  filter(geo2 == 'california') -> profiles_intermed

data.frame(unique(profiles_intermed$geo1)) -> cities
data.frame(unique(profiles_intermed$geo1_join)) -> cities_join

# profiles: convert all 'essay' columns to boolean, T if answered, F if left blank
profiles_intermed[, paste0('essay', as.character(c(0:9)))] <-
  ifelse(is.na(profiles_intermed[, paste0('essay', as.character(c(0:9)))]),F,T)

# profiles: sum up the 'essay' columns, and remove unnecessary columns
profiles_intermed %>%
  mutate(
    n_q_answered = rowSums(.[, paste0('essay', as.character(c(0:9)))])
    ) %>%
  select(-paste0('essay', as.character(c(0:9))),
         -body_type, -diet, -drinks, -drugs, -education, -income, -job,
         -religion, -sign, -smokes, -speaks, -offspring) -> profiles_final

data.frame(unique(profiles_intermed$geo1_join)) -> cities
data.frame(unique(citycoords$Location)) -> cali_city
data.frame(unique(citycoords$Location)) -> cali_city_original

# cali coordinates: check for duplicates
cali_coords_raw %>%
  group_by(Location) %>%
  summarise(count = n()) %>%
  filter(count >1) -> dup_check
# cali coordinates: remove dupate and create join column
cali_coords_raw %>%
  group_by(Location) %>%
  filter(row_number()==1) %>%
  mutate(Location_join = str_c(
    str_trim(
      str_replace_all(
        string = str_to_lower(Location),
        c(' city' = '', ' town' = '')), side = 'both'), 'city', sep = ' ')
    ) -> cali_coords_intermed


left_join(x = profiles_intermed,
          y = cali_coords_intermed,
          by = c('geo1_join' = 'Location_join')) -> test


data.frame(unique(
  test[ , c('geo1','geo2','geo1_join','Location','Latitude','Longitude')])
  ) -> cities_postjoin

cities_postjoin %>%
  filter(is.na(Latitude)) -> null_geo


nrow(profiles_final[profiles_final$income==-1, ])

profiles_final %>%
  ggplot(aes(x=age_group)) + geom_bar()
profiles_final %>%
  ggplot(aes(x=ethnicity)) + geom_bar()
profiles_final %>%
  ggplot(aes(x=education)) + geom_bar() + coord_flip()
profiles_final %>%
  ggplot(aes(x=ethnicity)) + geom_bar()
profiles_final %>%
  ggplot(aes(x=age)) + geom_histogram()
profiles_final %>%
  ggplot(aes(x=height,color=sex)) + geom_histogram() + facet_wrap(.~sex)