## Art, Poverty and Education Within States ##
## 6/16/24 ##

library(here)
library(tidyverse)
library(readxl)
library(openxlsx)
library(janitor)
library(zoo)
library(sjmisc)
library(kableExtra)
library(ggpubr)
library(usmap)


## Importing arts data ##
# Data comes from 2020 National Endowment for the Arts Basic Survey
# https://www.arts.gov/impact/research/arts-data-profile-series/adp-32


# Importing files into list
fileList <- list.files(pattern='*.xlsx', recursive = TRUE)
dflist <- lapply(fileList, read_excel)
dflist <- dflist[-1]

#Specific DF in list needs specific instruction for titles of columns
dflist[[8]] <- row_to_names(dflist[[8]], row_number = 2)


#Changing name of State column
new_col_name <- "state"
dflist <- lapply(dflist, function(df) {
  names(df)[1] <- new_col_name
  df
})

#Joining all DFs in list by state and removing Standard Error columns
arts_df <- dflist %>%
  reduce(left_join, by = "state") %>%
  drop_na %>%
  select(!(starts_with("Standard error")))

# Changing column type
arts_df <- arts_df %>%
  mutate(across(-c(state), as.numeric))

# Cleaning variable names - keeping original names for complete data reference
original_names_arts <- as.list(names(arts_df))

#renaming variables for easier analysis
names(arts_df)[2] <- "%_who_create_visual_art"
names(arts_df)[3] <- "%_do_leather/wood/metal_fabric_work"
names(arts_df)[4] <- "%_who_play_instrument"
names(arts_df)[11] <- "%_who_read_literature"
names(arts_df)[12] <- "%_who_use_device_to_watch__download_listen_to_art"

arts_df <- clean_names(arts_df, case ="snake",)












## Importing Census data ## 
# Data originates from US Census Website - coded ACSST5Y2020.S1701


raw_census <- read_excel(
  here("Data", "ACSST5Y2020.S1701.xlsx"), 
  sheet = "Data")

raw_census


# To deal with the multiple levels of column headers in the excel file I utilized this
# solution from https://paul.rbind.io/2019/02/01/tidying-multi-header-excel-data-with-r/.

#Importing header rows - replacing blank col names with NA
head1 <- read_excel(here("Data", "ACSST5Y2020.S1701.xlsx"), sheet = "Data", 
                    col_names = TRUE) %>% 
  names() %>% 
  str_replace("\\d+", NA_character_)

head1


head2 <- read_excel(here("Data", "ACSST5Y2020.S1701.xlsx"), sheet = "Data", 
                    skip = 1, col_names = TRUE) %>% 
  names() %>% 
  str_replace("^\\.{3}", NA_character_)

head2 <- head2 %>% str_remove("\\.+\\d+$")

head2


# very useful - na.locf0 replaces each NA with the most recent non-NA prior to it.
head1 <- tibble(head1) %>% 
  mutate(head1 = zoo::na.locf0(head1)) %>% 
  pull()

head1

ncols <- ncol(raw_census)


# combines head1 and head2 into headers list using map_chr
headers <- map_chr(1:ncols, ~ {
  case_when(
    !is.na(head1[.x]) & !is.na(head2[.x]) ~ paste(head1[.x], head2[.x], sep = "_"),
    TRUE ~ head2[.x]
  )
})

headers

# importing data without first two rows, using created headers as col names
raw_census <- read_excel(here("Data", "ACSST5Y2020.S1701.xlsx"), sheet = "Data", 
                         skip = 2, col_names = headers)

#altering name of first column
names(raw_census)[1] <- "variable"
#removing first row - it is all NA
raw_census <- raw_census %>% slice(-1)
raw_census <- clean_names(raw_census)


raw_census

# transposing data and cleaning names
census_transp <- raw_census %>% rotate_df(cn=TRUE)
census_transp <- clean_names(census_transp, case ="snake")

view(census_transp)


##creating a table for each subset of population - total, below poverty, percent below##
census_transp <- rownames_to_column(census_transp, var = "state")


#filtering by "total"
total <- census_transp %>%
  filter(grepl("total", state))

#filtering by "below_poverty_level"
census_below <- census_transp %>%
  filter(!grepl("percent_below_poverty_level", state)) %>%
  filter(!grepl("total", state))

#filtering by "percent_below_poverty_level"
census_percent <- census_transp %>%
  filter(grepl("percent_below_poverty_level", state))


#list of census df
census_list <- list(total, census_below, census_percent)



#cleaning state names
census_list <- lapply(census_list, FUN=function(x){
  x%>%
    mutate(state = str_remove(state, "_total|_below_poverty_level|_percent_below_poverty_level"))
})

# need to have states capitalized for merge with Arts DF
census_list <- census_list %>%
  map(~mutate_at(.x, "state", str_replace_all,"_"," "))


census_list <- census_list %>%
  map(~mutate_at(.x, "state", str_to_title))

census_list[[1]]$state




#changing names of columns that are confusing/related to employment
census_list <- lapply(census_list, rename, 
                      "employed_male" = "male_2","employed_female" = "female_2", 
                      "unemployed_male" = "male_3", "unemployed_female" = "female_3",
                      )


# removing col with NA
census_list <- lapply(census_list, FUN=function(y){
    Filter(function(x) !all(is.na(x)), y)
})


names_change <- grep("_percent_of_poverty_level", names(census_list[[1]]))
names(census_list[[1]])[names_change] <- paste0("income_below", 
                                                names(census_list[[1]])[names_change])
names(census_list[[1]])[names_change] <- str_replace(names(census_list[[1]])[names_change], 
                                                     "x", "_")

names_change <- grep("_percent_of_poverty_level", names(census_list[[2]]))
names(census_list[[2]])[names_change] <- paste0("income_below", 
                                                names(census_list[[2]])[names_change])
names(census_list[[2]])[names_change] <- str_replace(names(census_list[[2]])[names_change], 
                                                     "x", "_")

names_change <- grep("_percent_of_poverty_level", names(census_list[[3]]))
names(census_list[[3]])[names_change] <- paste0("income_below", 
                                                names(census_list[[3]])[names_change])
names(census_list[[3]])[names_change] <- str_replace(names(census_list[[3]])[names_change], 
                                                     "x", "_")




names(census_list[[1]])[48:49] <- str_replace(names(census_list[[1]])[48:49], 
                                        "4", "unrelated_individuals_") 

names(census_list[[1]])[50:58] <- str_replace(names(census_list[[1]])[50:58], 
                                              "x", "unrelated_individuals_")


names(census_list[[2]])[48:49] <- str_replace(names(census_list[[1]])[48:49], 
                                              "4", "unrelated_individuals_") 

names(census_list[[2]])[50:58] <- str_replace(names(census_list[[1]])[50:58], 
                                              "x", "unrelated_individuals_")


names(census_list[[3]])[48:49] <- str_replace(names(census_list[[1]])[48:49], 
                                              "4", "unrelated_individuals_") 

names(census_list[[3]])[50:58] <- str_replace(names(census_list[[1]])[50:58], 
                                              "x", "unrelated_individuals_")


census_list <- lapply(census_list, rename, 
                      "unrelated_individuals_did_not_work_past_12_m" = "did_not_work_2"
)





#parsing out three list tables
census_total<- census_list[[1]]
census_total_below <- census_list[[2]]
census_percent_below <- census_list[[3]]



#removing percentage and dividing by 100 to convert to numeric
census_percent_below[, -(1)] <- apply(census_percent_below[, -(1)], 2, str_replace, "%", "")

census_percent_below[, -(1)] <- 
  apply(census_percent_below[, -(1)], 2, as.numeric) / 100 

#removing na values
census_percent_below <-  Filter(function(x)!all(is.na(x)), census_percent_below)
  




#converting to numeric for total and below_poverty
census_total <- apply(census_total, 2, str_replace_all, ",", "")

census_total <- data.frame(census_total) %>%
  mutate_at(c(2:ncol(census_total)),as.numeric)


census_total_below <- apply(census_total_below, 2, str_replace_all, ",", "")

census_total_below <- data.frame(census_total_below) %>%
  mutate_at(c(2:ncol(census_total_below)),as.numeric)

census_total_below <-  Filter(function(x)!all(is.na(x)), census_total_below)







# Joining Arts data and Census data for each type of census DF

census_arts_df_total <- left_join(census_total, arts_df, "state")
census_arts_total_below <- left_join(census_total_below, arts_df, "state")
census_arts_percent_below <- left_join(census_percent_below, arts_df, "state")






## Writing finished data sets to folder ##

write_rds(census_total,file = here("Data Export", 
                                    "Census_Poverty_Data_Total_Pop.rds"))

write_rds(census_total_below,file = here("Data Export", 
                                   "Census_Poverty_Data_Total_below.rds"))

write_rds(census_percent_below,file = here("Data Export", 
                                   "Census_Poverty_Data_Percentage_below.rds"))

write_rds(census_arts_df_total,file = here("Data Export", 
                                   "CensusArts_Poverty_Data_Total_Pop.rds"))

write_rds(census_arts_total_below,file = here("Data Export", 
                                         "CensusArts_Poverty_Data_Total_below.rds"))

write_rds(census_arts_percent_below,file = here("Data Export", 
                                           "CensusArts_Poverty_Data_Percentage_below.rds"))

write_rds(arts_df, file = here("Data Export", 
                                "ArtsDF.rds"))







## Taking a look at the data ##


# states with highest poverty rate
census_percent_below %>%
  arrange(desc(population_for_whom_poverty_status_is_determined)) %>%
  select(state, population_for_whom_poverty_status_is_determined)


#states with least highest high school graduate rates            
census_arts_percent_below %>%
  arrange(desc(less_than_high_school_graduate)) %>%
  select(state, less_than_high_school_graduate)


#states with lowest high school graduation per estimated population
census_total %>%
  mutate(non_highschool_per_population = 
           (less_than_high_school_graduate/population_for_whom_poverty_status_is_determined),
         .by = c(state,less_than_high_school_graduate,
                 population_for_whom_poverty_status_is_determined),
         .keep = "none") %>%
  arrange(desc(non_highschool_per_population)) %>%
  kbl() %>%
  kable_styling()


#poverty rates by race
census_percent_below %>%
  select(state,white_alone,black_or_african_american_alone,
         american_indian_and_alaska_native_alone,asian_alone,
         native_hawaiian_and_other_pacific_islander_alone, some_other_race_alone, 
         two_or_more_races,hispanic_or_latino_origin_of_any_race,
         white_alone_not_hispanic_or_latino) %>%
  view()




ggplot(census_arts_percent_below, 
       aes(population_for_whom_poverty_status_is_determined,
           percent_who_read_literature, na.remove = TRUE)) + 
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(labels = scales::percent, limits = c(NA,.20)) +
  geom_point() + 
  ggtitle("Reading vs Poverty by State") +
  geom_smooth(method = "lm", se = FALSE) +
  stat_cor(method = "pearson", label.x = .16, label.y = .60)


  
ggplot(arts_df, aes(state, percent_who_create_visual_art)) + 
  geom_col(fill = "darkgreen") + scale_y_continuous(labels = scales::percent) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), 
        panel.background = element_blank(),
        axis.line = element_line(colour = "black")) + 
  ggtitle("Percent of People Who Create Visual Art by State") + xlab("State") +
  ylab("Percent who create visual art") 
  
  
ggplot(arts_df, aes(state, percent_do_leather_wood_metal_fabric_work)) + 
  geom_col(fill = "darkgreen") + scale_y_continuous(labels = scales::percent) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), 
        panel.background = element_blank(),
        axis.line = element_line(colour = "black")) + 
  ggtitle("Percent of People Who do Leather, Wood, Metal or Fabric Work") + xlab("State") +
  ylab("")

ggplot(arts_df, aes(state, percent_who_play_instrument)) + 
  geom_col(fill = "darkgreen") + scale_y_continuous(labels = scales::percent) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), 
        panel.background = element_blank(),
        axis.line = element_line(colour = "black")) + 
  ggtitle("Percent of People who Play an Instrument") + xlab("State") +
  ylab("") 



#mean across columns - a kind of rough general arts participation rate metric
arts_df <- arts_df %>%
  mutate(arts_average = rowMeans(arts_df[,(-1)])) %>%
  view()

# removing states with NA values (not complete averages)
arts_df %>%
  select(c(state, arts_average)) %>%
  na.omit() %>%
  view()



# A few map plots

#Percentage determined as poor
plot_usmap(data = census_arts_percent_below, 
           values = "population_for_whom_poverty_status_is_determined", 
           regions = "states", color = "darkblue") + 
  scale_fill_continuous(low = "white", high = "darkblue", 
                        name = "Poverty Percentage", 
                        labels = scales::label_percent()) +
  labs(title = "U.S. State Poverty Level") + 
  theme(panel.background=element_blank())


# Percentage who create visual art
plot_usmap(data = census_arts_percent_below, 
           values = "percent_who_create_visual_art", 
           regions = "states", color = "green") + 
  scale_fill_continuous(low = "white", high = "green", 
                        name = "Percent Who Create Visual Art", 
                        labels = scales::label_percent()) +
  labs(title = "Percentage of Population who Create Visual Art") + 
  theme(panel.background=element_blank())



# Percentage who read literature
plot_usmap(data = census_arts_percent_below, 
           values = "percent_who_read_literature", 
           regions = "states", color = "forestgreen") + 
  scale_fill_continuous(low = "white", high = "forestgreen", 
                        name = "Percentage", 
                        labels = scales::label_percent()) +
  labs(title = "Percent Who Read Literature") + 
  theme(panel.background=element_blank())









  







