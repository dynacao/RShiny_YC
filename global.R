library(shiny)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(leaflet)
library(DT)

okc <- read_csv('clean_data_okc_YC.csv')
rename(okc, age_raw = age, age = age_group) -> okc

# create a data subset for mapping
okc %>%
  group_by(geo1, Latitude, Longitude, activeness) %>%
  filter(is.na(Latitude)==F) %>%
  summarise(n_profiles = n()) -> okc_map

# prepare tooltip
map_tooltip <- paste(
  "City/Town/Area: ", str_to_title(okc_map$geo1), "<br/>", 
  "# of Profiles: ", okc_map$n_profiles, "<br/>") %>%
  lapply(htmltools::HTML)

# prepare question table
okc %>%
  summarise(bodytype = mean(body_type), diet = mean(diet), drinks = mean(drugs),
            educ = mean(education), ethn = mean(ethnicity), drugs = mean(drugs),
            height = mean(height), income = mean(income), job = mean(job), kids = mean(offspring), 
            pets = mean(pets), religion = mean(religion),
            sign = mean(sign), smoke = mean(smokes), langs = mean(speaks) ) %>%
  pivot_longer(col=c(bodytype:langs), names_to = 'question', values_to = 'percentage') %>%
  arrange(desc(percentage)) -> okc_ques_compl

# prepare data table
okc %>% select(ID, age_raw, age, sex, status, orientation, geo1, 
               last_online, days_offline, activeness, ess_answs, total_answs) %>%
  mutate(geo1 = str_to_title(geo1))-> okc_dt

# create text block for the about data tab
about_data <- HTML(paste(
  "Name: San Francisco OKCupid Users","<br/>",
  "Sample Type: volunteered sample","<br/>",
  "Abstract: This dataset was created with the use of a python script that pulled the data from public profiles on www.okcupid.com. It has an n=59946, which includes people within a 25 mile radius of San Francisco, who were online in the last year (06/30/2011) and had an account on 06/26/2012, with at least one profile picture","<br/>",
  "Source: Data scraped from public profiles on www.okcupid.com on 06/30/2012. Permission to use this data was obtained from OkCupid president and co-founder Christian Rudder under the condition that the dataset remains public.","<br/>",
  "Essential Questions: age, sex, status, orientation","<br/>",
  "Multiple-Choice Questions (Optional): body type, diet, drinks, drugs, education, ethinicity, height, income, job, offspring, pets, religion, sign, smokes, speaks" ,"<br/>",
  "Short-Answer Questions (Optional): 0. My self summary/ 1. What I'm doing with my life/ 2. I'm really good at/ 3. The first thing people usually notice about me/ 4 Favorite books, movies, show, music, and food/ 5. The six things I could never do without/ 6. I spend a lot of time thinking about/ 7. On a typical Friday night I am/ 8.The most private thing I am willing to admit/ 9. You should message me if...","<br/>",
  "Detailed informatin about the data can be found here: https://github.com/rudeboybert/JSE_OkCupid","<br/>",
  sep = '<br/>')
)